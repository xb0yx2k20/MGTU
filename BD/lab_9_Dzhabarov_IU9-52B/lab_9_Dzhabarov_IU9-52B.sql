USE lab6;

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


----------------------------------------------------------- 2
-- Добавление
IF OBJECT_ID(N'dbo.TRIGGER11', N'TR') IS NOT NULL
    DROP TRIGGER dbo.TRIGGER11;
GO

CREATE TRIGGER TRIGGER11
ON Auto4View
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Auto4 (Engine_type, Year_auto, Mark, Model, ContrID)
    SELECT Engine_type, Year_auto, Mark, Model, ContrID
    FROM inserted;
END;
GO


-- Удаление
IF OBJECT_ID(N'dbo.TRIGGER22', N'TR') IS NOT NULL
    DROP TRIGGER dbo.TRIGGER22;
GO

CREATE TRIGGER TRIGGER22
ON Auto4View
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM Auto4
    WHERE ContrID IN (SELECT ContrID FROM deleted);
END;
GO

-- Обновление
IF OBJECT_ID(N'dbo.TRIGGER33', N'TR') IS NOT NULL
    DROP TRIGGER dbo.TRIGGER33;
GO

CREATE TRIGGER TRIGGER33
ON Auto4View
INSTEAD OF UPDATE
AS
BEGIN
    UPDATE A
    SET A.Engine_type = i.Engine_type,
        A.Year_auto = i.Year_auto,
        A.Mark = i.Mark,
        A.Model = i.Model,
        A.ContrID = i.ContrID
    FROM Auto4 A
    INNER JOIN inserted i ON A.VIN = i.VIN;
END;
GO



INSERT INTO Auto4View (Engine_type, Year_auto, Mark, Model, ContrID)
VALUES ('Gas', 2022, 'Toyota', 'Corolla', 1);
GO
SELECT * FROM Auto4
GO
DELETE FROM Auto4View
WHERE Model = 'Corolla';
GO
SELECT * FROM Auto4
GO
UPDATE Auto4View
SET Year_auto = 2000
WHERE VIN = 123457;
GO
SELECT * FROM Auto4