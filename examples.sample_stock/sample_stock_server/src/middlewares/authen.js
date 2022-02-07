'use strict';
const { StatusCodes } = require('http-status-codes');
const asyncHandler = require('express-async-handler');
const { RestError, errors } = require('../libs');
const { userFromHeaders } = require('../utils/authen');

const optional = asyncHandler(async (req, res, next) => {
	try {
		req.user = await userFromHeaders(req);
	}
	catch (ex) {
		req.user = null;
	}
	next();
});

const required = asyncHandler(async (req, res, next) => {
	req.user = await userFromHeaders(req);
	next();
});

const userRequired = asyncHandler(async (req, res, next) => {
	const user = await userFromHeaders(req);
	if (user.role !== 'user')
		throw new RestError(StatusCodes.FORBIDDEN, errors.requirePermissions, { context: 'user' });
	req.user = user;
	next();
});

const adminRequired = asyncHandler(async (req, res, next) => {
	const user = await userFromHeaders(req);
	if (user.role !== 'admin')
		throw new RestError(StatusCodes.FORBIDDEN, errors.requirePermissions, { context: 'admin' });
	req.user = user;
	next();
});

module.exports = {
	optional,
	required,
	userRequired,
	adminRequired,
};
