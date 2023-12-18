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
-- �������
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
        RAISERROR('������� ������ � �������� ��������� ���������� ���������.', 16, 1);
    END;
END;
GO

-- ��������
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
        PRINT '������ ������� ������� �� �������.';
    END;
END;
GO

-- ����������
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
		RAISERROR('���������� ����������� � ����� ������� ����� 1900 ���������.', 16, 1);
        --THROW 51000, '���������� ����������� � ����� ������� ����� 1900 ���������.', 1;
    END;
END;

GO
INSERT INTO Auto(Year_auto, Mark, Model)
VALUES (2023, 'dodge������������������������', 'ram')
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
-- ����������


IF OBJECT_ID(N'dbo.TRIGGER11', N'TR') IS NOT NULL
    DROP TRIGGER dbo.TRIGGER11;
GO

CREATE TRIGGER TRIGGER11
ON ViewCustContr
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @Place VARCHAR(255);
    DECLARE @Price DECIMAL(18, 2);
    DECLARE @Year_birth INT;
    DECLARE @NAME NVARCHAR(255);
    DECLARE @SURNAME NVARCHAR(255);

    -- �������� ������� ��� ������ ����������� �����
    DECLARE cursor_inserted CURSOR FOR
    SELECT Place, Price, Year_birth, NAME, SURNAME
    FROM inserted;

    OPEN cursor_inserted;

    -- ������������� ����������
    FETCH NEXT FROM cursor_inserted INTO @Place, @Price, @Year_birth, @NAME, @SURNAME;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- ������� ������ � Contract
        INSERT INTO Contract (Place, Price)
        VALUES (@Place, @Price);

        -- ������� ������ � CUSTOMERS � �������������� SCOPE_IDENTITY() ��� ��������� ���������� �������� ContrID
        INSERT INTO CUSTOMERS (Year_birth, NAME, SURNAME, ContrID)
        VALUES (@Year_birth, @NAME, @SURNAME, SCOPE_IDENTITY());

        FETCH NEXT FROM cursor_inserted INTO @Place, @Price, @Year_birth, @NAME, @SURNAME;
    END;

    CLOSE cursor_inserted;
    DEALLOCATE cursor_inserted;
END;
GO



-- ��������
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

-- ����������
IF OBJECT_ID(N'dbo.TRIGGER33', N'TR') IS NOT NULL
    DROP TRIGGER dbo.TRIGGER33;
GO

CREATE TRIGGER TRIGGER33
ON ViewCustContr
INSTEAD OF UPDATE
AS
BEGIN
	IF UPDATE(ContrID)
        BEGIN
            RAISERROR('Stop.', 16, 1);
        END
    UPDATE Contract
    SET Place = i.Place, Price = i.Price
    FROM Contract c
    INNER JOIN inserted i ON c.ContrID = i.ContrID;

    UPDATE CUSTOMERS
    SET Year_birth = i.Year_birth, NAME = i.NAME, SURNAME = i.SURNAME
    FROM CUSTOMERS cu
    INNER JOIN inserted i ON cu.ContrID = i.ContrID;
END;
GO



INSERT INTO ViewCustContr (Place, Price, Year_birth, Name, Surname)
VALUES ('������', 123212321, 3020, 'QWE', 'musa'),
		('qwer', 222, 2030, 'edc', 'aser');
GO


DELETE FROM ViewCustContr
WHERE ContrID = 36;
GO

UPDATE ViewCustContr
SET Name = 'chinese'
WHERE ContrID = 35;
UPDATE ViewCustContr
SET Price = 987654
WHERE ContrID = 35;
UPDATE ViewCustContr
SET Year_birth = 1800
WHERE ContrID = 35;
UPDATE ViewCustContr
SET ContrID = 40
WHERE ContrID = 41;
GO


SELECT * FROM CUSTOMERS
SELECT * FROM Contract
GO