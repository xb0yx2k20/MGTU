CREATE DATABASE LAB6
GO
-- Создание таблицы с автоинкрементным первичным ключом
USE LAB6
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


/*select VIN FROM Auto
SELECT @@IDENTITY AS GeneratedID;
SELECT SCOPE_IDENTITY() AS GeneratedID;
SELECT IDENT_CURRENT('Auto') AS GeneratedID;*/

select * from Auto
