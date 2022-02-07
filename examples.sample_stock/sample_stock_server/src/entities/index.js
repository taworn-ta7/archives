'use strict';
const Skus = require('./Skus');
const Products = require('./Products');
const ProductSkus = require('./ProductSkus');

Skus.hasOne(ProductSkus, { foreignKey: 'sku_id' });
ProductSkus.belongsTo(Skus, { foreignKey: 'sku_id' });

Products.hasMany(ProductSkus, { foreignKey: 'product_id', onDelete: 'cascade' });
ProductSkus.belongsTo(Products, { foreignKey: 'product_id' });

module.exports = {
	Skus,
	Products,
	ProductSkus,
};
