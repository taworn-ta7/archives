'use strict';
const fetch = require('node-fetch');
const RestError = require('../libs/RestError');

const check = async (uri, options) => {
	const res = await fetch(uri, options);
	const json = await res.json();
	if (!res.ok) {
		if (json.error) {
			throw new RestError(json.error.status, json.error.message);
		}
		else {
			throw new RestError(res.status, res.statusText);
		}
	}
	return json;
};

module.exports = {
	check,
};
