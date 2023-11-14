use lab6

CREATE SEQUENCE MySequenceName
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    CACHE 1

CREATE TABLE Auto3 (
	ID INT PRIMARY KEY DEFAULT NEXT VALUE FOR MySequenceName,
	Engine_type CHAR(100) default 'petrol',
	Year_auto int check (Year_auto <= YEAR(GETDATE())) NOT NULL,
	Mark CHAR(100) NOT NULL,
	Model CHAR(100) NOT NULL,
	FullName AS Mark + Model
);


INSERT INTO Auto3(Year_auto, Mark, Model)
VALUES (2014, 'bmw', 'x5')

INSERT INTO Auto3(Engine_type, Year_auto, Mark, Model)
VALUES ('diesel', 2012, 'audi', 'a7')

select * from auto3
