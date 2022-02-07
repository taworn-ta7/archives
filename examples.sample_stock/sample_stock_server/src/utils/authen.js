'use strict';
const { StatusCodes } = require('http-status-codes');
const { RestError, errors, fetch } = require('../libs');

const authenServer = process.env.AUTHEN_SERVER;

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

	// send login to authen server
	const uri = `${authenServer}/authen/check`;
	const options = {
		method: 'GET',
		headers: {
			'Content-Type': 'application/json;charset=utf-8',
			'Authorization': `Bearer ${token}`,
		},
	};
	const o = await fetch.check(uri, options);

	return o.user;
};

// ----------------------------------------------------------------------

module.exports = {
	tokenFromHeaders,
	userFromHeaders,
};
