USE MASTER;
GO
if DB_ID (N'lab14_1') IS NOT NULL
	DROP DATABASE lab14_1;
GO
CREATE DATABASE lab14_1
GO


USE MASTER;
GO
if DB_ID (N'lab14_2') is not null
	DROP DATABASE lab14_2;
GO
CREATE DATABASE lab14_2
GO


USE lab14_1;
DROP TABLE IF EXISTS Auto;

CREATE TABLE Auto (
	ID INT PRIMARY KEY NOT NULL,
	Engine_type CHAR(100) default 'petrol',
	Year_auto int check (Year_auto <= YEAR(GETDATE())) NOT NULL
);
GO

USE lab14_2;
DROP TABLE IF EXISTS Auto;

CREATE TABLE Auto (
	ID INT PRIMARY KEY NOT NULL,
	Mark CHAR(100) NOT NULL,
	Model CHAR(100) NOT NULL,
	Price INT NOT NULL
);

GO
DROP VIEW IF EXISTS sectionAutoView
GO

CREATE VIEW sectionAutoView AS
	SELECT one.ID, one.Engine_type, one.Year_auto, two.Mark, two.Model, two.Price
	FROM lab14_1.dbo.Auto one, lab14_2.dbo.Auto two
	WHERE one.ID = two.ID
GO

DROP TRIGGER IF EXISTS AutoViewIns 
DROP TRIGGER IF EXISTS AutoViewUpd 
DROP TRIGGER IF EXISTS AutoViewDel 
GO

-- Вставка
CREATE TRIGGER AutoViewIns ON sectionAutoView
INSTEAD OF INSERT
AS
	INSERT INTO lab14_1.dbo.Auto(ID, Engine_type, Year_auto)
		SELECT inserted.ID, inserted.Engine_type, inserted.Year_auto
		FROM inserted
	INSERT INTO lab14_2.dbo.Auto(ID, Mark, Model, Price)
		SELECT inserted.ID, inserted.Mark, inserted.Model, inserted.Price
		FROM inserted
GO

-- Обновление
CREATE TRIGGER AutoViewUpd ON sectionAutoView
INSTEAD OF UPDATE
AS
	IF UPDATE(ID)
		BEGIN
			RAISERROR('Запрещено обновлять идентификатор.', 16, -1)
		END
	ELSE
		BEGIN
			UPDATE lab14_1.dbo.Auto
				SET Engine_type = inserted.Engine_type, Year_auto = inserted.Year_auto
					FROM inserted, lab14_1.dbo.Auto as table1
					WHERE table1.ID = inserted.ID
			UPDATE lab14_2.dbo.Auto
				SET Mark = inserted.Mark,	Model = inserted.Model, Price = inserted.Price
					FROM inserted, lab14_2.dbo.Auto as table2
					WHERE table2.ID = inserted.ID
		END
GO

-- Удаление
CREATE TRIGGER AutoViewDel ON sectionAutoView
INSTEAD OF DELETE
AS
	DELETE table1 FROM lab14_1.dbo.Auto as table1
		INNER JOIN deleted as del on
		table1.ID = del.ID
	DELETE table2 FROM lab14_2.dbo.Auto as table2
		INNER JOIN deleted as del on
		table2.ID = del.ID
GO




INSERT INTO sectionAutoView(ID, Engine_type, Year_auto, Mark, Model, Price)
VALUES (1, 'Petrol', 2020, 'Toyota', 'Camry', 25000),
		(4, 'Diesel', 2019, 'Honda', 'Accord', 23000),
		(6, 'Electric', 2017, 'Tesla', 'Accord', 17000),
		(8, 'Petrol', 2020, 'Toyota', 'Camry', 25000),
		(3, 'Electric', 2022, 'Tesla', 'Model 3', 45000)
GO
SELECT * FROM sectionAutoView

--SELECT * FROM lab14_1.dbo.Auto
--SELECT * FROM lab14_2.dbo.Auto

UPDATE sectionAutoView
SET Model = 'Civic'
WHERE Model = 'Accord'
SELECT * FROM sectionAutoView

DELETE sectionAutoView
WHERE Model = 'Civic' AND Mark = 'Tesla'
SELECT * FROM sectionAutoView
