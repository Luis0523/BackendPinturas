
const express = require('express');
const router = express.Router();
const rolController = require('../controllers/core/rol.controller');


router.get('/roles', rolController.getRoles);


router.get('/roles/:id', rolController.getRolById);


router.post('/roles', rolController.createRol);


router.put('/roles/:id', rolController.updateRol);


router.delete('/roles/:id', rolController.deleteRol);

module.exports = router;

