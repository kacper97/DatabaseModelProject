#drop table flight_employee;
create table flight_employee(Flight int(50), SEmployee varchar(20)) engine INNODB;
insert into flight_employee values (12323,"12345H");
insert into flight_employee values (3121,"12346H");

alter table flight_employee add constraint SEmployee_FK foreign key (SEmployee) references employee (employeeID);
alter table flight_employee add constraint Flight_FK foreign key (Flight) references scheduled_flight (scheduledID);
select * from flight_employee;