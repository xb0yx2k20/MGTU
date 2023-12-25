USE MyDatabase;
GO

--1

/*
BEGIN TRANSACTION;
	UPDATE Auto SET Mark = 'chv' WHERE Mark = 'Chevrolet' AND VIN = 123460;
	WAITFOR DELAY '00:00:20';
	SELECT * FROM Auto;
	SELECT * FROM sys.dm_tran_locks;
COMMIT TRANSACTION;
GO
*/



--3

/*
BEGIN TRANSACTION;
	INSERT INTO Consignee(it_number, phone_number, address, bank_details, name)
	VALUES ('111111111111', '87777777777', 'Moscow', 'BANK404', 'Bob');
	SELECT * FROM sys.dm_tran_locks;
COMMIT TRANSACTION;
GO

--4
*/

BEGIN TRANSACTION;

	INSERT INTO Auto(Year_auto, Mark, Model)
	VALUES (1998, 'ford', 'mondeo');
	WAITFOR DELAY '00:00:20';
	SELECT * FROM sys.dm_tran_locks;
COMMIT TRANSACTION;
GO
