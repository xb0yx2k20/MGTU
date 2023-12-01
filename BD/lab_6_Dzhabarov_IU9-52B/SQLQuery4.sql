use lab6



-- Создание таблицы Orders
CREATE TABLE Contract
(
    ContrID INT IDENTITY(1,1) PRIMARY KEY,
    Place NVARCHAR(50),
	Price INT
);

-- Вставка некоторых данных в таблицу Orders
INSERT INTO Contract (ContrID, Place, Price)
VALUES (101, 'moscow', 1),
       (102, 'berlin', 2);

CREATE TABLE Auto4 (
	VIN INT IDENTITY(123456,1) PRIMARY KEY,
	Engine_type CHAR(100) default 'petrol',
	Year_auto int check (Year_auto <= YEAR(GETDATE())) NOT NULL,
	Mark CHAR(100) NOT NULL,
	Model CHAR(100) NOT NULL,
	FullName AS Mark + Model,
	ContrID INT FOREIGN KEY REFERENCES Contract(ContrID) ON DELETE NO ACTION
);

INSERT INTO Auto4(Year_auto, Mark, Model)
VALUES (2014, 'bmw', 'x5')


-- Используем NO ACTION (по умолчанию)
DELETE FROM Contract WHERE Place = 'berlin';







select * from Contract
select * from Auto4
