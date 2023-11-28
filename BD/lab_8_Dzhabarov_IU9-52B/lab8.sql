USE LAB6;
GO

--Пункт 1
-- Проверка существования и удаление, если существует
IF OBJECT_ID(N'dbo.TASK1', N'P') IS NOT NULL
    DROP PROCEDURE dbo.TASK1;
GO
CREATE PROCEDURE TASK1
    @curs CURSOR VARYING OUTPUT
AS
    SET NOCOUNT ON;
    SET @curs = CURSOR
    SCROLL STATIC FOR               
        select Mark, Model  
        from Auto
    OPEN @curs
GO

--Проверка курсора
DECLARE @myCursor CURSOR;

EXEC TASK1 @curs = @myCursor OUTPUT;

DECLARE @Mark VARCHAR(255);
DECLARE @Model VARCHAR(255);

FETCH NEXT FROM @myCursor INTO @Mark, @Model;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Mark: ' + @Mark + ', Model: ' + @Model;

    FETCH NEXT FROM @myCursor INTO @Mark, @Model;
END

CLOSE @myCursor;
DEALLOCATE @myCursor;
GO




--Пункт 2
--Создание функции с проверкой
IF OBJECT_ID(N'dbo.GetCarAge', N'FN') IS NOT NULL
    DROP FUNCTION GetCarAge;
GO
CREATE FUNCTION GetCarAge(@year INT)
RETURNS INT
AS
BEGIN
    DECLARE @current_year INT;
    DECLARE @car_age INT;
    SET @current_year = YEAR(GETDATE());
    SET @car_age = @current_year - @year;
    RETURN @car_age;
END;
GO

-- Проверка существования и удаление, если существует
IF OBJECT_ID(N'dbo.TASK2', N'P') IS NOT NULL
    DROP PROCEDURE dbo.TASK2;
GO
CREATE PROCEDURE TASK2
    @curs CURSOR VARYING OUTPUT
AS
    SET NOCOUNT ON;
    SET @curs = CURSOR
    SCROLL STATIC FOR               
        SELECT Mark, Model, dbo.GetCarAge(Year_auto) AS CarAge
        FROM Auto
    OPEN @curs
GO

--Пункт 3
if OBJECT_ID(N'dbo.TASK3', N'P') is not null
    DROP PROCEDURE dbo.TASK3
GO
CREATE PROCEDURE dbo.TASK3
AS
    DECLARE @myCursor CURSOR;
	EXEC dbo.TASK2 @curs = @myCursor OUTPUT;

	DECLARE @Mark VARCHAR(255);
	DECLARE @Model VARCHAR(255);
	DECLARE @CarAge INT;
 
    FETCH NEXT FROM @myCursor INTO @Mark, @Model, @CarAge;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Mark: ' + @Mark + ', Model: ' + @Model + ', Car Age: ' + CONVERT(NVARCHAR(10), @CarAge);
		FETCH NEXT FROM @myCursor INTO @Mark, @Model, @CarAge;
	END
	CLOSE @myCursor;
	DEALLOCATE @myCursor;
GO

EXEC dbo.TASK3
GO

--Пункт 4
-- Создание табличной функции
IF OBJECT_ID(N'dbo.GetCarInfo', N'F') IS NOT NULL
    DROP FUNCTION dbo.GetCarInfo;
GO

CREATE FUNCTION dbo.GetCarInfo()
RETURNS TABLE
AS
RETURN
(
    SELECT Mark, Model, dbo.GetCarAge(Year_auto) AS CarAge
    FROM Auto
);
GO

IF OBJECT_ID(N'dbo.TASK4', N'P') IS NOT NULL
    DROP PROCEDURE dbo.TASK4;
GO
CREATE PROCEDURE dbo.TASK4
    @curs CURSOR VARYING OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @curs = CURSOR
    SCROLL STATIC FOR
        SELECT Mark, Model, CarAge
        FROM dbo.GetCarInfo();
    OPEN @curs;
END;
GO
