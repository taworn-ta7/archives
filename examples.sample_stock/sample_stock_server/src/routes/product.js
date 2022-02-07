'use strict';
const { Op } = require('sequelize');
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { logger, RestError, errors, db } = require('../libs');
const entities = require('../entities');
const validators = require('../validators');
const { getPaginate, queryGenericData } = require('../utils/page-utils');
const { authen } = require('../middlewares');



// ----------------------------------------------------------------------
// Create
// ----------------------------------------------------------------------

/**
 * Create a product.
 */
router.post('/', [
	authen.userRequired,
	validate({
		body: Joi.object({
			product: Joi.object({
				name: validators.Products.name.required(),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.product;

	// insert
	const item = await entities.Products.create({
		uid: req.user.id,
		name: json.name,
	});

	// success
	res.ret = {
		product: item,
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
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const { page, order, search } = queryGenericData(req, {
		id: 'id',
		name: 'name',
	});

	// conditions
	const where = {
		uid: req.user.id,
	};
	if (search && search.length > 0) {
		where.name = {
			[Op.like]: `${search}%`,
		};
	}

	// select
	const rowsPerPage = +process.env.ROWS_PER_PAGE_10;
	const query = {
		where,
		order,
		offset: page * rowsPerPage,
		limit: rowsPerPage,
	};
	const count = await entities.Products.count(query);
	const items = await entities.Products.findAll(query);

	// success
	res.ret = {
		paginate: getPaginate(page, rowsPerPage, count),
		products: items,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

/**
 * Find one item.
 */
router.get('/:id', [
	authen.userRequired,
	validate({
		params: Joi.object({
			id: validators.Products.id.required(),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// select
	const item = await getProduct(req.user.id, req.params.id);

	// success
	res.ret = {
		product: item,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));



// ----------------------------------------------------------------------
// Update
// ----------------------------------------------------------------------

/**
 * Update a product and its SKUs.
 */
router.put('/:id', [
	authen.userRequired,
	validate({
		params: Joi.object({
			id: validators.Products.id.required(),
		}),
		body: Joi.object({
			product: Joi.object({
				skus: Joi.array().items(Joi.string()),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.product;
	for (let i = 0; i < json.skus.length; i++) {
		for (let j = i + 1; j < json.skus.length; j++) {
			if (json.skus[i] === json.skus[j]) {
				logger.debug(`${req.id} duplicate: code=${json.skus[i]}, i=${i}, j=${j}`);
				throw new RestError(StatusCodes.FORBIDDEN, errors.duplicate, { context: 'sku' });
			}
		}
	}

	// select
	const item = await getProduct(req.user.id, req.params.id);

	const skus = [];
	const fails = [];
	await db.transaction(async (transaction) => {
		// remove old sku(s) in product
		await entities.ProductSkus.destroy({
			where: {
				productId: item.id,
			},
		}, { transaction });

		// add sku(s) into product
		for (let i = 0; i < json.skus.length; i++) {
			const code = json.skus[i];
			const sku = await entities.Skus.findOne({
				where: {
					uid: req.user.id,
					code,
					deleted: null,
				},
			}, { transaction });
			if (sku) {
				try {
					await entities.ProductSkus.create({
						productId: item.id,
						skuId: sku.id,
					}, { transaction });
					skus.push(code);
				}
				catch (ex) {
					// next query
				}
			}
			else {
				fails.push(code);
			}
		}
	});

	// reload
	await item.reload();

	// success
	res.ret = {
		product: item,
		skus,
		fails,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));



// ----------------------------------------------------------------------
// Delete
// ----------------------------------------------------------------------

/**
 * Remove a product and its SKUs.
 */
router.delete('/:id', [
	authen.userRequired,
	validate({
		params: Joi.object({
			id: validators.Products.id.required(),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// select
	const item = await getProduct(req.user.id, req.params.id);

	// delete
	await item.destroy({
		include: entities.ProductSkus,
	});

	// success
	res.ret = {
		product: item,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}))



// ----------------------------------------------------------------------
// Utilities
// ----------------------------------------------------------------------

const getProduct = async (uid, id) => {
	const item = await entities.Products.findOne({
		where: {
			uid,
			id,
		},
		include: {
			model: entities.ProductSkus,
			include: {
				model: entities.Skus,
			},
		},
	});
	if (!item)
		throw new RestError(StatusCodes.NOT_FOUND, errors.notFound, { context: 'product' });
	return item;
};

module.exports = router;
