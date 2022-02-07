'use strict';
const { Joi } = require('express-validation');
module.exports = {

	username: Joi.string()
		.min(4).max(20)
		.pattern(/^[a-zA-Z0-9\+\-_]+$/),

	displayName: Joi.string()
		.min(4).max(50),

	role: Joi.string()
		.max(20)
		.valid('user', 'admin'),

	disabled: Joi.boolean(),

	password: Joi.string()
		.min(4).max(20),

};
