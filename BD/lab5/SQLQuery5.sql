USE lab3;
CREATE TABLE Auto2 (
	VIN INT PRIMARY KEY NOT NULL,
	Engine_type CHAR(100) NOT NULL,
	Year_auto int NOT NULL,
	Mark CHAR(100) NOT NULL,
	Model CHAR(100) NOT NULL,
);

INSERT INTO Auto2(VIN, Engine_type, Year_auto, Mark, Model)
VALUES (33, 'petrol', 2020, 'dodge', 'ram')
