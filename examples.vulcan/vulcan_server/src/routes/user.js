'use strict';
const path = require('path');
const fs = require('fs');
const mime = require('mime-types');
const { Op } = require('sequelize');
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { RestError, errors } = require('../libs');
const entities = require('../entities');
const validators = require('../validators');
const { setPassword, reduceUser } = require('../utils/authen');
const { getPaginate, queryGenericData } = require('../utils/page-utils');
const { dump, authen } = require('../middlewares');



// ----------------------------------------------------------------------
// View
// ----------------------------------------------------------------------

/**
 * View user's information.
 */
router.get('/id/:username', [
	authen.required,
	validate({
		params: Joi.object({
			username: validators.Users.username.required(),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const { username } = req.params;

	// select
	const user = await entities.Users.findOne({ where: { username } });
	if (!user)
		throw new RestError(StatusCodes.NOT_FOUND, errors.notFound, { context: 'user' });

	// success
	res.ret = {
		user: reduceUser(user),
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

/**
 * View user's profile icon.
 */
router.get('/icon/:username', [
	authen.required,
], asyncHandler(async (req, res, next) => {
	// get request
	const { username } = req.params;

	// select
	const user = await entities.Users.findOne({ where: { username } });
	if (!user)
		throw new RestError(StatusCodes.NOT_FOUND, errors.notFound, { context: 'user' });

	// view image file, if it exists
	const dir = path.join(process.env.STORAGE_PATH, user.id, 'profile');
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
 * List users.
 */
router.get('/list/:page?', [
	authen.required,
	validate({
		query: Joi.object({
			page: validators.Generic.page,
			order: validators.Generic.order,
			search: validators.Generic.search,
			trash: validators.Generic.trash,
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const { page, order, search, trash } = queryGenericData(req, {
		username: 'username',
		displayName: 'displayName',
		disabled: 'disabled',
		unregistered: 'unregistered',
		createdAt: 'createdAt',
		created_at: 'createdAt',
		updatedAt: 'updatedAt',
		updated_at: 'updatedAt',
	});

	// conditions
	const where = {};
	if (search && search.length > 0) {
		where[Op.or] = [
			{ username: { [Op.like]: `${search}%` } },
			{ displayName: { [Op.like]: `${search}%` } },
		];
	}
	if (trash && trash !== 0) {
		where.unregistered = {
			[Op.not]: null,
		};
	}
	else {
		where.unregistered = null;
	}

	// select
	const rowsPerPage = +process.env.ROWS_PER_PAGE_3;
	const query = {
		attributes: [
			'id',
			'username',
			'displayName',
			'role',
			'disabled',
			'unregistered',
			'begin',
			'end',
			'expire',
			'createdAt',
			'updatedAt',
		],
		where,
		order,
		offset: page * rowsPerPage,
		limit: rowsPerPage,
	};
	const count = await entities.Users.count(query);
	const users = await entities.Users.findAll(query);

	// reduce
	for (let i = 0; i < users.length; i++)
		users[i] = reduceUser(users[i]);

	// success
	res.ret = {
		paginate: getPaginate(page, rowsPerPage, count),
		users,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));



// ----------------------------------------------------------------------
// Update
// ----------------------------------------------------------------------

/**
 * Change the current user's display name.
 */
router.put('/update/displayName', [
	authen.required,
	dump.body,
	validate({
		body: Joi.object({
			user: Joi.object({
				displayName: validators.Users.displayName.required(),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.user;

	// select
	const user = await entities.Users.findByPk(req.user.id);

	// update
	await user.update({
		displayName: json.displayName,
	});

	// success
	res.ret = {
		user: reduceUser(user),
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

/**
 * Change the current user's password.
 */
router.put('/update/password', [
	authen.required,
	dump.body,
	validate({
		body: Joi.object({
			user: Joi.object({
				password: validators.Users.password.required(),
				confirmPassword: Joi.any()
					.valid(Joi.ref('password'))
					.required(),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.user;

	// select
	const user = await entities.Users.findByPk(req.user.id);

	// update
	const password = setPassword(json.password);
	await user.update({
		salt: password.salt,
		hash: password.hash,
		end: new Date(),
		token: null,
	});
	req.user = undefined;

	// success
	res.ret = {
		user: reduceUser(user),
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
