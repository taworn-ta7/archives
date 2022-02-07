'use strict';
const path = require('path');
const fs = require('fs');
const mkdirp = require('mkdirp');
const mime = require('mime-types');
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { logger, RestError, errors, uploads } = require('../libs');
const entities = require('../entities');
const { dump, authen } = require('../middlewares');
const { reduceUser } = require('../utils/authen');



// ----------------------------------------------------------------------
// Update
// ----------------------------------------------------------------------

/**
 * Upload a profile icon.
 */
router.post('/profile/icon', [
	authen.required,
	uploads.single('image'),
	dump.headers,
], asyncHandler(async (req, res, next) => {
	// select
	const user = await entities.Users.findByPk(req.user.id);

	// check upload image
	const image = req.file;
	if (!image)
		throw new RestError(StatusCodes.BAD_REQUEST, errors.noUploadFile);
	logger.verbose(`${req.id} image: ${debugFormat(image, true)}`);
	if (image.mimetype !== 'image/png' && image.mimetype !== 'image/jpeg' && image.mimetype !== 'image/gif')
		throw new RestError(StatusCodes.BAD_REQUEST, errors.uploadFileIsNotType, { context: 'image' });
	if (image.size >= +process.env.PROFILE_ICON_FILE_LIMIT)
		throw new RestError(StatusCodes.BAD_REQUEST, errors.uploadFileIsTooLarge);

	// create directory, if not exists
	const dir = path.join(process.env.STORAGE_PATH, req.user.id, 'profile');
	logger.verbose(`${req.id} directory: ${dir}`);
	await mkdirp(dir);

	// generate output
	const name = `icon`;
	const part = `/files/${req.user.id}/profile`;
	const host = req.get('host');
	const protocol = req.protocol;

	// delete old image file, if it exists
	const filename = path.join(dir, `icon`);
	if (fs.existsSync(filename)) {
		logger.verbose(`${req.id} delete file: ${filename}`);
		await fs.promises.rm(filename);
	}

	// move file
	fs.rename(image.path, path.join(dir, name), async () => {
		// success
		res.ret = {
			user: reduceUser(user),
			image: {
				name,
				part,
				host,
				protocol,
				url: `${protocol}://${host}${part}/${name}`,
			},
		};
		res.status(StatusCodes.OK).send(res.ret);
		next();
	});
}));

/**
 * View profile icon.
 */
router.get('/profile/icon', [
	authen.required,
], asyncHandler(async (req, res, next) => {
	// view image file, if it exists
	const dir = path.join(process.env.STORAGE_PATH, req.user.id, 'profile');
	const filename = path.join(dir, `icon`);
	let filepath;
	let contentType;
	if (fs.existsSync(filename)) {
		filepath = filename;
		contentType = 'image/*';
	}
	else {
		filepath = path.resolve(path.join(__dirname, '..', 'assets', 'default-profile-icon.png'));
		contentType = mime.contentType(filepath);
	}

	// output
	fs.readFile(filepath, (err, data) => {
		if (err) throw err;
		res.writeHead(200, { 'Content-Type': contentType, });
		res.end(data);
	});
}));

/**
 * Remove the uploaded profile icon.
 */
router.delete('/profile/icon', [
	authen.required,
], asyncHandler(async (req, res, next) => {
	// select
	const user = await entities.Users.findByPk(req.user.id);

	// delete old image file, if it exists
	const dir = path.join(process.env.STORAGE_PATH, req.user.id, 'profile');
	const filename = path.join(dir, `icon`);
	if (fs.existsSync(filename)) {
		logger.verbose(`${req.id} delete file: ${filename}`);
		await fs.promises.rm(filename);
	}

	// success
	res.ret = {
		user: reduceUser(user),
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
