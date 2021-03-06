USE hotel

go 


create PROC USP_GetListService
as
BEGIN
    SELECT * from service where locked = 0 order by id_service desc
end

go

create proc USP_GetListServiceLock
as
begin
	SELECT * from service where locked = 1 order by id_service desc
end
GO

create proc USP_GetInfoService
@id_service INT
AS
BEGIN
    select * from Service where id_service = @id_service
END


go
--drop proc USP_InsertService
create PROC USP_InsertService
@name_service NVARCHAR(100),
@price money,
@unit varchar(20)
AS
BEGIN
    INSERT into Service VALUES(@name_service , @price, @unit, 0)
END

GO

-- drop proc USP_EditService
CREATE PROC USP_EditService
@id_service int,
@name_service NVARCHAR(100),
@price money,
@unit varchar(20)
AS
BEGIN
    update Service SET name_service = @name_service , price = @price , unit = @unit WHERE id_service = @id_service
END

GO

CREATE PROC USP_LockService
@id_service INT
AS
BEGIN
    update Service set locked = 1 where id_service = @id_service
END

go

create proc USP_DelService
@id_service int
as
begin
	delete from Service where id_service = @id_service
end

GO

CREATE PROC USP_SearchService
@keyword NVARCHAR(200),
@type INT
as
BEGIN
    if(@type = 0) select * from Service WHERE  id_service like '%' + @keyword + '%' or  name_service like '%' + @keyword + '%' or price like '%' + @keyword + '%' or unit like '%' + @keyword + '%'
    if(@type = 1) SELECT * from Service WHERE id_service like '%' + @keyword + '%'
    if(@type = 2) SELECT * from Service WHERE name_service like '%' + @keyword + '%'
    if(@type = 3) SELECT * from Service WHERE price like '%' + @keyword + '%'
    if(@type = 4) SELECT * from Service WHERE unit like '%' + @keyword + '%'
end
