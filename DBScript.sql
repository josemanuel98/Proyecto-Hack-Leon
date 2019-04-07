CREATE DATABASE DBHackLeon;

USE DBHackLeon;

/***************** Tablas ************************/

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

CREATE TABLE Ciudadano
(
	IdCiudadano BIGINT AUTO_INCREMENT PRIMARY KEY,
    Nickname NVARCHAR(30) UNIQUE NOT NULL,
    Contraseña NVARCHAR(30) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    CURP NVARCHAR(18) UNIQUE NOT NULL
);

CREATE TABLE Analista911
(
	IdAnalista911 INT AUTO_INCREMENT PRIMARY KEY,
    Username NVARCHAR(30) NOT NULL,
    Contraseña NVARCHAR(30) NOT NULL,
    RFC NVARCHAR(13) NOT NULL
);

CREATE TABLE Dependencia
(
	IdDependencia INT AUTO_INCREMENT PRIMARY KEY,
    Nombre NVARCHAR(30) NOT NULL,
    Ubicacion NVARCHAR(255) NOT NULL
);

CREATE TABLE ServidorPublico
(
	IdServidorPublico INT AUTO_INCREMENT PRIMARY KEY,
    IdRol TINYINT NOT NULL,
    Username NVARCHAR(30) UNIQUE NOT NULL,
    Contraseña NVARCHAR(30) NOT NULL,
    RFC NVARCHAR(13) UNIQUE NOT NULL
);

CREATE TABLE AnalistaC4
(
	IdAnalistaC4 INT AUTO_INCREMENT PRIMARY KEY,
    IdZona INT NOT NULL,
    Username NVARCHAR(30) NOT NULL,
    Contraseña NVARCHAR(30) NOT NULL,
    RFC NVARCHAR(13) NOT NULL
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
    UbicacionHecho TEXT NOT NULL,
    Estado TINYINT DEFAULT 1,
    Seguimiento NVARCHAR(100) DEFAULT 'Reporte Registrado'
);

CREATE TABLE Canalizacion_Reporte
(
	IdReporte BIGINT DEFAULT 1 PRIMARY KEY,
    IdServidorPublico INT NOT NULL,
    IdAnalistaC4 INT NOT NULL,
    Fecha DATETIME NOT NULL
);

CREATE TABLE ReporteSOS
(
	IdReporteSOS BIGINT AUTO_INCREMENT PRIMARY KEY,
    IdCiudadano BIGINT NOT NULL,
    IdCategoriaReporteSOS TINYINT NOT NULL,
    Ubicacion NVARCHAR(255) NOT NULL,
    Fecha DATETIME NOT NULL,
    Video NVARCHAR(255) NULL,
    Foto NVARCHAR(255) NULL,
    Audio NVARCHAR(255) NOT NULL,
    IsCerrado BOOLEAN DEFAULT FALSE
);

CREATE TABLE Canalizacion_Reporte_SOS
(
	IdReporteSOS BIGINT PRIMARY KEY NOT NULL,
    IdDependencia INT NULL,
    IdAnalista911 INT NULL,
    Fecha DATETIME NULL
);


/************* Relaciones **********************/

ALTER TABLE ServidorPublico ADD CONSTRAINT FK_Rol_ServidorPublico FOREIGN KEY(IdRol) REFERENCES Rol(IdRol);

ALTER TABLE AnalistaC4 ADD CONSTRAINT FK_Zona_ServidorPublico FOREIGN KEY(IdZona) REFERENCES Zona(IdZona);

ALTER TABLE Reporte ADD CONSTRAINT FK_Ciudadano_Reporte FOREIGN KEY(IdCiudadano) REFERENCES Ciudadano(IdCiudadano);

ALTER TABLE Reporte ADD CONSTRAINT FK_CategoriaReporte_Reporte FOREIGN KEY(IdCategoriaReporte) REFERENCES CategoriaReporte(IdCategoriaReporte);

ALTER TABLE Canalizacion_Reporte ADD CONSTRAINT FK_ServidorPublico_Canalizacion_Reporte FOREIGN KEY(IdServidorPublico) REFERENCES ServidorPublico(IdServidorPublico);

ALTER TABLE Canalizacion_Reporte ADD CONSTRAINT FK_Reporte_Canalizacion_Reporte FOREIGN KEY(IdReporte) REFERENCES Reporte(IdReporte);

ALTER TABLE ReporteSOS ADD CONSTRAINT FK_Ciudadano_ReporteSOS FOREIGN KEY(IdCiudadano) REFERENCES Ciudadano(IdCiudadano);

ALTER TABLE ReporteSOS ADD CONSTRAINT FK_CategoriaReporteSOS_ReporteSOS FOREIGN KEY(IdCategoriaReporteSOS) REFERENCES CategoriaReporteSOS(IdCategoriaReporteSOS);

ALTER TABLE CanalizacionReporteSOS ADD CONSTRAINT FK_ReporteSOS_Canalizacion_Reporte_SOS FOREIGN KEY(IdReporteSOS) REFERENCES ReporteSOS(IdReporteSOS);

ALTER TABLE Canalizacion_Reporte_SOS ADD CONSTRAINT FK_Dependencia_Canalizacion_Reporte_SOS FOREIGN KEY(IdDependencia) REFERENCES Dependencia(IdDependencia);

ALTER TABLE Canalizacion_Reporte_SOS ADD CONSTRAINT FK_Analista_Canalizacion_Reporte_SOS FOREIGN KEY(IdAnalista911) REFERENCES Analista911(IdAnalista911);

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

DELIMITER $$
CREATE PROCEDURE uspUpdateReporteState
(
	IdReporte_P BIGINT,
    Estado_P TINYINT,
    Seguimiento_P NVARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    UPDATE Reporte
		SET
			Estado = Estado_P,
            Seguimiento = Seguimiento_P
		WHERE 
			IdReporte_P = IdReporte;
	SELECT TRUE;
    COMMIT;
END;
$$

DELIMITER $$
CREATE PROCEDURE uspLink_Reporte_Funcionario
(
	IdReporte_P BIGINT,
    IdServidorPublico_P INT,
    IdAnalistaC4_P INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO Canalizacion_Reporte
    (
		IdReporte,
        IdServidorPublico,
        IdAnalistaC4,
        Fecha
    )
    VALUES
    (
		IdReporte_P,
        IdServidorPublico_P,
        IdAnalista_P,
        NOW()
    );
    
    SELECT TRUE;
    COMMIT;
END;
$$

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
        NOW(),
        Video_P
    );
    
    SET @idReporteSOS = (SELECT LAST_INSERT_Id());
    
    INSERT INTO Canalizacion_Reporte_SOS
    (
		IdReporteSOS
    )
    VALUES
    (
		@idReporteSOS
    );
    
    SELECT TRUE;
    COMMIT;
END;
$$

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
    
    SET @idReporteSOS = (SELECT LAST_INSERT_Id());
    
    INSERT INTO Canalizacion_Reporte_SOS
    (
		IdReporteSOS
    )
    VALUES
    (
		@idReporteSOS
    );
    
    SELECT TRUE;
    COMMIT;
END;
$$


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
    
    SET @idReporteSOS = (SELECT LAST_INSERT_Id());
    
    INSERT INTO Canalizacion_Reporte_SOS
    (
		IdReporteSOS
    )
    VALUES
    (
		@idReporteSOS
    );
    
    SELECT TRUE;
    COMMIT;
END;
$$

DELIMITER $$
CREATE PROCEDURE uspLink_ReporteSOS_Dependencia
(
	IdReporteSOS_P BIGINT,
	IdDependencia_P INT,
    IdAnalista911_P INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    UPDATE Canalizacion_Reporte_SOS
		SET
			IdDependencia = IdDependencia_P,
            IdAnalista911 = IdAnalista911_P,
            Fecha = NOW()
		WHERE
			IdReporteSOS_P = IdReporteSOS;
    SELECT TRUE;
    COMMIT;
END;
$$

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

/****************Consultas*************************/

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

/*************  *****************/