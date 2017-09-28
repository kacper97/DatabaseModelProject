#drop table supply_company;

create table SUPPLY_COMPANY (CompanyID int(50) primary key NOT NULL, CompanyProduct varchar(50), PhoneNumber int(20), Location varchar(20), DeliveryDaySchedule varchar(20),
constraint Delivery_ck_daySchedule check(DeliveryDaySchedule="Monday" or "Tuesday" or "Wednesday" or "Thursday" or "Friday" or "Saturday" or "Sunday"))engine INNODB;


insert into supply_company values( 1, "Perfume", 085123412, "Tramore", "Monday");
insert into supply_company values(2, "Milk", 091299565, "Rzeszow", "Tuesday");
insert into supply_company values(3, "Games", 09129928, " Dublin", "Sunday");

#wrong value for Delivery day schedule, not one of the week days
#insert into supply_companies values(2, "Scratch Card", 0912993921, "Waterford", "Never");

select * from supply_company;