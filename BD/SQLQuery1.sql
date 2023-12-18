USE LAB6;

set transaction isolation level 
    read committed
begin transaction
    select * from dbo.Auto3
    update dbo.Auto3 
        set Mark = 'BMW' 
        where ID = 2
    select * from dbo.Auto3
