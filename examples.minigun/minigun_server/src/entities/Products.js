'use strict';
const { DataTypes } = require('sequelize');
const db = require('../libs/db');

module.exports = db.define('Products', {
	id: {
		type: DataTypes.BIGINT,
		allowNull: false,
		autoIncrement: true,
		primaryKey: true,
	},

	// link to table users
	uid: {
		type: DataTypes.STRING(50),
		allowNull: false,
	},

	// product name
	name: {
		type: DataTypes.STRING(100),
		allowNull: false,
	},
}, {
	name: {
		singular: 'product',
		plural: 'products',
	},
	tableName: 'products',
});
