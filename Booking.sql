#drop table booking;
create table booking(BookingID int(50) primary key NOT NULL, BScheduled int(50), CustomerName varchar(30), CustomerAddress varchar(30), NumberInBooking int(5),constraint Number_ck_InBooking check (NumberInBooking !=0), BookingTotal double, constraint Booking_ck_Total check (BookingTotal !=0)) engine INNODB;

insert into booking values(1,3121,"John", "Tramore",2,1);
# wrong value for the booking total
#insert into booking values(2,2,"John", "Tramore",2,0);
# wrong value for the numberInBooking
#insert into booking values(3,3,"John", "Tramore",0,1);

alter table booking add constraint BScheduled_FK foreign key (BScheduled) references scheduled_flight (ScheduledID);
select * from booking;