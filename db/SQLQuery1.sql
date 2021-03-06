-- drop database hotel

create database hotel

go

use hotel

go

create table Account (
	id_account int identity(1,1) primary key,
	username varchar(50) unique,
	password varchar(125) not null,
	id_type int,
	ban_account bit default '0',
)

go

create table Staff(
	username varchar(50) primary key,
	displayname nvarchar(100),
	sex bit,
	birthday date,
	address nvarchar(200),
	phone varchar(11),
	email varchar(50) unique,
	image image,
)

go

create table Customer(
	id_customer int identity(1,1) primary key,
	name nvarchar (100),
	sex bit,
	identity_card varchar(20) not null unique,
	address nvarchar(200),
	email varchar(80) unique,
	phone varchar(11) not null,
	company nvarchar(50),
	id_history int not null default '0'
)


go

create table Kind_of_room(
	id int identity(1,1) primary key,
	name nvarchar(50),
	price money not null,
	people int not null
)

go

create table Room(
	id_room int identity(1,1) primary key,
	num_floor int not null,
	num_order int not null,
	id_kind_of_room int not null,
	locked bit not null default '0',
	username varchar(50) not null,
)

go


create table Service(
	id_service int identity(1,1) primary key,
	name_service nvarchar(200),
	price money,
	unit varchar(20),
	locked bit
)

go

create table Stuff(
	id_stuff int identity(1,1) primary key,
	name_stuff nvarchar(200),
	locked bit
)

go

create table Stuff_detail(
	id_stuff int,
	id_kind_of_room int,
	number int,
	primary key (id_stuff, id_kind_of_room)
)

go

create table Service_ticket(
	id_reservation_room int not null,
	id_service int not null,
	number int,
	date_use datetime,
	primary key (id_reservation_room, id_service, date_use)
)

go

create table Reservation(
	id_reservation int identity(1,1) primary key,
	id_customer int not null,
	status_reservation int not null default '2',
	is_group bit not null default 'false',
	people int not null,
	username varchar(50) not null,
	locked bit not null,
	note nvarchar(1000)
)

go

create table Deposit(
	id_deposit int identity(1,1) primary key,
	id_reservation int not null,
	deposit money not null,
	confirm bit not null default '0',
	created_confirm datetime null,
	locked bit default '0',
	note nvarchar(100)
)

go

create table Calendar(
	id_calendar int identity(1,1) primary key,
    id_reservation int not null,
	start_date datetime not null,
	end_date datetime,
	created datetime not null,
	status int not null
)

go


create table Reservation_room(
	id_reservation_room int identity primary key,
	id_reservation int not null,
	id_room int not null,
	using int not null default '1',
)

go


create table Bill (
	id_bill int identity(1,1) primary key,
	created datetime,
	total_money money not null,
	id_reservation int not null,
	username varchar(50) not null,
	confirm bit not null default 'false',
	note nvarchar(1000)
)

go

create table Log_swap_room(
	id_log int identity(1,1) primary key,
	id_reservation_room int not null,
	id_room_new int not null,
	select_record bit not null,
	created datetime not null
)

go

create table Message_system(
	id_message int identity(1,1) primary key,
	id_reservation int unique,
	content nvarchar (1000),
	created datetime,
	checked bit default '0'
)

go


create table History_in_system(
	id_history int identity(1,1) primary key,
	username nvarchar(50) not null,
	content nvarchar(1000),
	created datetime,
)

go

-- Script foreign key database

alter table  Room
add constraint fk_room_kind_of_room
foreign key (id_kind_of_room)
references Kind_of_room(id)

go

alter table Stuff_detail
add constraint fk_stuff_detail_stuff
foreign key (id_stuff)
references Stuff(id_stuff)

go

alter table Stuff_detail
add constraint fk_stuff_detail_kind_of_room
foreign key (id_kind_of_room)
references Kind_of_room(id)


go

alter table Deposit
add constraint fk_deposit_reservation
foreign key (id_reservation)
references Reservation (id_reservation)

go

alter table Service_ticket
add constraint fk_service_ticket_service
foreign key (id_service)
references Service(id_service)

go

alter table Service_ticket
add constraint fk_service_ticket_severvation_room
foreign key (id_reservation_room)
references Reservation_room(id_reservation_room)

go


alter table Reservation
add constraint fk_reservation_customer
foreign key (id_customer)
references Customer(id_customer)

go

alter table Reservation
add constraint fk_reservation_staff
foreign key (username)
references Staff(username)



go


alter table Reservation_room
add constraint fk_reservation_room_reservation
foreign key (id_reservation)
references Reservation(id_reservation)

go

alter table Reservation_room
add constraint fk_reservation_room_room
foreign key (id_room)
references Room(id_room)

go

alter table Bill
add constraint fk_bill_staff
foreign key (username)
references Staff(username)

go

alter table Bill
add constraint fk_bill_reservation
foreign key (id_reservation)
references Reservation(id_reservation)


go

alter table Log_swap_room 
add constraint fk_log_swap_room_reservation_room
foreign key (id_reservation_room)
references Reservation_room(id_reservation_room)

go

alter table Staff 
add constraint fk_staff_account
foreign key (username)
references Account(username)

go

alter table Calendar
add constraint fk_calendar_reservation
foreign key (id_reservation)
references Reservation(id_reservation)


-- End script foreign key database


go

-- function stored procedure  demo
create proc USP_GetAccount
@username varchar(50)
as
begin
	select * from Account where username=@username
end

GO

create proc USP_CountAccount
@id_type int
as
begin
	select count(*) from Account where id_type=@id_type
end

GO

create proc USP_InsertAccount
@username varchar(50),
@password varchar(50),
@id_type int
as
begin
	insert into dbo.Account(username, password, id_type, ban_account) values (
	@username, 
	@password, 
	@id_type, 
	0
	)
end

GO

create proc USP_CheckLogin
@username varchar(50),
@password varchar(125)
as
begin
	select * from Account where username = @username and password = @password and ban_account = 0;
end


GO

create proc USP_Change_password
@username varchar(50),
@password_new varchar(50)
as
begin
	update Account set password=@password_new where username=@username
end

go

create proc USP_CheckExistsAccount
as
begin
	if(not exists(select *from Account))
		return 1
	else
		return 0
end

go

create proc USP_ChangeRole
@username varchar(50),
@role int
as
begin
	update Account set id_type = @role where username = @username and Account.id_account != 1
end


GO
-- end stored procedure 

-- exec USP_CheckLogin @username='peterdinh', @password='4297f44b13955235245b2497399d7a93'

-- exec dbo.USP_InsertAccount @username=dinhdinh11, @password="4297f44b13955235245b2497399d7a93", @id_type=1

-- exec dbo.USP_GetAccount @username=peterdinh

-- exec dbo.USP_CountAccount @id_type=1

-- exec USP_GetProfile @username=dinhdinh


-- test strigger

-- create trigger setup_service
-- on Service
-- for insert
-- as
-- if((select name_service from Service) in ('com') )
-- begin
-- print 'name_service not insert'
-- Rollback tran
-- end

-- drop trigger setup_service

-- insert into Service (name_service, price, unit) values('com', '234','vnd');

-- create trigger setup_date
-- on Calendar
-- for insert
-- as
-- if ((select created from Calendar) < getdate())
-- begin
-- print 'not insert'
-- rollback tran
-- end


-- drop trigger setup_date
-- insert into Calendar (start_date, end_date, created) values ('2017-09-09', '2017-09-10', '2017-12-12') 
-- delete Calendar where id_calendar=5


-- create trigger delete_date
-- on Calendar
-- for delete
-- as
-- if((select count(*) from deleted) > 2)
-- begin
-- print 'khong xoa dc'
-- rollback tran
-- end

-- drop trigger delete_date
-- delete Calendar where id_calendar!= 1


go

create proc Udpate_Message
as
begin 
	update Message_system set checked = 1
end 
go

create proc GetNotifire
as
begin
	select count(*) from Message_system where checked = 0
end
go



create proc Check_Reservation
as
begin
	if exists(select * from Message_system where id_reservation in( select a.id_reservation from Reservation as a join Calendar as b on a.id_reservation = b.id_reservation where status_reservation = 2 and b.status = 1 and DATEADD(minute, -30, b.end_date) < GetDate() and b.end_date > GETDATE()) )
	begin
		return 0
	end
	else
	begin
		insert into Message_system
		select a.id_reservation, CONCAT('Reservation ', a.id_reservation, ': running out of time'), GETDATE(), '0'  from Reservation as a join Calendar as b on a.id_reservation = b.id_reservation where a.status_reservation = 2 and b.status = 1 and DATEADD(minute, -30, b.end_date) < GetDate() and b.end_date > GETDATE()
		return 1
	end
end

-- exec Check_Reservation

go

create proc GetListMessageByDay
@date date
as
begin
	select * from Message_system where Day(@date) = Day(created) and MONTH(@date) = MONTH(created) and YEAR(@date) = YEAR(created) order by id_message desc
end

go

create proc Insert_History_System
@username nvarchar(50),
@content nvarchar(1000)
as 
begin
	insert into History_in_system values(@username, @content, GETDATE())
end

go

create proc GetListHistoryByDay
@date date
as
begin
	select * from History_in_system where Day(@date) = Day(created) and MONTH(@date) = MONTH(created) and YEAR(@date) = YEAR(created) order by id_history desc
end