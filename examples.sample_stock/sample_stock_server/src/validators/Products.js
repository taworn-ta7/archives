'use strict';
const { Joi } = require('express-validation');
module.exports = {

	id: Joi.number().integer()
		.min(1).max(999999999),

	name: Joi.string()
		.min(1).max(100)
		.pattern(/^[^ \t]+$/),

};
