USE lab3;
CREATE TABLE Auto (
	VIN INT PRIMARY KEY NOT NULL,
	Engine_type CHAR(100) NOT NULL,
	Year_auto int NOT NULL,
	Mark CHAR(100) NOT NULL,
	Model CHAR(100) NOT NULL
);

INSERT INTO Auto(VIN, Engine_type, Year_auto, Mark, Model)
VALUES (1, 'petrol', 2020, 'dodge', 'ram')


INSERT INTO Auto(VIN, Engine_type, Year_auto, Mark, Model)
VALUES (2, 'diesel', 2020, 'ford', 'mustang')