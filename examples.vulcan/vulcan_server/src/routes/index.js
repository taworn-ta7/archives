'use strict';
const router = require('express').Router();

router.use('/authen', require('./authen'));
router.use('/admin', require('./admin'));
router.use('/user', require('./user'));
router.use('/user', require('./user-profile-icon'));
router.use('/user', require('./user-register'));

module.exports = router;
