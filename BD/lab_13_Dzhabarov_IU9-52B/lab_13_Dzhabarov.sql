USE MASTER;
GO
if DB_ID (N'lab13_1') IS NOT NULL
	DROP DATABASE lab13_1;
GO
CREATE DATABASE lab13_1
GO


USE MASTER;
GO
if DB_ID (N'lab13_2') is not null
	DROP DATABASE lab13_2;
GO
CREATE DATABASE lab13_2
GO


USE lab13_1;
DROP TABLE IF EXISTS Auto;

CREATE TABLE Auto (
	ID INT PRIMARY KEY CHECK (ID <= 5) NOT NULL,
	Engine_type CHAR(100) default 'petrol',
	Year_auto int check (Year_auto <= YEAR(GETDATE())) NOT NULL,
	Mark CHAR(100) NOT NULL,
	Model CHAR(100) NOT NULL,
	Price INT NOT NULL
);
GO

USE lab13_2;
DROP TABLE IF EXISTS Auto;

CREATE TABLE Auto (
	ID INT PRIMARY KEY CHECK (ID > 5) NOT NULL,
	Engine_type CHAR(100) default 'petrol',
	Year_auto int check (Year_auto <= YEAR(GETDATE())) NOT NULL,
	Mark CHAR(100) NOT NULL,
	Model CHAR(100) NOT NULL,
	Price INT NOT NULL
);

GO

DROP VIEW IF EXISTS sectionCARView
GO

CREATE VIEW sectionCARView AS
	SELECT * FROM lab13_1.dbo.Auto
	UNION ALL
	SELECT * FROM lab13_2.dbo.Auto
GO

INSERT INTO sectionCARView(ID, Engine_type, Year_auto, Mark, Model, Price)
VALUES (1, 'Petrol', 2020, 'Toyota', 'Camry', 25000),
		(4, 'Diesel', 2019, 'Honda', 'Accord', 23000),
		(6, 'Electric', 2017, 'Tesla', 'Accord', 17000),
		(8, 'Petrol', 2020, 'Toyota', 'Camry', 25000),
		(3, 'Electric', 2022, 'Tesla', 'Model 3', 45000)
GO

UPDATE sectionCARView
SET Model = 'Civic'
WHERE Model = 'Accord'

DELETE sectionCARView
WHERE Model = 'Civic' AND Mark = 'Tesla'

SELECT * FROM sectionCARView
SELECT * FROM lab13_1.dbo.Auto;
SELECT * FROM lab13_2.dbo.Auto;