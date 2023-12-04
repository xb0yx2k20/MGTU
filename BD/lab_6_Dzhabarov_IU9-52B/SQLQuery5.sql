use lab6

-- Попытка удаления автора существующей книгой (должно быть запрещено)
DELETE FROM Auto4 WHERE ContrID = 1;

-- Попытка обновления AuthorID в Auto4 (должно быть запрещено)
UPDATE Contract SET ContrID = 5555 WHERE ContrID = 1;

-- Попытка обновления AuthorID в Contract (должно быть разрешено)
UPDATE Auto4 SET ContrID = 2 WHERE VIN = 123456;

-- Удаление книги (должно привести к удалению связанного автора)
DELETE FROM Auto4 WHERE VIN = 123456;



select * from Contract
select * from Auto4
