use lab6
CREATE TABLE Auto2 (
	ID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	Engine_type CHAR(100) default 'petrol',
	Year_auto int check (Year_auto <= YEAR(GETDATE())) NOT NULL,
	Mark CHAR(100) NOT NULL,
	Model CHAR(100) NOT NULL,
	FullName AS Mark + Model
);

INSERT INTO Auto2(Year_auto, Mark, Model)
VALUES (2014, 'mitsubishi', 'asx')

INSERT INTO Auto2(Engine_type, Year_auto, Mark, Model)
VALUES ('diesel', 1998, 'mitsubishi', 'pajero')

select * from auto2
