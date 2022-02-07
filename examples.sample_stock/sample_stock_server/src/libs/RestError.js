'use strict';

class RestError extends Error {
	constructor(status, message, options) {
		super(message);
		this.name = 'RestError';
		this.status = status;
		this.options = options;
	}
}

module.exports = RestError;
