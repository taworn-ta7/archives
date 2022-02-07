'use strict';
const { DataTypes } = require('sequelize');
const db = require('../libs/db');

module.exports = db.define('ProductSkus', {
	id: {
		type: DataTypes.BIGINT,
		allowNull: false,
		autoIncrement: true,
		primaryKey: true,
	},

	// link to table products and skus
	productId: {
		type: DataTypes.BIGINT,
		allowNull: false,
		field: 'product_id',
	},
	skuId: {
		type: DataTypes.BIGINT,
		allowNull: false,
		field: 'sku_id',
	},
}, {
	name: {
		singular: 'product_sku',
		plural: 'product_skus',
	},
	tableName: 'product_skus',
});
