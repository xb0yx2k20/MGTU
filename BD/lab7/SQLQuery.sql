-- Создание представления на основе таблицы Auto4
USE lab6;
GO
CREATE VIEW Auto4View
AS
SELECT VIN, Engine_type, Year_auto, Mark, Model, FullName, ContrID
FROM Auto4;



GO


-- Создание индексированного представления
CREATE VIEW IndexedContractAndAuto4View
WITH SCHEMABINDING
AS
SELECT C.ContrID, C.Place, C.Price, A.VIN, A.Engine_type, A.Year_auto, A.Mark, A.Model, A.FullName
FROM dbo.Contract C
JOIN dbo.Auto4 A ON C.ContrID = A.ContrID;
GO
-- Создание уникального кластеризованного индекса для индексированного представления
CREATE UNIQUE CLUSTERED INDEX IX_IndexedContractAndAuto4View
ON IndexedContractAndAuto4View (ContrID, VIN);
