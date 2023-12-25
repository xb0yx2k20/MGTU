USE master;
GO

IF DB_ID('MyDatabase') IS NOT NULL
DROP DATABASE MyDatabase;
GO

CREATE DATABASE MyDatabase
ON PRIMARY
( NAME = MyDataFile,  FILENAME = 'C:\data\MyDataFile.mdf', SIZE = 10MB, MAXSIZE = UNLIMITED, FILEGROWTH = 5MB )
LOG ON
( NAME = MyLogFile,  FILENAME = 'C:\data\MyLogFile.ldf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 5MB );
GO

USE MyDatabase;
GO

DROP TABLE IF EXISTS Auto;
GO


CREATE TABLE Auto (
	VIN INT IDENTITY(123456,1) PRIMARY KEY,
	Engine_type CHAR(100) default 'petrol',
	Year_auto int check (Year_auto <= YEAR(GETDATE())) NOT NULL,
	Mark CHAR(100) NOT NULL,
	Model CHAR(100) NOT NULL,
	FullName AS Mark + Model
);

INSERT INTO Auto(Year_auto, Mark, Model)
VALUES (2023, 'dodge', 'ram')


INSERT INTO Auto(Engine_type, Year_auto, Mark, Model)
VALUES ('diesel', 2020, 'ford', 'mustang')