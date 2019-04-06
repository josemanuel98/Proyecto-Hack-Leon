CREATE DATABASE DBHackLeon;

USE DBHackLeon;

/*****************Tablas************************/

CREATE TABLE CategoriaReporteSOS
(
	IdCategoriaReporte TINYINT AUTO_INCREMENT PRIMARY KEY,
    Denominacion NVARCHAR(30) NOT NULL
);

CREATE TABLE Rol
(
	IdRol TINYINT AUTO_INCREMENT PRIMARY KEY,
    Denominacion NVARCHAR(30) NOT NULL
);

CREATE TABLE Zona
(
	IdZona INT AUTO_INCREMENT PRIMARY KEY,
    Ubicacion TEXT NOT NULL
);

CREATE TABLE CategoriaReporte
(
	IdCategoriaReporte TINYINT PRIMARY KEY AUTO_INCREMENT,
    Denominacion NVARCHAR(30) NOT NULL
);

CREATE TABLE HorarioZona
(
	IdHorarioZona INT AUTO_INCREMENT PRIMARY KEY,
    HoraInicial TINYINT NOT NULL,
    HoraFinal TINYINT NOT NULL
);

CREATE TABLE Ciudadano
(
	IdCiudadano BIGINT AUTO_INCREMENT PRIMARY KEY,
    Nickname NVARCHAR(30) UNIQUE NOT NULL,
    Contraseña NVARCHAR(30) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    CURP NVARCHAR(18) UNIQUE NOT NULL
);

CREATE TABLE ServidorPublico
(
	IdServidorPublico INT AUTO_INCREMENT PRIMARY KEY,
    IdRol TINYINT NOT NULL,
    Username NVARCHAR(30) UNIQUE NOT NULL,
    Contraseña NVARCHAR(30) NOT NULL,
    RFC NVARCHAR(13) UNIQUE NOT NULL
);

CREATE TABLE Reporte
(
	IdReporte BIGINT AUTO_INCREMENT PRIMARY KEY,
    IdCiudadano BIGINT NOT NULL,
    IdCategoriaReporte TINYINT NOT NULL,
    Descripcion NVARCHAR(50) NOT NULL,
    Foto NVARCHAR(255) NOT NULL,
    NoApoyos BIGINT NULL,
    FechaRegistro DATETIME NOT NULL,
    UbicacionRegistro TEXT NOT NULL,
    FechaHecho DATETIME NOT NULL,
    UbicacionHecho TEXT NOT NULL
);

CREATE TABLE ReporteSOS
(
	IdReporteSOS BIGINT AUTO_INCREMENT PRIMARY KEY,
    IdCiudadano BIGINT NOT NULL,
    IdCategoriaReporteSOS TINYINT NOT NULL,
    IdServidorPublico INT DEFAULT 0,
    Ubicacion NVARCHAR(255) NOT NULL,
    Fecha DATETIME NOT NULL,
    Video NVARCHAR(255) NULL,
    Foto NVARCHAR(255) NULL,
    Audio NVARCHAR(255) NOT NULL,
    IsCerrada BOOLEAN DEFAULT FALSE
);

CREATE TABLE Detalle_Zona_Horario
(
	IdDetalleZona_Horario INT AUTO_INCREMENT PRIMARY KEY,
    IdHorarioZona TINYINT NOT NULL,
    IdZona INT NOT NULL,
    Codigo CHAR(1) NOT NULL
);

CREATE TABLE Detalle_Ciudadano_Zona
(
	IdCiudadano_Zona BIGINT AUTO_INCREMENT PRIMARY KEY,
    IdZona INT NOT NULL,
    IdCiudadano BIGINT NOT NULL
);

CREATE TABLE Detalle_Ciudadano_Reporte
(
	IdDetalleCiudadano_Reporte BIGINT AUTO_INCREMENT PRIMARY KEY,
    IdCiudadano BIGINT NOT NULL,
    IdReporte BIGINT NOT NULL,
    IsActivo BOOLEAN DEFAULT TRUE
);

/*************Relaciones**********************/

ALTER TABLE ServidorPublico ADD CONSTRAINT FK_Rol_ServidorPublico FOREIGN KEY(IdRol) REFERENCES Rol(IdRol);

ALTER TABLE Reporte ADD CONSTRAINT FK_Ciudadano_Reporte FOREIGN KEY(IdCiudadano) REFERENCES Ciudadano(IdCiudadano);

ALTER TABLE Reporte ADD CONSTRAINT FK_CategoriaReporte_Reporte FOREIGN KEY(IdCategoriaReporte) REFERENCES CategoriaReporte(IdCategoriaReporte);

ALTER TABLE ReporteSOS ADD CONSTRAINT FK_Persona_ReporteSOS FOREIGN KEY(IdCiudadano) REFERENCES Ciudadano(IdCiudadano);

ALTER TABLE ReporteSOS ADD CONSTRAINT FK_CategoriaReporteSOS_ReporteSOS FOREIGN KEY(IdCategoriaReporteSOS) REFERENCES CategoriaReporteSOS(IdCategoriaReporteSOS);

ALTER TABLE ReporteSOS ADD CONSTRAINT FK_ServidorPublico_ReporteSOS FOREIGN KEY(IdServidorPublico) REFERENCES ServidorPublico(IdServidorPublico);

ALTER TABLE Detalle_Zona_Horario ADD CONSTRAINT FK_HorarioZona_Detalle_Zona_Horario FOREIGN KEY(IdHorarioZona) REFERENCES HorarioZona(IdHorarioZona);

ALTER TABLE Detalle_Zona_Horario ADD CONSTRAINT FK_Zona_Detalle_Zona_Horario FOREIGN KEY(IdZona) REFERENCES Zona(IdZona);

ALTER TABLE Detalle_Ciudadano_Reporte ADD CONSTRAINT FK_Ciudadano_Detalle_Ciudadano_Reporte FOREIGN KEY(IdCiudadano) REFERENCES Ciudadano(IdCiudadano);

ALTER TABLE Detalle_Ciudadano_Reporte ADD CONSTRAINT FK_Reporte_Detalle_Ciudadano_Reporte FOREIGN KEY(IdReporte) REFERENCES Reporte(IdReporte);

/************Procedimientos Almacenados********************/

DELIMITER $$
CREATE PROCEDURE uspLogInCiudadano
(
	Email_P NVARCHAR(100),
    Contraseña_P NVARCHAR(30)
)
BEGIN
    SET @idCiudadano = 0;
	
    IF (SELECT COUNT(IdCiudadano) FROM Ciudadano WHERE Email LIKE Email_P AND Contraseña LIKE Contraseña_P)
		THEN
            SET @idCiudadano = (SELECT IdCiudadano FROM Ciudadano WHERE Email LIKE Email_P AND Contraseña LIKE Contraseña_P);
	END IF;
    
    SELECT @idUsuario;
END;
$$

###### 2 
DELIMITER $$
CREATE PROCEDURE uspLogInServidoPublico
(
	Username_P NVARCHAR(100),
    Contraseña_P NVARCHAR(30)
)
BEGIN
    SET @idServidorPublico = 0;
	
    IF (SELECT COUNT(IdServidorPublico) FROM ServidorPublico WHERE Username LIKE Username_P AND Contraseña LIKE Contraseña_P)
		THEN
            SET @idServidorPublico = (SELECT IdServidorPublico FROM ServidorPublico WHERE Username LIKE Username_P AND Contraseña LIKE Contraseña_P);
	END IF;
    
    SELECT @idServidorPublico;
END;
$$
##### 3
DELIMITER $$
CREATE PROCEDURE uspAddCiudadano
(
	Nickname_P NVARCHAR(30),
    Contraseña_P NVARCHAR(30),
    Email_P NVARCHAR(100),
    Curp_P NVARCHAR(18)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO Ciudadano
    (
		Nickname,
        Contraseña,
        Email,
        Curp
    )
    VALUES
    (
		Nickname_P,
        Contraseña_P,
        Email_P,
        Curp_P
    );
    
    SELECT TRUE;
    COMMIT;
END;
$$

#### 4.
DELIMITER $$
CREATE PROCEDURE uspAddServidorPublico
(
	IdRol_P TINYINT,
    Username_P NVARCHAR(30),
    Contraseña_P NVARCHAR(30),
    RFC_P NVARCHAR(13)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO ServidorPublico
    (
		IdRol,
        Username,
        Contraseña,
        RFC
    )
    VALUES
    (
		IdRol_P,
        Username_P,
        Contraseña_P,
        RFC_P
    );
    
    SELECT TRUE;
    COMMIT;
END;
$$

####### 5.
DELIMITER $$
CREATE PROCEDURE uspAddReporte
(
	IdCiudadano_P BIGINT,
    IdCategoriaReporte_P TINYINT,
    Descripcion_P NVARCHAR(50),
    Foto_P NVARCHAR(255),
	UbicacionRegistro_P TEXT,
    UbicacionHecho_P TEXT,
    FechaHecho_P DATETIME
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO Reporte
    (
		IdCiudadano,
        IdCategoriaReporte,
        Descripcion,
        Foto,
        NoVotos,
        FechaRegistro,
        UbicacionRegistro,
        FechaHecho,
        UbicacionHecho
    )
    VALUES
    (
		IdCiudadano_P,
        IdCategoriaReporte_P,
        Descripcion_P,
        Foto_P,
        0,
        NOW(),
        UbicacionRegistro_P,
        FechaHecho_P,
        UbicacionHecho_P
    );
    
    SELECT TRUE;
    COMMIT;
END;
$$



####### 6.
DELIMITER $$
CREATE PROCEDURE uspGiveApoyo
(
	IdCiudadano_P BIGINT,
    IdReporte_P BIGINT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO Detalle_Ciudadano_Reporte
    (
		IdCiudadano,
        IdReporte
    )
    VALUES
    (
		IdCiudadano_P,
        IdReporte_P
    );
    
    UPDATE Reporte
		SET 
			NoApoyos = (SELECT NoApoyos FROM Reporte WHERE IdReporte_P = IdReporte) + 1
        WHERE
			IdReporte_P = IdReporte;
	
    SELECT TRUE;
	COMMIT;
END;
$$

####### 7
DELIMITER $$
CREATE PROCEDURE uspRemoveApoyo
(
	IdCiudadano_P BIGINT,
    IdReporte_P BIGINT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    SET @idDetalle_Ciudadano_Reporte = (SELECT IdDetalle_Ciudadano_Reporte FROM Detalle_Ciudadano_Reporte WHERE IdReporte_P = IdReporte);
    
    UPDATE Detalle_Ciudadano_Reporte
		SET
			IsActivo = FALSE
		WHERE 
			@idDetalle_Ciudadano_Reporte = IdDetalleCiudadano_Reporte;
    
    UPDATE Reporte
		SET 
			NoApoyos = (SELECT NoApoyos FROM Reporte WHERE IdReporte_P = IdReporte) - 1
        WHERE
			IdReporte_P = IdReporte;
	
    SELECT TRUE;
	COMMIT;
END;
$$

######## 8
DELIMITER $$
CREATE PROCEDURE uspAddReporteSOS_Video
(
	IdCiudadano_P BIGINT,
    IdCategoriaReporteSOS_P TINYINT,
    Ubicacion_P NVARCHAR(255),
    Video_P NVARCHAR(255)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO ReporteSOS
    (
		IdCiudadano,
        IdCategoriaReporteSOS,
        IdServidorPublico,
        Ubicacion,
        Fecha,
        Video
    )
    VALUES
    (
		IdCiudadano_P,
        IdCategoriaReporteSOS_P,
        IdServidorPublico_P,
        Ubicacion_P,
        Video_P
    );
    
    SELECT TRUE;
    COMMIT;
END;
$$

###### 9
DELIMITER $$
CREATE PROCEDURE uspAddReporteSOS_Imagen
(
	IdCiudadano_P BIGINT,
    IdCategoriaReporteSOS_P TINYINT,
    Ubicacion_P NVARCHAR(255),
    Imagen_P NVARCHAR(255)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO ReporteSOS
    (
		IdCiudadano,
        IdCategoriaReporteSOS,
        IdServidorPublico,
        Ubicacion,
        Fecha,
        Imagen
    )
    VALUES
    (
		IdCiudadano_P,
        IdCategoriaReporteSOS_P,
        IdServidorPublico_P,
        Ubicacion_P,
        Imagen_P
    );
    
    SELECT TRUE;
    COMMIT;
END;
$$


####### 10
DELIMITER $$
CREATE PROCEDURE uspAddReporteSOS_Audio
(
	IdCiudadano_P BIGINT,
    IdCategoriaReporteSOS_P TINYINT,
    Ubicacion_P NVARCHAR(255),
    Audio_P NVARCHAR(255)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO ReporteSOS
    (
		IdCiudadano,
        IdCategoriaReporteSOS,
        IdServidorPublico,
        Ubicacion,
        Fecha,
        Audio
    )
    VALUES
    (
		IdCiudadano_P,
        IdCategoriaReporteSOS_P,
        IdServidorPublico_P,
        Ubicacion_P,
        Audio_P
    );
    
    SELECT TRUE;
    COMMIT;
END;
$$

###### 11
DELIMITER $$
CREATE PROCEDURE uspFinishReporteSOS
(
	IdServidorPublico_P INT,
    IdReporteSOS_P BIGINT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    SET @idRol = (SELECT IdRol FROM ServidorPublico WHERE IdServidorPublico = IdServidorPublico_P);
    
    IF (SELECT @idRol = 3)
		THEN
            UPDATE ReporteSOS
				SET
					IdServidorPublico = IdServidorPublico_P,
					IsCerrada = TRUE
				WHERE
					IdReporteSOS_P = IdReporteSOS;
			SELECT TRUE;
            COMMIT;
		ELSE
			SELECT FALSE;
	END IF;
END;
$$

########## 12
DELIMITER $$
CREATE PROCEDURE uspAddHorarioZona
(
	IdServidorPublico_P INT,
    HoraInicial_P TINYINT,
    HoraFinal_P TINYINT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    SET @idRol = (SELECT IdRol FROM ServidorPublico WHERE IdServidorPublico = IdServidorPublico_P);
    
    IF (SELECT @idRol = 3)
		THEN
            INSERT INTO HorarioZona
            (
				HoraInicial,
                HoraFinal
            )
            VALUES
            (
				HoraInicial_P,
                HoraFinal_P
            );
			SELECT TRUE;
            COMMIT;
		ELSE
			SELECT FALSE;
	END IF;
END;
$$

###### 13
DELIMITER $$
CREATE PROCEDURE uspAddDetalle_Zona_Horario
(
	IdServidorPublico_P INT,
	IdHorarioZona_P TINYINT,
    IdZona_P INT,
    Codigo_P CHAR(1)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    SET @idRol = (SELECT IdRol FROM ServidorPublico WHERE IdServidorPublico = IdServidorPublico_P);
    
    IF (SELECT @idRol = 3)
		THEN
            INSERT INTO Detalle_Zona_Horario
            (
				IdHorarioZona,
                IdZona,
                Codigo
            )
            VALUES
            (
				IdHorarioZona_P,
                IdZona_P,
                Codigo_P
            );
			SELECT TRUE;
            COMMIT;
		ELSE
			SELECT FALSE;
	END IF;
END;
$$


##### 14
DELIMITER $$
CREATE PROCEDURE uspUpdateDetalle_Zona_Horario
(
	IdServidorPublico_P INT,
    IdDetalle_Zona_Horario_P INT,
    Codigo_P CHAR(1)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    SET @idRol = (SELECT IdRol FROM ServidorPublico WHERE IdServidorPublico = IdServidorPublico_P);
    
    IF (SELECT @idRol = 3)
		THEN
            UPDATE Detalle_Zona_Horario
				SET 
					Codigo = Codigo_P
                WHERE 
					IdDetalle_Zona_Horario = IdDetalle_Zona_Horario_P;
			SELECT TRUE;
            COMMIT;
		ELSE
			SELECT FALSE;
	END IF;
END;
$$

##### 15
DELIMITER $$
CREATE PROCEDURE uspAddDetalle_Ciudadano_Zona
(
	IdCiudadano BIGINT,
    IdZona INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO Detalle_Ciudadano_Zona
    (
		IdCiudadano,
        IdZona
    )
    VALUES
    (
		IdCiudadano_P,
        IdZona_P
    );
    
    SELECT TRUE;
    COMMIT;
END;
$$

/****************Consultas*************************/
#### 16
DELIMITER $$
CREATE PROCEDURE uspGetAllReporte()
BEGIN
	SELECT 
		IdReporte, IdCategoria
    FROM 
		Reporte
	ORDER BY IdReporte ASC;
END;
$$

DELIMITER $$
CREATE PROCEDURE uspGetReporteById
(
	IdReporte_P BIGINT
)
BEGIN
	SELECT 
		* 
	FROM 
		Reporte
	WHERE
		IdReporte_P = IdReporte;
END;
$$

DELIMITER $$
CREATE PROCEDURE uspGetAllCategoriaReporte()
BEGIN
	SELECT
		*
	FROM
		CategoriaReporte;
END;
$$

DELIMITER $$
CREATE PROCEDURE uspGetAllCategoriaReporteSOS()
BEGIN
	SELECT
		*
	FROM
		CategoriaReporteSOS;
END;
$$

DELIMITER $$
CREATE PROCEDURE uspGetAllRol()
BEGIN
	SELECT
		*
	FROM
		Rol;
END;
$$

