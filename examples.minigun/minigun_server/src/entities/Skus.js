'use strict';
const { DataTypes } = require('sequelize');
const db = require('../libs/db');

module.exports = db.define('Skus', {
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

	// code
	code: {
		type: DataTypes.STRING(50),
		allowNull: false,
	},
	barcode: {
		type: DataTypes.STRING(12),
		allowNull: true,
	},

	// cost to buy
	cost: {
		type: DataTypes.DECIMAL(14, 2),
		allowNull: false,
		defaultValue: 0.0,
	},

	// price to sell
	price: {
		type: DataTypes.DECIMAL(14, 2),
		allowNull: false,
		defaultValue: 0.0,
	},

	// quantity in stock
	quantity: {
		type: DataTypes.INTEGER,
		allowNull: false,
		defaultValue: 0,
	},

	// image file
	image: {
		type: DataTypes.STRING(250),
		allowNull: true,
	},

	// deleted timestamp
	deleted: {
		type: DataTypes.DATE,
		allowNull: true,
	},
}, {
	name: {
		singular: 'sku',
		plural: 'skus',
	},
	tableName: 'skus',
});
