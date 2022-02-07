'use strict';
const { Joi } = require('express-validation');
module.exports = {

	username: Joi.string()
		.min(4).max(20)
		.pattern(/^[a-zA-Z0-9\+\-_]+$/),

	password: Joi.string()
		.min(4).max(20),

};
