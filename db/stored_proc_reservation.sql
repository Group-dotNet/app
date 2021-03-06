﻿use hotel

go

create proc USP_GetListReservation
as 
begin
	select * from Reservation as a join Customer as b on a.id_customer = b.id_customer order by id_reservation desc
end	

go 

--exec USP_GetInfoReservation 11
create proc USP_GetInfoReservation
@id_reservation int
as
begin
	select * from (Reservation as a join Customer as b on a.id_customer = b.id_customer) join Staff as c on a.username = c.username where id_reservation = @id_reservation
end

--exec USP_GetInfoReservation @id_reservation= 1

go

--exec USP_InsertReservation 1, 0, 2, 'phuc', '2017-11-30'
--drop PROC USP_InsertReservation
create PROC USP_InsertReservation
@id_customer int,
@is_group bit,
@people int,
@username VARCHAR(50),
@end_date datetime
AS
BEGIN
	Declare @start_date datetime
	set @start_date = GETDATE()
	if(@end_date > @start_date)
	begin
		Declare @status_reservation int
		Declare @locked bit
		set @status_reservation = 3
		set @locked = 0
		Declare @note NVARCHAR(1000)
		set @note = convert(varchar(20),getdate(),120) + ': Insert Reservation is system'
		print (@note)
		INSERT into Reservation VALUES(@id_customer, @status_reservation, @is_group, @people, @username, @locked, @note)
		DECLARE @id_reservation INT
		select @id_reservation = @@IDENTITY

		Declare @created  datetime
		Declare @status int
		set @created = GETDATE()
		set @status = 1

		INSERT into Calendar VALUES (@id_reservation, @start_date, @end_date, @created, @status )
		return @id_reservation
	END
	else
	begin
		rollback
	end
	return @id_reservation
END

go

--exec USP_CancelReservation 14
create PROC USP_CancelReservation
@id_reservation INT
as
BEGIN
	if(exists (select * from Reservation where id_reservation = @id_reservation and locked = 0))
	begin
	DECLARE @note NVARCHAR(1000)
	DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
	SELECT @note = note FROM Reservation WHERE id_reservation = @id_reservation
	set @note = @note + @NewLineChar + convert(varchar(20),getdate(),120) + ': Cancel reservation'
	Update Reservation set status_reservation = 0, locked = 1 , note = @note where id_reservation = @id_reservation
	update Calendar set status = 0  where id_reservation = @id_reservation;
	update Reservation_room set using = 0 where id_reservation = @id_reservation
	update Room set locked = 0 where id_room in (select id_room from Reservation_room where id_reservation = @id_reservation)
	end
	else
	begin
		rollback
	end
END




go


create proc USP_SearchReservation
@id_type int,
@keyword nvarchar(1000)

as
begin
	if(@id_type = 0)
	begin
		select * from Reservation as a join Customer as b on a.id_customer = b.id_customer where id_reservation like '%' + @keyword + '%' order by a.id_reservation desc
	end
	if(@id_type  = 1)
	begin
		set @keyword = cast(@keyword as int)
		declare @floor int
		declare @order int
		set @floor = @keyword / 100
		set @order = @keyword % 100
		select * from (Reservation as a join Reservation_room as b on a.id_reservation = b.id_reservation) join Room as c on b.id_room = c.id_room where c.num_floor = @floor and c.num_order = @order order by a.id_reservation desc
	end
	if(@id_type = 2)
	begin
		select * from Reservation as a join Customer as b on a.id_customer = b.id_customer where b.name like '%' + @keyword + '%' order by a.id_reservation desc
	end
	if(@id_type = 3)
	begin
		select * from (Reservation as a join Staff as b on a.username = b.username) join Customer as c on a.id_customer = c.id_customer where b.username like '%' + @keyword + '%' or b.displayname like '%' + @keyword + '%' order by a.id_reservation desc
	end
	if(@id_type = 4)
	begin
		select  * from (Reservation as a join Calendar as b on a.id_reservation = b.id_reservation) join Customer as c on a.id_customer = c.id_customer where b.start_date like '%' + @keyword + '%' order by a.id_reservation desc
	end
	if(@id_type = 5)
	begin
		select distinct * from (Reservation as a join Calendar as b on a.id_reservation = b.id_reservation) join Customer as c on a.id_customer = c.id_customer  where b.end_date like '%' + @keyword + '%' order by a.id_reservation desc
	end
end

go


create proc USP_FilterReservation
@type int
as
begin
	if(@type = 0)
	begin
		select * from Reservation as a join Customer as b on a.id_customer = b.id_customer where a.status_reservation = 1 order by id_reservation desc
	end
	else
	begin
		if(@type = 1)
		begin
			select * from Reservation as a join Customer as b on a.id_customer = b.id_customer where a.status_reservation = 2 order by id_reservation desc
		end
		else
		begin
			if(@type = 2)
			begin
				select * from Reservation as a join Customer as b on a.id_customer = b.id_customer where a.status_reservation = 3 order by id_reservation desc
			end
			else
			begin
				if(@type = 3)
				begin
					select * from Reservation as a join Customer as b on a.id_customer = b.id_customer where a.status_reservation = 0 order by id_reservation desc
				end
				else
				begin
					select * from Reservation as a join Customer as b on a.id_customer = b.id_customer order by id_reservation desc
				end
			end
		end
	end
end
go

create proc USP_CheckConfirmBillByReservation
@id_reservation int
as
begin
	declare @return int
	if(exists(select * from Bill where id_bill = @id_reservation and confirm = 1))
	begin
		set @return = 1
	end
	else
	begin
		set @return = 0
	end
	return @return
end



--select * from Reservation
--select * from Calendar
--SELECT * from Reservation_room
--SELECT * from Room
--SELECT GETDATE()

--SELECT * from sys.tables
--exec USP_GetListReservation