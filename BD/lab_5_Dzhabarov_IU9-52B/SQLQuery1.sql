CREATE DATABASE lab3
ON
( NAME = MyDataFile,  FILENAME = 'C:\lab1\MyDataFile1.mdf', SIZE = 10MB, MAXSIZE = UNLIMITED, FILEGROWTH = 5MB )
LOG ON
( NAME = MyLogFile,  FILENAME = 'C:\lab1\MyLogFile1.ldf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 5MB );