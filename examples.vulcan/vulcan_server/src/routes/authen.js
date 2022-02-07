'use strict';
const jwt = require('jsonwebtoken');
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { logger, RestError, errors } = require('../libs');
const entities = require('../entities');
const validators = require('../validators');
const { validatePassword, generateSecret, reduceUser } = require('../utils/authen');
const { dump, authen } = require('../middlewares');

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

	// select user
	const user = await entities.Users.findOne({ where: { username: json.username } });
	if (!user || !validatePassword(json.password, user.salt, user.hash))
		throw new RestError(StatusCodes.UNPROCESSABLE_ENTITY, errors.invalidUsernamePassword);

	// check if user disabled or unregistered
	if (user.unregistered)
		throw new RestError(StatusCodes.UNPROCESSABLE_ENTITY, errors.userIsUnregistered);
	if (user.disabled)
		throw new RestError(StatusCodes.UNPROCESSABLE_ENTITY, errors.userIsDisabledByAdmin);

	// check if expiry login
	const now = new Date();
	if (user.token && user.expire && user.expire.getTime() >= now.getTime()) {
		// update expiry login
		const expire = now.getTime() + +process.env.AUTHEN_TIMEOUT;
		await user.update({
			expire: new Date(expire),
		});
	}
	else {
		// sign token
		const now = new Date();
		const expire = now.getTime() + +process.env.AUTHEN_TIMEOUT;
		const payload = {
			id: user.id,
			sub: user.username,
		};
		const secret = generateSecret();
		logger.debug(`${req.id} secret: ${secret}`);
		const token = await jwt.sign(payload, secret, {});

		// update user
		await user.update({
			begin: now,
			end: null,
			expire: new Date(expire),
			token,
		});
	}

	// success
	res.ret = {
		user: reduceUser(user, true),
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

/**
 * Logout from the system.
 */
router.put('/logout', [authen.required], asyncHandler(async (req, res, next) => {
	// select
	const user = await entities.Users.findByPk(req.user.id);

	// update
	await user.update({
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

/**
 * Check current user login status.
 */
router.get('/check', [authen.optional], asyncHandler(async (req, res, next) => {
	// success
	res.ret = {
		user: req.user,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
