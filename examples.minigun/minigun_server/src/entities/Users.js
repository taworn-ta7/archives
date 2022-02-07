'use strict';
const { DataTypes } = require('sequelize');
const db = require('../libs/db');

module.exports = db.define('Users', {
	id: {
		type: DataTypes.STRING(50),
		allowNull: false,
		primaryKey: true,
	},

	// name
	username: {
		type: DataTypes.STRING(20),
		allowNull: false,
		validate: {
			len: 4,
			is: /^[a-zA-Z0-9\+\-_]+$/,
		},
	},
	displayName: {
		type: DataTypes.STRING(50),
		allowNull: false,
		field: 'display_name',
		validate: {
			len: 4,
		},
	},

	// role and flags
	role: {
		type: DataTypes.STRING(20),
		allowNull: false,
		defaultValue: 'user',
		validate: {
			isIn: [['user', 'admin']],
		},
	},
	disabled: {
		// disabled by admin
		type: DataTypes.DATE,
		allowNull: true,
		defaultValue: null,
	},
	unregistered: {
		// unregistered by user
		type: DataTypes.DATE,
		allowNull: true,
		defaultValue: null,
	},

	// when login
	begin: {
		type: DataTypes.DATE,
		allowNull: true,
	},
	end: {
		type: DataTypes.DATE,
		allowNull: true,
	},
	expire: {
		type: DataTypes.DATE,
		allowNull: true,
	},

	// encrypted password
	salt: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	hash: {
		type: DataTypes.STRING(1024),
		allowNull: false,
	},
	token: {
		type: DataTypes.STRING(1024),
		allowNull: true,
	},
}, {
	name: {
		singular: 'user',
		plural: 'users',
	},
	tableName: 'users',
});
