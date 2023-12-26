USE MASTER;
GO
if DB_ID (N'lab15_1') IS NOT NULL
	DROP DATABASE lab15_1;
GO
CREATE DATABASE lab15_1
GO


USE MASTER;
GO
if DB_ID (N'lab15_2') is not null
	DROP DATABASE lab15_2;
GO
CREATE DATABASE lab15_2
GO

USE lab15_1;
DROP TABLE IF EXISTS Auto;
GO
CREATE TABLE Auto (
	VIN INT PRIMARY KEY NOT NULL,
	Engine_type CHAR(100) default 'petrol',
	Year_auto int check (Year_auto <= YEAR(GETDATE())) NOT NULL,
	Mark CHAR(100) NOT NULL,
	Model CHAR(100) NOT NULL,
	Price INT NOT NULL
);
GO
USE lab15_2;
DROP TABLE IF EXISTS Contract;
GO
CREATE TABLE Contract (
    IDContr INT IDENTITY(1,1) PRIMARY KEY,
    DATE INT CHECK (DATE <= YEAR(GETDATE())) NOT NULL,
    SalonName CHAR(100) NOT NULL,
    Place CHAR(100) NOT NULL,
    FinalPrice INT NOT NULL,
	AutoVIN INT NOT NULL
);
GO

DROP VIEW IF EXISTS ContractCars
GO
CREATE VIEW ContractCars AS
	SELECT one.VIN, one.Engine_type, one.Year_auto, one.Mark, one.Model, one.Price,
		   two.IDContr, two.DATE, two.SalonName, two.Place, two.FinalPrice
	FROM lab15_1.dbo.Auto one, lab15_2.dbo.Contract two
	WHERE one.VIN = two.AutoVIN
GO




USE lab15_1;
DROP TRIGGER IF EXISTS AUpd 
DROP TRIGGER IF EXISTS ADel 
GO

CREATE TRIGGER AUpd ON Auto
INSTED OF UPDATE
AS
	IF UPDATE(VIN)
		BEGIN
			RAISERROR('Изменение VIN запрещено.', 14, 1)
		END
GO

CREATE TRIGGER ADel ON Auto
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Удаление данных из таблицы Auto запрещено.', 14, 1);
END;
GO

USE lab15_2;
DROP TRIGGER IF EXISTS CUpd 
DROP TRIGGER IF EXISTS CDel
GO
CREATE TRIGGER CUpd ON Contract
FOR UPDATE
AS
	IF UPDATE(IDContr)
		BEGIN
			RAISERROR('Изменение ID запрещено.', 14, 1)
		END
GO

INSERT INTO lab15_1.dbo.Auto(VIN, Engine_type, Year_auto, Mark, Model, Price)
VALUES
(1, 'Petrol', 2020, 'Toyota', 'Camry', 25000),
(2, 'Diesel', 2019, 'Honda', 'Accord', 23000),
(3, 'Electric', 2017, 'Tesla', 'Accord', 17000),
(4, 'Electric', 2022, 'Tesla', 'Model 3', 45000);

INSERT INTO lab15_2.dbo.Contract (DATE, SalonName, Place, FinalPrice, AutoVIN)
VALUES
(2022, 'AutoSales', 'City A', 25000, 1),
(2020, 'CarWorld', 'City B', 23000,  3),
(2018, 'GreenCars', 'City C', 45000, 2);
SELECT * FROM ContractCars
GO

UPDATE lab15_1.dbo.Auto SET VIN = 7 WHERE VIN = 1;
DELETE FROM lab15_1.dbo.Auto WHERE VIN = 7;