use hotel

go


--      Strod Procdure of Staff
create proc USP_GetListStaff
as
begin
	select *from Staff
end

GO

create proc USP_GetList_Staff_Service
as
begin
	select * from Account where id_type = 0
end

GO

create proc USP_GetProfile
@username varchar(50)
as
begin
	select * from Staff where username=@username
end

GO

create proc USP_EditStaff
@username varchar (50),
@displayname nvarchar(100),
@sex bit,
@birthday date,
@address nvarchar(200),
@phone varchar(11),
@email varchar(50),
@image nvarchar(1000)
as
begin
	update staff set displayname = @displayname, sex = @sex, birthday = @birthday, address = @address, phone = @phone, email = @email, image = @image where username = @username;
end

GO

create proc USP_GetRole
@username varchar(50)
as
begin
	select id_type from Account where username = @username;
end

GO

create proc USP_CheckUserName
@username varchar(50)
as
begin
	select count(*) from Staff where username = @username
end

GO

create proc USP_BanAccount
@username varchar(50)
as
begin
	update Staff set ban_account = 1 where username = @username
end
use hotel

go


--      Strod Procdure of Staff
create proc USP_GetListStaff
as
begin
	select *from Staff
end

GO

create proc USP_GetList_Staff_Service
as
begin
	select * from Account where id_type = 0
end

GO

create proc USP_GetProfile
@username varchar(50)
as
begin
	select * from Staff where username=@username
end

GO

create proc USP_EditStaff
@username varchar (50),
@displayname nvarchar(100),
@sex bit,
@birthday date,
@address nvarchar(200),
@phone varchar(11),
@email varchar(50),
@image nvarchar(1000)
as
begin
	update staff set displayname = @displayname, sex = @sex, birthday = @birthday, address = @address, phone = @phone, email = @email, image = @image where username = @username;
end

GO

create proc USP_GetRole
@username varchar(50)
as
begin
	select id_type from Account where username = @username;
end

GO

create proc USP_CheckUserName
@username varchar(50)
as
begin
	select count(*) from Staff where username = @username
end

GO

create proc USP_BanAccount
@username varchar(50)
as
begin
	update Account set ban_account = 1 where username = @username
end

select *from Account

exec USP_BanAccount dinhdinh

exec USP_GetRole dinhdinh

exec USP_EditStaff peterdinh018, dinhdinh, 1, '1997-1-1', 'Viet Nam', '019xxxx', 'abc@gmail.com', null

exec USP_GetListStaff




-- Stored procedure room

create proc USP_Get_ListRoom_Floor
@floor int
as
begin
	select * from Room join Kind_of_room on Room.id_kind_of_room = Kind_of_room.id where num_floor = @floor
end

create proc USP_GetMaxFloor
as
begin
	select max(num_floor) from Room
end

create proc USP_InsertRoom
@num_floor int ,
@num_order int ,
@id_kind_of_room int,
@staff varchar(50)
as
begin
	insert into Room values(@num_floor, @num_order, @id_kind_of_room, 'false', @staff)
end 

create proc USP_CheckExistsRoom
@num_floor int,
@num_order int
as
begin
	select count(*) from Room where num_floor = @num_floor and num_order = @num_order
end

create proc USP_DeleteRoom
@id_room int
as
begin
	delete from Room where id_room = @id_room
end

create proc USP_EditeRoom
@id_room int,
@id_type int,
@staff varchar(50)
as
begin
	update Room set  id_kind_of_room = @id_type , username = @staff where id_room  = @id_room
end

create proc USP_GetInfoRoom
@id_room int
as
begin
	select * from Room join Kind_of_room on Room.id_kind_of_room = Kind_of_room.id where id_room = @id_room
end

exec USP_GetInfoRoom 1

exec USP_DeleteRoom 43

exec USP_CheckExistsRoom 1,20


exec USP_InsertRoom 3, 7 , 11 , phuc


exec USP_GetMaxFloor
exec USP_Get_ListRoom_Floor @floor=3



--  strore procedure Kind_of_room

create proc USP_GetList_Kindofroom
as
begin
	select * from Kind_of_room
end


create proc USP_InsertKindofRoom
@name nvarchar(100),
@price money,
@people int
as
begin
	if(@price > 0 and @people > 0)
		begin
			insert into Kind_of_room values(@name, @price, @people)
		end
end

create proc USP_UpdateKindofRoom
@id int ,
@name nvarchar(100),
@price money,
@people int
as
begin
	if(@price > 0 and @people > 0)
		begin
			update Kind_of_room set name = @name, price = @price, people = @people where id=@id
		end
end

create proc USP_DelKindofRoom
@id int
as
begin
	delete from Kind_of_room where id = @id
end

exec USP_DelKindofRoom 13

exec USP_UpdateKindofRoom 13, test2, 2,3

exec USP_InsertKindofRoom test, 123, 1

exec USP_GetList_Kindofroom



-- Stored Procedure Calendar 
 
create proc USP_GetListCalendar 
as 
begin 
  select * from Calendar join Reservation on Calendar.id_reservation = Reservation.id_reservation 
end 
 
 
exec USP_GetListCalendar 
 
 
create proc USP_GetInfoCalendar 
@id_calendar int  
as 
begin 
  select * from Calendar join Reservation on Calendar.id_reservation = Reservation.id_reservation where id_calendar = @id_calendar  
end 
 
 
exec USP_GetInfoCalendar @id_calendar = 1 
 
create proc USP_DelCalendar 
@id_calendar int 
as 
begin 
  delete from Calendar where id_calendar = @id_calendar 
end 
 
 
create proc USP_InsertCalendar 
@id_reservation int, 
@date_start date, 
@date_end date, 
@created date 
as 
begin 
  if(exists(select @id_reservation = id_reservation from Reservation where id_reservation = @id_reservation)) 
  begin 
    if(@date_end > @date_start) 
    begin 
      insert into Calendar values(@id_reservation, @date_start, @date_end, @created) 
    end 
  end 
end 
 
 
exec USP_InsertCalendar 
 
create proc USP_EditCalendar 
@id_calendar int, 
@id_reservation int, 
@date_start date, 
@date_end date, 
@created date 
as 
begin 
  if(exists(select @id_calendar = id_calendar from Calendar where id_calendar = @id_calendar)) 
  begin 
    if(exists(select @id_reservation = id_reservation from Reservation where id_reservation = @id_reservation)) 
-
    begin 
      if(@date_start  < @date_end) 
      update Calendar set id_reservation = @id_reservation, date_start = @date_start 
    end 
  end 
end 
 

select * from service_ticket
-- stored proc  service_ticket


create proc USP_InsertServiceTikcket
@id_reservation int ,
@id_room int,
@id_service int,
@number int,
@date_use date
as 
BEGIN
	if(exists(select * from Reservation where @id_reservation = @id_reservation and status_reservation = 1))
	BEGIN
		if(exists(select * from Room where id_room = @id_room and room.logged = 1))
		BEGIN
			if(exists(select * from Service where id_service = @id_service))
			BEGIN
				if(exists(select * from service_ticket where id_service = @id_service and id_reservation = @id_reservation and id_room = @id_room))
				BEGIN
					DECLARE @number_present int 
					select @number_present = number from service_ticket where id_service = @id_service and id_reservation = @id_reservation and id_room = @id_room
					DECLARE @number_tran int
					set @number_tran = @number_present + @number
					if(@number_tran > 0)
					BEGIN
						update service_ticket set number = @number_tran where id_service = @id_service and id_reservation = @id_reservation and id_room = @id_room
					END
					ELSE
					BEGIN
						delete service_ticket where  id_service = @id_service and id_reservation = @id_reservation and id_room = @id_room
					END
				END
				ELSE
				BEGIN
					INSERT into service_ticket VALUES (@id_reservation, @id_room,  @id_service, @number, @date_use)
				END
			END
		END
	END
end




CREATE PROC USP_Get_ListServiceTicket
AS
BEGIN
	SELECT * from ((service_ticket as a JOIN reservation as b on a.id_reservation = b.id_reservation) join service as c on a.id_service = c.id_service) join Room as d on a.id_room = d.id_room
END


-- Stored Procedure Stuff_detail

create proc USP_InsertStuff_Detail
@id_stuff int ,
@id_kind_of_room int,
@number INT
as
BEGIN
	if(exists(select * from Stuff where id_stuff = @id_stuff))
	BEGIN
		if(exists(select * from Kind_of_room where id = @id_kind_of_room))
		BEGIN
			if(exists(select * from Stuff_detail where id_stuff = @id_stuff and id_kind_of_room = @id_kind_of_room))
			BEGIN
				DECLARE @number_persent INT
				select @number_persent = number from Stuff_detail where id_stuff = @id_stuff and id_kind_of_room = @id_kind_of_room
				DECLARE @number_tran int
				set @number_tran = @number_persent - @number
				if(@number_tran > 0)
				BEGIN
					update Stuff_detail SET number = @number_tran where id_stuff = @id_stuff and id_kind_of_room = @id_kind_of_room
				END
				ELSE
				BEGIN 
					delete from Stuff_detail WHERE id_stuff = @id_stuff and id_kind_of_room = @id_kind_of_room
				END
			END
			ELSE
			BEGIN
				insert into Stuff_detail values(@id_stuff, @id_kind_of_room, @number)
			END
		END
	END
end


create proc Get_ListStuffDetail
AS
BEGIN
	SELECT * from (Stuff_detail as a JOIN Stuff as b on a.id_stuff = b.id_stuff) on Kind_of_room as c on a.id_kind_of_room = c.id 
END


-- Stored Procedure Insert Data

select * from sys.Tables
select * from Stuff_detail