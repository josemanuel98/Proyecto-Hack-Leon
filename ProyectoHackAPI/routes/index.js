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

router.post('/HackLeon/v1/AddCiudadano', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var nickname = req.body.Nickname;
            var contraseña = req.body.Contraseña;
            var email = req.body.Email;
            var curp = req.body.Curp;
            var auxQuery = `CALL uspAddCiudadano('${nickname}', '${contraseña}', '${email}', '${curp}')`;
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

/******************* Reporte **************/

router.post('/HackLeon/v1/AddReporte', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var idCiudadano = req.body.IdCiudadano;
            var idCategoriaReporte = req.body.IdCategoriaReporte;
            var descripcion = req.body.Descripcion;
            var foto = req.body.Foto;
            var ubicacionRegistro = req.body.UbicacionRegistro;
            var ubicacionHecho = req.body.UbicacionHecho;
            var fechaHecho = req.body.FechaHecho;
            var auxQuery = `CALL uspAddReporte(${idCiudadano}, ${idCategoriaReporte}, '${descripcion}', '${foto}', '${ubicacionRegistro}', '${ubicacionHecho}', '${fechaHecho}')`;
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

router.post('/HackLeon/v1/RemoveApoyo', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var idCiudadano = req.body.IdCiudadano;
            var idReporte = req.body.IdReporte;
            var auxQuery = `CALL uspRemoveApoyo(${idCiudadano}, ${idReporte})`;
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

router.post('/HackLeon/v1/AddReporteSOS_Imagen', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var idCiudadano = req.body.IdCiudadano;
            var idCategoriaReporteSOS = req.body.IdCategoriaReporteSOS;
            var ubicacion = req.body.Ubicacion;
            var imagen = req.body.Imagen;
            var auxQuery = `CALL uspAddReporteSOS_Imagen(${idCiudadano}, ${idCategoriaReporteSOS}, '${ubicacion}', '${imagen}')`;
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

router.post('/HackLeon/v1/FinishReporteSOS', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var idServidorPublico = req.body.IdServidorPublico;
            var idReporteSOS = req.body.IdReporteSOS;
            var auxQuery = `CALL uspFinishReporteSOS(${idServidorPublico}, ${idReporteSOS})`;
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

/******************* Zonas ***********************/

router.post('/HackLeon/v1/AddDetalle_Zona_Horario', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var idServidorPublico = req.body.IdServidorPublico;
            var idHorarioZona = req.body.IdHorarioZona;
            var idZona = req.body.IdZona;
            var codigo = req.body.Codigo;
            var auxQuery = `CALL uspAddDetalle_Zona_Horario(${idServidorPublico}, ${idHorarioZona}, ${idZona}, '${codigo}')`;
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

router.post('/HackLeon/v1/AddDetalle_Ciudadano_Zona', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var idServidorPublico = req.body.IdServidorPublico;
            var idZona = req.body.IdZona;
            var auxQuery = `CALL uspAddDetalle_Ciudadano_Zona(${idServidorPublico}, ${idZona})`;
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

router.get('/HackLeon/v1/GetAllReporte', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var auxQuery = `CALL GetAllReporte()`;
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

router.get('/HackLeon/v1/GetAllCategoriaReporte', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var auxQuery = `CALL GetAllCategoriaReporte()`;
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

router.get('/HackLeon/v1/GetAllRol', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var auxQuery = `CALL GetAllRol()`;
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
