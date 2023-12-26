/*USE master;
GO

IF DB_ID('MyDatabase2') IS NOT NULL
DROP DATABASE MyDatabase2;
GO

CREATE DATABASE MyDatabase2
ON PRIMARY
( NAME = MyDataFile,  FILENAME = 'C:\data\data\MyDataFile.mdf', SIZE = 10MB, MAXSIZE = UNLIMITED, FILEGROWTH = 5MB )
LOG ON
( NAME = MyLogFile,  FILENAME = 'C:\data\data\MyLogFile.ldf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 5MB );
GO
*/
USE MyDatabase2;
GO

DROP TABLE IF EXISTS Contract;
DROP TABLE IF EXISTS Auto;
DROP TABLE IF EXISTS Seller;
DROP TABLE IF EXISTS Customer;
DROP VIEW IF EXISTS CarContractView;
DROP INDEX IF EXISTS IX ON Auto;
DROP PROCEDURE IF EXISTS ALLINFO;
DROP FUNCTION IF EXISTS GetCarAge;
GO


CREATE TABLE Auto (
	VIN INT IDENTITY(123456,1) PRIMARY KEY,
	Engine_type CHAR(100) default 'petrol',
	Year_auto int check (Year_auto <= YEAR(GETDATE())) NOT NULL,
	Mark CHAR(100) NOT NULL,
	Model CHAR(100) NOT NULL,
	Price INT NOT NULL,
	FullName AS Mark + Model,
);

CREATE TABLE Seller (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Year_birth INT CHECK (Year_Birth <= (YEAR(GETDATE()) - 18)) NOT NULL,
    Name CHAR(100) NOT NULL,
    Surname CHAR(100) NOT NULL,
    Job CHAR(100) NOT NULL
);

CREATE TABLE Customer (
	PhoneNumber INT PRIMARY KEY,
	Year_birth int check (Year_Birth <= (YEAR(GETDATE()) - 18)) NOT NULL,
	Name CHAR(100) NOT NULL,
	Surname CHAR(100) NOT NULL,
	PassportData CHAR(100) NOT NULL,
);

CREATE TABLE Contract (
    IDContr INT IDENTITY(1,1) PRIMARY KEY,
    DATE INT CHECK (DATE <= YEAR(GETDATE())) NOT NULL,
    SalonName CHAR(100) NOT NULL,
    Place CHAR(100) NOT NULL,
    Price INT NOT NULL,
    finalPrice INT NOT NULL,
    SellerID INT NOT NULL,
	CustomerID INT NOT NULL,
	AutoVIN INT NOT NULL, 
    CONSTRAINT FK_Contract_Seller FOREIGN KEY (SellerID) REFERENCES Seller(ID)
	ON DELETE CASCADE,
	CONSTRAINT FK_Contract_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(PhoneNumber)
	ON DELETE CASCADE,
    CONSTRAINT FK_Contract_Auto FOREIGN KEY (AutoVIN) REFERENCES Auto(VIN)
	ON DELETE CASCADE
);
GO

CREATE VIEW CarContractView AS
SELECT C.IDContr, C.Place, C.finalPrice, A.VIN, A.Engine_type, A.Year_auto, A.FullName
FROM dbo.Contract C
JOIN dbo.Auto A ON C.AutoVIN = A.VIN;
GO

CREATE INDEX IX
ON Auto (Year_auto)
INCLUDE (Model);
GO



-- Создание функции для определения возраста автомобиля
CREATE FUNCTION dbo.GetCarAge(@Year_auto INT)
RETURNS INT
AS
BEGIN
    DECLARE @CurrentYear INT = YEAR(GETDATE());
    RETURN @CurrentYear - @Year_auto;
END;
GO

-- Создание процедуры TASK2
CREATE PROCEDURE ALLINFO
    @curs CURSOR VARYING OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SET @curs = CURSOR
    SCROLL STATIC FOR
        SELECT 
            c.IDContr, 
            c.DATE, 
            c.SalonName, 
            c.Place, 
            c.Price, 
            c.finalPrice, 
            s.Name AS SellerName, 
            s.Surname AS SellerSurname, 
            s.Job AS SellerJob, 
            cu.Name AS CustomerName, 
            cu.Surname AS CustomerSurname, 
            cu.PassportData AS CustomerPassport, 
            a.Mark, 
            a.Model, 
            dbo.GetCarAge(a.Year_auto) AS CarAge
        FROM Contract c
        JOIN Seller s ON c.SellerID = s.ID
        JOIN Customer cu ON c.CustomerID = cu.PhoneNumber
        JOIN Auto a ON c.AutoVIN = a.VIN;

    OPEN @curs;
END;
GO

IF OBJECT_ID(N'dbo.CUSTOMERINSTRIGGER', N'TR') IS NOT NULL
    DROP TRIGGER dbo.CUSTOMERINSTRIGGER;
GO
CREATE TRIGGER CUSTOMERINSTRIGGER
ON Customer
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE LEN(Name) > 20 OR LEN(Surname) > 20
    )
    BEGIN
        RAISERROR('Вставка данных с подобным ФИО запрещена.', 16, 1);
    END;
	ELSE
    BEGIN
        INSERT INTO Customer (PhoneNumber, Year_birth, Name, Surname, PassportData)
        SELECT PhoneNumber, Year_birth, Name, Surname, PassportData
        FROM inserted;
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
        WHERE Year_auto < 1900 OR LEN(Mark) > 15 OR LEN(Model) > 15
    )
    BEGIN
		RAISERROR('Обновление автомобилей с подобными данными запрещеною.', 16, 1);
    END;
	ELSE
	BEGIN
		UPDATE Auto
		SET Year_auto = i.Year_auto, Mark = i.Mark, Model = i.Model
		FROM Auto a
		JOIN inserted i ON a.VIN = i.VIN;
	END
END;
GO
-- ===========================================================================================================================================
-- Заполнение таблицы Auto
INSERT INTO Auto (Engine_type, Year_auto, Mark, Model, Price)
VALUES
('Petrol', 2020, 'Toyota', 'Camry', 25000),
('Diesel', 2019, 'Honda', 'Accord', 23000),
('Electric', 2017, 'Tesla', 'Accord', 17000),
('Electric', 2022, 'Tesla', 'Model 3', 45000);

DECLARE @VIN1 INT, @VIN2 INT, @VIN3 INT;
SET @VIN3 = SCOPE_IDENTITY(); 
SET @VIN2 = @VIN3 - 1;
SET @VIN1 = @VIN2 - 1;

-- Заполнение таблицы Seller
INSERT INTO Seller (Year_birth, Name, Surname, Job)
VALUES
(1980, 'John', 'Doe', 'Salesperson'),
(1975, 'Jane', 'Smith', 'Manager'),
(1985, 'Bob', 'Johnson', 'Consultant');

DECLARE @SellerID1 INT, @SellerID2 INT, @SellerID3 INT;
SET @SellerID3 = SCOPE_IDENTITY(); 
SET @SellerID2 = @SellerID3 - 1;
SET @SellerID1 = @SellerID2 - 1;

-- Заполнение таблицы Customer
INSERT INTO Customer (PhoneNumber, Year_birth, Name, Surname, PassportData)
VALUES
(12345678, 1990, 'Alice', 'Johnson', 'AB123456'),
(98765432, 1988, 'Michael', 'Brown', 'CD789012'),
(55566677, 1982, 'Alice', 'Williams', 'EF345678');

-- Заполнение таблицы Contract
INSERT INTO Contract (DATE, SalonName, Place, Price, finalPrice, SellerID, CustomerID, AutoVIN)
VALUES
(2022, 'AutoSales', 'City A', 25000, 24000, @SellerID1, 12345678, @VIN1),
(2020, 'CarWorld', 'City B', 23000, 22000, @SellerID2, 98765432, @VIN2),
(2018, 'GreenCars', 'City C', 45000, 44000, @SellerID3, 55566677, @VIN3);


UPDATE Auto SET Mark = 'TesSSSSSSSSSSSSSSSSSSSSSSSSSыыыыыыыыыыыыыыыыыыыыыыlaaaaaaaaaaaaaaaaaaaaaaaaaaa'
WHERE Mark = 'Tesla'

INSERT INTO Customer (PhoneNumber, Year_birth, Name, Surname, PassportData)
VALUES (12345678, 1990, 'AliceEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE', 'Johnson', 'AB123456');


SELECT * FROM Contract
SELECT VIN, FullName FROM Auto
SELECT * FROM Seller
SELECT * FROM Customer

DELETE FROM Auto
WHERE VIN = 123458;

SELECT DISTINCT Name FROM Customer;
GO

SELECT * FROM Seller WHERE Year_birth BETWEEN 1980 AND 1985 ORDER BY Year_birth ASC;
GO
SELECT
    C.IDContr AS ContractID,
    C.Place AS ContractPlace,
    C.finalPrice AS ContractFinalPrice,
    C.VIN AS AutoVIN,
    C.Engine_type AS AutoEngineType,
    C.Year_auto AS AutoYear,
    C.FullName AS AutoFullName
FROM
    CarContractView AS C
	

SELECT Auto.*, Contract.*
FROM Auto
INNER JOIN Contract ON Auto.VIN = Contract.AutoVIN;

SELECT Auto.*, Contract.*
FROM Auto
LEFT JOIN Contract ON Auto.VIN = Contract.AutoVIN;

SELECT Auto.*, Contract.*
FROM Auto
RIGHT JOIN Contract ON Auto.VIN = Contract.AutoVIN;

SELECT Auto.*, Contract.*
FROM Auto
FULL OUTER JOIN Contract ON Auto.VIN = Contract.AutoVIN;



SELECT * FROM Auto WHERE Mark IS NOT NULL;
SELECT * FROM Auto WHERE Mark LIKE 'Toy%';
SELECT * FROM Auto WHERE Mark IN ('Toyota', 'Fiat', 'Tesla');
SELECT *
FROM Auto AS a
WHERE EXISTS (
    SELECT 1
    FROM Contract AS c
    WHERE c.AutoVIN = a.VIN
);
SELECT COUNT(*) AS TotalCars
FROM Auto;

SELECT Mark, AVG(Price) AS AvgPrice
FROM Auto
GROUP BY Mark
HAVING AVG(Price) > (SELECT AVG(Price) FROM Auto);

SELECT MAX(Price) AS MaxPrice
FROM Auto;

SELECT MIN(Price) AS MinPrice
FROM Auto;

SELECT SUM(Price) AS TotalPrice
FROM Auto;


GO
SELECT ID, Year_birth, Name, Surname FROM Seller
UNION
SELECT PhoneNumber AS ID, Year_birth, Name, Surname FROM Customer;

SELECT ID, Year_birth, Name, Surname, Job FROM Seller
UNION ALL
SELECT PhoneNumber AS ID, Year_birth, Name, Surname, PassPortData AS Job FROM Customer;

-- Возвращает уникальные строки из первого результата, которые отсутствуют во втором результате.
SELECT ID, Year_birth, Name, Surname, Job FROM Seller
EXCEPT
SELECT PhoneNumber AS ID, Year_birth, Name, Surname, PassPortData AS Job FROM Customer;

SELECT ID, Year_birth, Name, Surname, Job FROM Seller
INTERSECT
SELECT PhoneNumber AS ID, Year_birth, Name, Surname, PassPortData AS Job FROM Customer;

GO



















-- Вызов процедуры
/*DECLARE @myCursor CURSOR;
EXEC ALLINFO @curs = @myCursor OUTPUT;
DECLARE @IDContr INT, 
        @DATE INT, 
        @SalonName CHAR(100), 
        @Place CHAR(100), 
        @Price INT, 
        @finalPrice INT,
        @SellerName CHAR(100), 
        @SellerSurname CHAR(100), 
        @SellerJob CHAR(100), 
        @CustomerName CHAR(100), 
        @CustomerSurname CHAR(100), 
        @CustomerPassport CHAR(100),
        @Mark CHAR(100), 
        @Model CHAR(100), 
        @CarAge INT;
FETCH NEXT FROM @myCursor INTO @IDContr, @DATE, @SalonName, @Place, @Price, @finalPrice, @SellerName, @SellerSurname, @SellerJob, @CustomerName, @CustomerSurname, @CustomerPassport, @Mark, @Model, @CarAge;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'IDContr: ' + CAST(@IDContr AS VARCHAR(10)) + ', DATE: ' + CAST(@DATE AS VARCHAR(10)) + ', SalonName: ' + @SalonName + ', Place: ' + @Place + ', Price: ' + CAST(@Price AS VARCHAR(10)) + ', finalPrice: ' + CAST(@finalPrice AS VARCHAR(10)) + ', SellerName: ' + @SellerName + ', SellerSurname: ' + @SellerSurname + ', SellerJob: ' + @SellerJob + ', CustomerName: ' + @CustomerName + ', CustomerSurname: ' + @CustomerSurname + ', CustomerPassport: ' + @CustomerPassport + ', Mark: ' + @Mark + ', Model: ' + @Model + ', CarAge: ' + CAST(@CarAge AS VARCHAR(10));
    FETCH NEXT FROM @myCursor INTO @IDContr, @DATE, @SalonName, @Place, @Price, @finalPrice, @SellerName, @SellerSurname, @SellerJob, @CustomerName, @CustomerSurname, @CustomerPassport, @Mark, @Model, @CarAge;
END

CLOSE @myCursor;
DEALLOCATE @myCursor;
*/
/*
UPDATE Auto
SET Mark = 'Dodge'
WHERE Mark = 'dodge';

DELETE FROM Auto
WHERE VIN = 123456;
*/
-- ==================================================================================================== 4

