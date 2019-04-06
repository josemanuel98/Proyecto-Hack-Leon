var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

/****************** Ciudadano ******************/

router.post('/HackLeon/v1/LogInCiudadano', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var email = req.body.Email;
            var contraseña = req.body.Contraseña;
            var auxQuery = `CALL uspLogInCiudadano('${email}', '${contraseña}')`;
            var query = conn.query(auxQuery, Object.values(reqObj), function(err, result) {
                if(err) {
                    console.error('SQL error: ', err);
                    return next(err);
                }
                var response = result[0];
                res.json(response[0]);
                console.log(result);
            });
        }
    });
} catch(ex) {
    console.error("Internal error:" + ex);
    return next(ex);
  }
});

module.exports = router;
