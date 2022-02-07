'use strict';
const path = require('path');
const dotenv = require('dotenv');
const mkdirp = require('mkdirp');

dotenv.config();
if (process.env.NODE_ENV === 'development') {
	dotenv.config({ path: path.join(__dirname, '..', '.env.base-development') });
}
if (process.env.NODE_ENV === 'production') {
	dotenv.config({ path: path.join(__dirname, '..', '.env.base-production') });
}
dotenv.config({ path: path.join(__dirname, '..', '.env.base') });

(async () => {
	process.env.TEMP_PATH = path.resolve(path.join(__dirname, '..', process.env.TEMP_DIR));
	process.env.STORAGE_PATH = path.resolve(path.join(__dirname, '..', process.env.STORAGE_DIR));
	await mkdirp(process.env.TEMP_PATH);
	await mkdirp(process.env.STORAGE_PATH);
})();
