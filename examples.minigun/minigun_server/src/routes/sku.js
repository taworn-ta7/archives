'use strict';
const path = require('path');
const fs = require('fs');
const mkdirp = require('mkdirp');
const mime = require('mime-types');
const { ulid } = require('ulid');
const { Op } = require('sequelize');
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { logger, RestError, errors, uploads, db } = require('../libs');
const entities = require('../entities');
const validators = require('../validators');
const { getPaginate, queryGenericData } = require('../utils/page-utils');
const { dump, authen } = require('../middlewares');



// ----------------------------------------------------------------------
// Create
// ----------------------------------------------------------------------

/**
 * Create SKUs.
 */
router.post('/', [
	authen.userRequired,
	validate({
		body: Joi.object({
			skus: Joi.array().items({
				code: validators.Skus.code.required(),
				barcode: validators.Skus.barcode.allow(null),
				cost: validators.Skus.cost.required(),
				price: validators.Skus.price.required(),
				quantity: validators.Skus.quantity.required(),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.skus;
	for (let i = 0; i < json.length; i++) {
		for (let j = i + 1; j < json.length; j++) {
			if (json[i].code === json[j].code) {
				logger.debug(`${req.id} duplicate: code=${json[i].code}, i=${i}, j=${j}`);
				throw new RestError(StatusCodes.FORBIDDEN, errors.duplicate, { context: 'sku' });
			}
		}
	}

	const items = [];
	try {
		await db.transaction(async (transaction) => {
			for (let i = 0; i < json.length; i++) {
				const item = json[i];

				// check
				const exists = await entities.Skus.findOne({
					where: {
						uid: req.user.id,
						code: item.code,
						deleted: null,
					},
				}, { transaction });
				if (exists) {
					logger.debug(`${req.id} already exists: id=${exists.id}, code=${item.code}`);
					throw new RestError(StatusCodes.FORBIDDEN, errors.alreadyExists, { context: 'sku' });
				}

				// insert
				const sku = await entities.Skus.create({
					uid: req.user.id,
					code: item.code,
					barcode: item.barcode,
					cost: item.cost,
					price: item.price,
					quantity: item.quantity,
				}, { transaction });

				items.push(sku);
			}
		});
	}
	catch (ex) {
		throw ex;
	}

	// success
	res.ret = {
		skus: items,
	};
	res.status(StatusCodes.CREATED).send(res.ret);
	next();
}));



// ----------------------------------------------------------------------
// Read
// ----------------------------------------------------------------------

/**
 * Find all items.
 */
router.get('/', [
	authen.userRequired,
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
		code: 'code',
		barcode: 'barcode',
		cost: 'cost',
		price: 'price',
		q: 'quantity',
	});

	// conditions
	const where = {
		uid: req.user.id,
	};
	if (search && search.length > 0) {
		where.code = {
			[Op.like]: `${search}%`,
		};
	}
	if (trash && trash !== 0) {
		where.deleted = {
			[Op.not]: null,
		};
	}
	else {
		where.deleted = null;
	}

	// select
	const rowsPerPage = +process.env.ROWS_PER_PAGE_10;
	const query = {
		where,
		order,
		offset: page * rowsPerPage,
		limit: rowsPerPage,
	};
	const count = await entities.Skus.count(query);
	const items = await entities.Skus.findAll(query);

	// success
	res.ret = {
		paginate: getPaginate(page, rowsPerPage, count),
		skus: items,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

/**
 * Find one item.
 */
router.get('/:code', [
	authen.userRequired,
	validate({
		params: Joi.object({
			code: validators.Skus.code.required(),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// select
	const item = await getSku(req.user.id, req.params.code);

	// success
	res.ret = {
		sku: item,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));



// ----------------------------------------------------------------------
// Update
// ----------------------------------------------------------------------

/**
 * Update a SKU.
 */
router.put('/:code', [
	authen.userRequired,
	validate({
		params: Joi.object({
			code: validators.Skus.code.required(),
		}),
		body: Joi.object({
			sku: Joi.object({
				barcode: validators.Skus.barcode.allow(null, ""),
				cost: validators.Skus.cost,
				price: validators.Skus.price,
				quantity: validators.Skus.quantity,
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.sku;

	// select
	const item = await getSku(req.user.id, req.params.code);

	// update
	await item.update(json);

	// success
	res.ret = {
		sku: item,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

/**
 * Upload an image.
 */
router.post('/image/:code', [
	authen.userRequired,
	validate({
		params: Joi.object({
			code: validators.Skus.code.required(),
		}),
	}),
	uploads.single('image'),
	dump.headers,
], asyncHandler(async (req, res, next) => {
	// select
	const item = await getSku(req.user.id, req.params.code);

	// check upload image
	const image = req.file;
	if (!image)
		throw new RestError(StatusCodes.BAD_REQUEST, errors.noUploadFile);
	logger.verbose(`${req.id} image: ${debugFormat(image, true)}`);
	if (image.mimetype !== 'image/png' && image.mimetype !== 'image/jpeg' && image.mimetype !== 'image/gif')
		throw new RestError(StatusCodes.BAD_REQUEST, errors.uploadFileIsNotType, { context: 'image' });
	if (image.size >= +process.env.SKU_IMAGE_FILE_LIMIT)
		throw new RestError(StatusCodes.BAD_REQUEST, errors.uploadFileIsTooLarge);

	// create directory, if not exists
	const dir = path.join(process.env.STORAGE_PATH, req.user.id, 'sku');
	logger.verbose(`${req.id} directory: ${dir}`);
	await mkdirp(dir);

	// generate output
	const name = `${ulid()}.${mime.extension(image.mimetype)}`;
	const part = `/files/${req.user.id}/sku`;
	const host = req.get('host');
	const protocol = req.protocol;

	// move file
	fs.rename(image.path, path.join(dir, name), async () => {
		// delete old image file, if it exists
		if (item.image) {
			const filename = path.join(dir, item.image);
			logger.verbose(`${req.id} delete file: ${filename}`);
			await fs.promises.rm(filename);
		}

		// update
		await item.update({
			image: name,
		});

		// success
		res.ret = {
			sku: item,
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
 * Remove the uploaded image.
 */
router.delete('/image/:code/remove', [
	authen.userRequired,
	validate({
		params: Joi.object({
			code: validators.Skus.code.required(),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// select
	const item = await getSku(req.user.id, req.params.code);

	// delete old image file, if it exists
	if (item.image) {
		const dir = path.join(process.env.STORAGE_PATH, req.user.id, 'sku');
		const filename = path.join(dir, item.image);
		logger.verbose(`${req.id} delete file: ${filename}`);
		await fs.promises.rm(filename);

		// update
		await item.update({
			image: null,
		});
	}

	// success
	res.ret = {
		sku: item,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));



// ----------------------------------------------------------------------
// Delete
// ----------------------------------------------------------------------

/**
 * Remove a SKU.
 */
router.delete('/:code', [
	authen.userRequired,
	validate({
		params: Joi.object({
			code: validators.Skus.code.required(),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// select
	const item = await getSku(req.user.id, req.params.code);

	// update
	await item.update({ deleted: new Date() });

	// success
	res.ret = {
		sku: item,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}))



// ----------------------------------------------------------------------
// Utilities
// ----------------------------------------------------------------------

const getSku = async (uid, code) => {
	const item = await entities.Skus.findOne({
		where: {
			uid,
			code,
			deleted: null,
		},
	});
	if (!item)
		throw new RestError(StatusCodes.NOT_FOUND, errors.notFound, { context: 'sku' });
	return item;
};

module.exports = router;
