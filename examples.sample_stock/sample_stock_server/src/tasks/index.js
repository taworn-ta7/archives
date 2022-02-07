'use strict';
const path = require('path');
const logger = require('../libs/logger');
const deleteLogs = require('./delete-logs');

const deleteLogTimer = async (parameter) => {
	await deleteLogs(parameter.logPath, parameter.daysToKeepLog);
};

/**
 * Install all background tasks.
 */
(() => {
	try {
		const logPath = path.resolve(path.join(__dirname, '..', '..', process.env.LOG_DIR));
		logger.info(`log path: ${logPath}`);

		const daysToKeepLog = +process.env.DAYS_TO_KEEP_LOG;
		logger.info(`days to keep log: ${daysToKeepLog} day(s)`);
		setTimeout(deleteLogTimer, 0, { logPath, daysToKeepLog });
		setInterval(deleteLogTimer, 8 * 60 * 60 * 1000, { logPath, daysToKeepLog });
	}
	catch (ex) {
		logger.error(ex);
	}
})();
