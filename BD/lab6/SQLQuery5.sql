use lab6

-- ������� �������� ������ ������������ ������ (������ ���� ���������)
DELETE FROM Auto4 WHERE ContrID = 1;

-- ������� ���������� AuthorID � Auto4 (������ ���� ���������)
UPDATE Contract SET ContrID = 5555 WHERE ContrID = 1;

-- ������� ���������� AuthorID � Contract (������ ���� ���������)
UPDATE Auto4 SET ContrID = 2 WHERE VIN = 123456;

-- �������� ����� (������ �������� � �������� ���������� ������)
DELETE FROM Auto4 WHERE VIN = 123456;



select * from Contract
select * from Auto4
