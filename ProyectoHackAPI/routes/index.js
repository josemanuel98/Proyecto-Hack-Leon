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

/****************** 2. uspLogInServidoPublico ******************/
router.post('/HackLeon/v1/LogInServidoPublico', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var username = req.body.Username;
            var contraseña = req.body.Contraseña;
            var auxQuery = `CALL uspLogInServidoPublico('${username}', '${contraseña}')`;
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

/****************** 4. uspAddServidorPublico ******************/
router.post('/HackLeon/v1/AddServidorPublico', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var id_rol_p = req.body.IdRol_P;
            var username_p = req.body.Username_P;
            var contraseña_p = req.body.Contraseña_P;
            var rfc_p = req.body.RFC_P;
            var auxQuery = `CALL uspAddServidoPublico(${id_rol_p},'${username_p}', 
                '${contraseña_p}', '${rfc_p}')`;
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


/****************** 6. uspAddServidorPublico ******************/
router.post('/HackLeon/v1/GiveApoyo', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var id_ciudadano_p = req.body.IdCiudadano_P;
            var id_reporte_p = req.body.IdReporte_P;

            var auxQuery = `CALL uspGiveApoyo(${id_rol_p}, ${id_rol_p})`;
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


/****************** 8. uspAddReporteSOS_Video ******************/
router.post('/HackLeon/v1/AddReporteSOS_Video', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var id_ciudadano_p = req.body.IdCiudadano_P;
            var id_categoria_rep_sos = req.body.IdCategoriaReporteSOS_P;
            var ubicacion_p = req.body.Ubicacion_P;
            var video_p = req.body.Video_P;

            var auxQuery = `CALL uspAddReporteSOS_Video(${id_ciudadano_p}, ${id_categoria_rep_sos},
            '${ubicacion_p}', '${video_p}')`;
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

/****************** 10. uspAddReporteSOS_Video ******************/
router.post('/HackLeon/v1/AddReporteSOS_Audio', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var id_ciudadano_p = req.body.IdCiudadano_P;
            var id_categoria_rep_sos = req.body.IdCategoriaReporteSOS_P;
            var ubicacion_p = req.body.Ubicacion_P;
            var audio_p = req.body.Video_P;

            var auxQuery = `CALL uspAddReporteSOS_Audio(${id_ciudadano_p}, ${id_categoria_rep_sos},
            '${ubicacion_p}', '${audio_p}')`;
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

/****************** 12. uspAddHorarioZona ******************/
router.post('/HackLeon/v1/AddHorarioZona', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var id_servidor_p = req.body.IdServidorPublico_P;
            var hora_inicial_p = req.body.HoraInicial_P;
            var hora_final_p = req.body.HoraFinal_P;

            var auxQuery = `CALL uspAddHorarioZona(${id_servidor_p}, ${hora_inicial_p}, ${hora_final_p})`;
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

/****************** 14. uspAddHorarioZona ******************/
router.post('/HackLeon/v1/AddHorarioZona', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var id_servidor_p = req.body.IdServidorPublico_P;
            var id_detalle_zona_p = req.body.IdDetalle_Zona_Horario_P;
            var codigo_p = req.body.Codigo_P;

            var auxQuery = `CALL uspAddHorarioZona(${id_servidor_p}, 
            ${id_detalle_zona_p}, '${codigo_p}')`;
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

/****************** 16. uspGetAllReporte ******************/
router.post('/HackLeon/v1/GetAllReporte', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var id_servidor_p = req.body.IdServidorPublico_P;
            var id_detalle_zona_p = req.body.IdDetalle_Zona_Horario_P;
            var codigo_p = req.body.Codigo_P;

            var auxQuery = `CALL uspGetAllReporte(${id_servidor_p}, 
            ${id_detalle_zona_p}, '${codigo_p}')`;
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


/****************** 18. u ******************/
router.post('/HackLeon/v1/AddHorarioZona', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var id_servidor_p = req.body.IdServidorPublico_P;
            var id_detalle_zona_p = req.body.IdDetalle_Zona_Horario_P;
            var codigo_p = req.body.Codigo_P;

            var auxQuery = `CALL uspAddHorarioZona(${id_servidor_p}, 
            ${id_detalle_zona_p}, '${codigo_p}')`;
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
