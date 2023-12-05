USE lab6;
/*
IF OBJECT_ID(N'dbo.CUSTOMERS', N'U') IS NOT NULL
    DROP TABLE dbo.CUSTOMERS;
GO
CREATE TABLE CUSTOMERS (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Year_birth INT NOT NULL,
	NAME CHAR(100) NOT NULL,
	SURNAME CHAR(100) NOT NULL,
	FullName AS NAME + SURNAME,
	ContrID INT FOREIGN KEY REFERENCES Contract(ContrID) ON DELETE NO ACTION
);*/

/*
INSERT INTO CUSTOMERS(Year_birth, NAME, SURNAME, ContrID)
VALUES (2006, 'QWER', 'SHGB', 3),
	   (1991, 'KK,', 'GGO;/G', 4);
SELECT * FROM CUSTOMERS
*/
/*
IF OBJECT_ID(N'dbo.ViewCustContr', N'V') IS NOT NULL
    DROP VIEW dbo.ViewCustContr;
GO
CREATE VIEW ViewCustContr
WITH SCHEMABINDING
AS
SELECT C.ContrID, C.Place, C.Price, A.ID, A.Year_birth, A.NAME, A.SURNAME, A.FullName
FROM dbo.Contract C
JOIN dbo.CUSTOMERS A ON C.ContrID = A.ContrID;
GO
*/









/*
----------------------------------------------------------- 1
-- Вставка
IF OBJECT_ID(N'dbo.TRIGGER1', N'TR') IS NOT NULL
    DROP TRIGGER dbo.TRIGGER1;
GO

CREATE TRIGGER TRIGGER1
ON Auto
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE LEN(Mark) > 15
    )

    BEGIN
        RAISERROR('Вставка данных с подобным названием автомобиля запрещена.', 16, 1);
    END;
END;
GO

-- Удаление
IF OBJECT_ID(N'dbo.TRIGGER2', N'TR') IS NOT NULL
    DROP TRIGGER dbo.TRIGGER2;
GO

CREATE TRIGGER TRIGGER2
ON Auto
AFTER DELETE
AS
BEGIN
	IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        PRINT 'Данные успешно удалены из таблицы.';
    END;
END;
GO

-- Обновление
IF OBJECT_ID(N'dbo.TRIGGER3', N'TR') IS NOT NULL
    DROP TRIGGER dbo.TRIGGER3;
GO

CREATE TRIGGER TRIGGER3
ON Auto
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE Year_auto < 1900
    )
    BEGIN
		RAISERROR('Обновление автомобилей с годом выпуска менее 1900 запрещено.', 16, 1);
        --THROW 51000, 'Обновление автомобилей с годом выпуска менее 1900 запрещено.', 1;
    END;
END;

GO
INSERT INTO Auto(Year_auto, Mark, Model)
VALUES (2023, 'dodgeуууууууууууууууууууууууу', 'ram')
GO
DELETE FROM Auto
WHERE VIN = 123456;
GO
UPDATE Auto
SET Year_auto = 1899
WHERE VIN = 123457;
GO
SELECT * FROM Auto
GO
*/

----------------------------------------------------------- 2
-- Добавление


IF OBJECT_ID(N'dbo.TRIGGER11', N'TR') IS NOT NULL
    DROP TRIGGER dbo.TRIGGER11;
GO

CREATE TRIGGER TRIGGER11
ON ViewCustContr
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Contract (Place, Price)
    SELECT i.Place, i.Price
    FROM inserted i;

    -- Вставка данных в CUSTOMERS с использованием SCOPE_IDENTITY() для получения последнего значения ContrID
    INSERT INTO CUSTOMERS (Year_birth, NAME, SURNAME, ContrID)
    SELECT i.Year_birth, i.NAME, i.SURNAME, SCOPE_IDENTITY()
    FROM inserted i;
END;
GO


-- Удаление
IF OBJECT_ID(N'dbo.TRIGGER22', N'TR') IS NOT NULL
    DROP TRIGGER dbo.TRIGGER22;
GO

CREATE TRIGGER TRIGGER22
ON ViewCustContr
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM CUSTOMERS
    WHERE ContrID IN (SELECT ContrID FROM deleted);
	/*
    DELETE FROM Contract
    WHERE ContrID IN (SELECT ContrID FROM deleted);*/
END;
GO

-- Обновление
IF OBJECT_ID(N'dbo.TRIGGER33', N'TR') IS NOT NULL
    DROP TRIGGER dbo.TRIGGER33;
GO
/*
CREATE TRIGGER TRIGGER33
ON Auto4VIEW
INSTEAD OF UPDATE
AS
BEGIN
    UPDATE Contract
    SET Place = i.Place
    FROM Contract c
    INNER JOIN inserted i ON c.ContrID = i.ContrID;

    UPDATE CUSTOMERS
    SET NAME = i.NAME
    FROM CUSTOMERS cu
    INNER JOIN inserted i ON cu.ContrID = i.ContrID;
END;
GO*/



INSERT INTO ViewCustContr (Place, Price, Year_birth, Name, Surname)
VALUES ('йцукен', 123212321, 3020, 'QWE', 'musa');
GO


DELETE FROM ViewCustContr
WHERE ContrID = 30;
GO
SELECT * FROM Auto4
GO
/*UPDATE ViewCustContr
SET Place = 'italy', Name = 'italyanets'
WHERE ContrID = 31;
GO*/
SELECT * FROM CUSTOMERS
SELECT * FROM Contract
GO