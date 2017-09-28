#drop table booking_passenger;
create table BOOKING_PASSENGER(BookingID int(50),GPassenger int(50)) engine INNODB;

insert into booking_passenger values (1,2112);

alter table booking_passenger add constraint GPassenger_FK foreign key (GPassenger) references passenger (PassportNo);
alter table booking_passenger add constraint BookingID_FK foreign key (BookingID) references booking (BookingID);
select * from booking_passenger;