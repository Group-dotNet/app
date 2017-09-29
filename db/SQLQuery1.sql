/****** Script for SelectTopNRows command from SSMS  ******/
use app

create table Account (
	id_account int identity(1,1) primary key,
	username varchar(50) unique,
	password varchar(125) not null,
	id_type int,
)


create table Staff(
	username varchar(50) primary key,
	displayname nvarchar(100),
	sex bit,
	birthday date,
	address nvarchar(200),
	phone varchar(11),
	email varchar(50) unique,
	image binary(100),
)


create table Customer(
	id_customer int identity(1,1) primary key,
	name nvarchar (100),
	sex bit,
	identity_card varchar(20) not null,
	address nvarchar(200),
	email varchar(80) not null unique,
	phone varchar(11) not null,
	company nvarchar(50)
)

create table Kind_of_room(
	id int identity(1,1) primary key,
	name nvarchar(50),
	price money not null,
	people int not null
)

create table Room(
	id_room int identity(1,1) primary key,
	num_floor int not null,
	num_order int not null,
	id_kind_of_room int not null,
	id_status not null,
	logged bit not null
)


alter table  Room
add constraint fk_room_kind_of_room
foreign key (id_kind_of_room)
references Kind_of_room(id)

create table Service(
	id_service int identity(1,1) primary key,
	name_service nvarchar(200),
	price money,
	unit varchar(20)
)

create table Stuff(
	id_stuff int identity(1,1) primary key,
	name_stuff nvarchar(200)
)

create table Stuff_detail(
	id_stuff int,
	id_kind_of_room int ,
	number int,
	primary key (id_stuff, id_kind_of_room)
)

alter table Stuff_detail
add constraint fk_stuff_detail_stuff
foreign key (id_stuff)
references Stuff(id_stuff)

alter table Stuff_detail
add constraint fk_stuff_detail_kind_of_room
foreign key (id_kind_of_room)
references Kind_of_room(id)



create table Service_ticket(
	id_reservation int not null,
	id_room int not null,
	id_service int not null,
	number int,
	date_use date,
	primary key (id_reservation, id_room, id_service, date_use)
)

 drop table Service_ticket

alter table Service_ticket
add constraint fk_service_detail_room
foreign key (id_room)
references Room(id_room)



alter table Service_ticket
add constraint fk_service_detail_service
foreign key (id_service)
references Service(id_service)

alter table Service_ticket
add constraint fk_service_detail_severvation
foreign key (id_reservation)
references Reservation(id_reservation)

create table Reservation(
	id_reservation int identity(1,1) primary key,
	id_customer int not null,
	deposit money not null,
	status_reservation int not null,
	people int not null,
	username varchar(50) not null
)

alter table Reservation
add constraint fk_reservation_customer
foreign key (id_customer)
references Customer(id_customer)


alter table Reservation
add constraint fk_reservation_staff
foreign key (username)
references Staff(username)


create table Reservation_calendar(
	id_reservation int not null,
	id_calendar int not null,
	primary key (id_reservation, id_calendar)
)

alter table Reservation_calendar
add constraint fk_reservation_calendar_reservation
foreign key (id_reservation)
references Reservation(id_reservation)


alter table Reservation_calendar
add constraint fk_reservation_calendar_calendar
foreign key (id_calendar)
references Calendar(id_calendar)

create table Calendar(
	id_calendar int identity(1,1) primary key,
	start_date date,
	end_date date,
	created datetime,
)


create table Reservation_room(
	id_reservation int not null,
	id_room int not null,
	primary key (id_reservation, id_room)
)


alter table Reservation_room
add constraint fk_reservation_detail_reservation
foreign key (id_reservation)
references Reservation(id_reservation)

alter table Reservation_room
add constraint fk_reservation_detail_room
foreign key (id_room)
references Room(id_room)

create table Bill (
	id_bill int identity(1,1) primary key,
	created date,
	total_money money not null,
	id_reservation int not null,
	username varchar(50)
)


alter table Bill
add constraint fk_bill_staff
foreign key (username)
references Staff(username)


alter table Bill
add constraint fk_bill_reservation
foreign key (id_reservation)
references Reservation(id_reservation)




create table Log_swap_room(
	id_log int identity(1,1) primary key,
	id_reservation int not null,
	id_room_old int not null,
	id_room_new int not null,
	price_difference money not null,
	select_record bit not null,
	created date not null
)

alter table Log_swap_room 
add constraint fk_log_swap_room_room_old
foreign key (id_room_old)
references Room(id_room)

alter table Log_swap_room 
add constraint fk_log_swap_room_room_new
foreign key (id_room_new)
references Room(id_room)

alter table Log_swap_room 
add constraint fk_log_swap_room_reservation
foreign key (id_reservation)
references Reservation(id_reservation)


alter table Staff 
add constraint fk_staff_account
foreign key (username)
references Account(username)


create table Room_status(
	id_status int identity(1,1) primary key,
	name_status nvarchar(100) not null,
	image_room_status image, 
)

alter table Room
add constraint fk_room_room_status
foreign key (id_status)
references Room_status(id_status)

create table Reservation_status(
	id_status int identity(1,1) primary key,
	name_status nvarchar(100) not null,
	image_status image,
)


alter table Reservation 
add constraint fk_reservation_reservation_status
foreign key (status_reservation)
references reservation_status(id_status)

insert into Account values('peterdinh018','4297f44b13955235245b2497399d7a93','1');
select * from account


insert into Staff values ('dinhdinh',N'Đinh Quang Trưởng', '1','1997-1-1', N'Việt Nam', '09xxxxxxxx', 'email@gmail.com')

create proc USP_GetAccount
@username varchar(50)
as
begin
	select * from Account where username=@username
end


create proc USP_CountAccount
@id_type int
as
begin
	select count(*) from Account where id_type=@id_type
end

create proc USP_InsertAccount
@username varchar(50),
@password varchar(50),
@id_type int
as
begin
	insert into dbo.Account(username, password, id_type) values (
	@username, 
	@password, 
	@id_type
	)
end

create proc USP_CheckLogin
@username varchar(50),
@password varchar(125)
as
begin
	select * from Account where username = @username and password = @password
end

create proc USP_GetProfile
@username varchar(50)
as
begin
	select * from Staff where username=@username
end

create proc USP_Change_password
@username varchar(50),
@password_new varchar(50)
as
begin
	update Account set password=@password_new where username=@username
end


exec USP_CheckLogin @username='peterdinh', @password='4297f44b13955235245b2497399d7a93'

exec dbo.USP_InsertAccount @username=dinhdinh11, @password="4297f44b13955235245b2497399d7a93", @id_type=1

exec dbo.USP_GetAccount @username=peterdinh

exec dbo.USP_CountAccount @id_type=1

exec USP_GetProfile @username=dinhdinh
