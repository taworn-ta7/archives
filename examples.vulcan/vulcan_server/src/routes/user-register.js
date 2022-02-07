'use strict';
const { ulid } = require('ulid');
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { RestError, errors } = require('../libs');
const entities = require('../entities');
const validators = require('../validators');
const { setPassword, reduceUser } = require('../utils/authen');
const { dump, authen } = require('../middlewares');

/**
 * Register new user.
 */
router.post('/register', [
	dump.body,
	validate({
		body: Joi.object({
			user: Joi.object({
				username: validators.Users.username.required(),
				displayName: validators.Users.displayName.required(),
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
	if (await entities.Users.findOne({ where: { username: json.username } }))
		throw new RestError(StatusCodes.FORBIDDEN, errors.alreadyExists, { context: 'user' });

	// insert
	const password = setPassword(json.password);
	const user = await entities.Users.create({
		id: ulid(),
		username: json.username,
		displayName: json.displayName,
		salt: password.salt,
		hash: password.hash,
	});

	// success
	res.ret = {
		user: reduceUser(user),
	};
	res.status(StatusCodes.CREATED).send(res.ret);
	next();
}));

/**
 * Unregister the current user.
 */
router.put('/unregister', [
	authen.userRequired,
], asyncHandler(async (req, res, next) => {
	// select
	const user = await entities.Users.findByPk(req.user.id);

	// update
	const now = new Date();
	await user.update({
		unregistered: now,
		end: now,
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
