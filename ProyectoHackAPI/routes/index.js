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

router.post('/HackLeon/v1/UpdateReporteState', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var idReporte = req.body.IdReporte;
            var estado = req.body.Estado;
            var seguimiento = req.body.Seguimiento;
            var auxQuery = `CALL uspUpdateReporteState(${idReporte}, ${estado}, '${seguimiento}')`;
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

router.post('/HackLeon/v1/Link_Reporte_Funcionario', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var idReporte = req.body.IdReporte;
            var idServidorPublico = req.body.IdServidorPublico;
            var idAnalistaC4 = req.body.IdAnalistaC4;
            var auxQuery = `CALL uspLink_Reporte_Funcionario(${idReporte}, ${idServidorPublico}, ${idAnalistaC4})`;
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

router.post('/HackLeon/v1/Link_ReporteSOS_Dependencia', function(req, res, next) {
  try{
    var reqObj = req.body;
    console.log(reqObj);
    req.getConnection(function(err, conn){
        if(err) {
            console.error('SQL Connection error: ', err);
            return next(err);
        }else{
            var idReporteSOS = req.body.IdReporteSOS;
            var idDependencia = req.body.IdDependencia;
            var idAnalista911 = req.body.IdAnalista911;
            var auxQuery = `CALL uspLink_ReporteSOS_Dependencia(${idReporteSOS}, ${idDependencia}, ${idAnalista911})`;
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

            var auxQuery = `CALL uspGiveApoyo(${id_ciudadano_p}, ${id_reporte_p})`;
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


module.exports = router;
