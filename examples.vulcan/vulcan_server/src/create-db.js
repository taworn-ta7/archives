'use strict';
const { ulid } = require('ulid');
require('./config');
require('./extensions');
const { db } = require('./libs');
const entities = require('./entities');
const { setPassword } = require('./utils/authen');

/**
 * A script to initial database.
 */
(async () => {
	try {
		await db.sync({ force: true });

		let password = setPassword('admin//pass');
		await entities.Users.create({
			id: ulid(),
			username: 'admin',
			displayName: 'Administrator',
			role: 'admin',
			salt: password.salt,
			hash: password.hash,
		});

		password = setPassword('user0//pass');
		await entities.Users.create({
			id: ulid(),
			username: 'user0',
			displayName: 'User 0',
			role: 'user',
			salt: password.salt,
			hash: password.hash,
		});

		password = setPassword('user1//pass');
		await entities.Users.create({
			id: ulid(),
			username: 'user1',
			displayName: 'User 1',
			role: 'user',
			salt: password.salt,
			hash: password.hash,
		});

		password = setPassword('user2//pass');
		await entities.Users.create({
			id: ulid(),
			username: 'user2',
			displayName: 'User 2',
			role: 'user',
			salt: password.salt,
			hash: password.hash,
		});

		process.exit(0);
	}
	catch (ex) {
		console.log(ex);
		process.exit(1);
	}
})();
