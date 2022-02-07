'use strict';
const { Joi } = require('express-validation');
module.exports = {

	code: Joi.string()
		.min(1).max(50)
		.pattern(/^[A-Za-z0-9\+\-_]+$/),

	barcode: Joi.string()
		.min(12).max(12)
		.pattern(/^[0-9]+$/),

	cost: Joi.number()
		.min(0).max(999999999999.99),

	price: Joi.number()
		.min(0).max(999999999999.99),

	quantity: Joi.number().integer()
		.min(0).max(999999999999),

};
