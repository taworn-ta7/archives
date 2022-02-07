'use strict';
const router = require('express').Router();

router.use('/authen', require('./authen'));
router.use('/sku', require('./sku'));
router.use('/product', require('./product'));

module.exports = router;
