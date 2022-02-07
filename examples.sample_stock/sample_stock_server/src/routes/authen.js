'use strict';
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { fetch } = require('../libs');
const validators = require('../validators');
const { dump } = require('../middlewares');
const logger = require('../libs/logger');

const authenServer = process.env.AUTHEN_SERVER;

/**
 * Login into the system.
 */
router.put('/login', [
	dump.body,
	validate({
		body: Joi.object({
			login: Joi.object({
				username: validators.Users.username.required(),
				password: validators.Users.password.required(),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.login;

	// send login to authen server
	const uri = `${authenServer}/authen/login`;
	const options = {
		method: 'PUT',
		headers: {
			'Content-Type': 'application/json;charset=utf-8',
		},
		body: JSON.stringify({
			login: {
				username: json.username,
				password: json.password,
			},
		}),
	};
	logger.debug(`${req.id} ${options.method} ${uri}`);
	const o = await fetch.check(uri, options);

	// success
	res.ret = {
		user: o.user,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
