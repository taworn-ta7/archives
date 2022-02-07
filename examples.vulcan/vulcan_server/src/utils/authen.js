'use strict';
const crypto = require('crypto');
const { StatusCodes } = require('http-status-codes');
const { RestError, errors, logger } = require('../libs');
const entities = require('../entities');

const setPassword = (password) => {
	const salt = crypto.randomBytes(16).toString('hex');
	const hash = crypto.pbkdf2Sync(password, salt, 10000, 512, 'sha512').toString('hex');
	return { salt, hash };
};

const validatePassword = (password, salt, hash) => {
	const computeHash = crypto.pbkdf2Sync(password, salt, 10000, 512, 'sha512').toString('hex');
	return hash === computeHash;
};

const generateSecret = () => {
	const seed = crypto.randomBytes(128).toString('hex');
	return Buffer.from(seed).toString('base64');
};

// ----------------------------------------------------------------------

const tokenFromHeaders = (req) => {
	const { headers: { authorization } } = req;
	if (authorization) {
		const a = authorization.split(' ');
		if (a.length >= 2) {
			if (a[0].toLowerCase() === 'bearer') {
				return a[1];
			}
		}
	}
	return null;
};

const userFromHeaders = async (req) => {
	const token = tokenFromHeaders(req);
	if (!token)
		throw new RestError(StatusCodes.UNAUTHORIZED, errors.invalidToken);

	// search token
	const user = await entities.Users.findOne({ where: { token } });
	if (!user)
		throw new RestError(StatusCodes.UNAUTHORIZED, errors.invalidToken);

	// check if expiry login
	const now = new Date();
	if (user.expire.getTime() < now.getTime())
		throw new RestError(StatusCodes.UNAUTHORIZED, errors.timeout);

	// update expiry login
	const expire = now.getTime() + +process.env.AUTHEN_TIMEOUT;
	await user.update({
		expire: new Date(expire),
	});
	return reduceUser(user);
};

// ----------------------------------------------------------------------

const reduceUser = (user, withMoreFields = false) => {
	const reduce = {
		id: user.id,
		username: user.username,
		displayName: user.displayName,
		role: user.role,
		disabled: user.disabled,
		unregistered: user.unregistered,
		begin: user.begin,
		end: user.end,
		expire: user.expire,
		createdAt: user.createdAt,
		updatedAt: user.updatedAt,
	};
	if (withMoreFields) {
		reduce.token = user.token;
	}
	else {
		delete reduce.token;
	}
	return reduce;
};

// ----------------------------------------------------------------------

module.exports = {
	setPassword,
	validatePassword,
	generateSecret,
	tokenFromHeaders,
	userFromHeaders,
	reduceUser,
};
