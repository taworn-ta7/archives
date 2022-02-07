'use strict';
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { RestError, errors } = require('../libs');
const entities = require('../entities');
const validators = require('../validators');
const { reduceUser } = require('../utils/authen');
const { authen } = require('../middlewares');

/**
 * Disable/enable user.
 */
router.put('/disable/:username', [
	authen.adminRequired,
	validate({
		params: Joi.object({
			username: validators.Users.username.required(),
		}),
		body: Joi.object({
			user: Joi.object({
				disabled: validators.Users.disabled.required(),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const { username } = req.params;
	const json = req.body.user;

	// select
	const user = await entities.Users.findOne({ where: { username, role: 'user' } });
	if (!user)
		throw new RestError(StatusCodes.NOT_FOUND, errors.notFound, { context: 'user' });

	// update
	const now = new Date();
	await user.update({
		disabled: json.disabled ? now : null,
		end: null,
		token: null,
	});

	// success
	res.ret = {
		user: reduceUser(user),
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
