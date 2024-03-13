CREATE DATABASE IF NOT EXISTS repasoBD1;


USE repasoBD1;

DROP TABLE IF EXISTS Venta;
DROP TABLE IF EXISTS Reserva;
DROP TABLE IF EXISTS Vuelo;
DROP TABLE IF EXISTS Asiento;
DROP TABLE IF EXISTS Pasajero;
DROP TABLE IF EXISTS Aeronave;
DROP TABLE IF EXISTS Estado;
DROP TABLE IF EXISTS Tipo_doc;


CREATE TABLE Tipo_doc (
    Id_tipo_doc INT PRIMARY KEY,
    Nombre VARCHAR(255)
);

CREATE TABLE Estado (
    Id_estado INT PRIMARY KEY,
    Nombre VARCHAR(255),
    Descripcion TEXT,
    Fecha DATE
);

CREATE TABLE Aeronave (
    Id_aeronave INT PRIMARY KEY,
    Nombre VARCHAR(255)
);

CREATE TABLE Pasajero (
    Id_pasajero INT PRIMARY KEY,
    Id_tipo_doc_fk INT,
    Nombre VARCHAR(255),
    Apellido VARCHAR(255),
    Documento VARCHAR(255),
    Telefono VARCHAR(255),
    Email VARCHAR(255),
    FOREIGN KEY (Id_tipo_doc_fk) REFERENCES Tipo_doc(Id_tipo_doc)
);

CREATE TABLE Asiento (
    Id_asiento INT PRIMARY KEY,
    Disponible BOOLEAN,
    Pago DECIMAL(10, 2)
);

CREATE TABLE Vuelo (
    Id_vuelo INT PRIMARY KEY,
    Id_estado_fk INT,
    Id_aeronave_fk INT,
    Puerta VARCHAR(255),
    Hora_salida DATETIME,
    Lugar_salida VARCHAR(255),
    Hora_llegada DATETIME,
    Lugar_llegada VARCHAR(255),
    FOREIGN KEY (Id_estado_fk) REFERENCES Estado(Id_estado),
    FOREIGN KEY (Id_aeronave_fk) REFERENCES Aeronave(Id_aeronave)
);

CREATE TABLE Reserva (
    Id_reserva INT PRIMARY KEY,
    Id_vuelo_fk INT,
    Id_pasajero_fk INT,
    FOREIGN KEY (Id_vuelo_fk) REFERENCES Vuelo(Id_vuelo),
    FOREIGN KEY (Id_pasajero_fk) REFERENCES Pasajero(Id_pasajero)
);

CREATE TABLE Venta (
    Id_venta INT PRIMARY KEY,
    Id_reserva_fk INT,
    Id_asiento_fk INT,
    Monto DECIMAL(10, 2),
    FOREIGN KEY (Id_reserva_fk) REFERENCES Reserva(Id_reserva),
    FOREIGN KEY (Id_asiento_fk) REFERENCES Asiento(Id_asiento)
);

