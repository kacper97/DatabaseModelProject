#drop table passenger;

create table PASSENGER(PassportNo int(50) primary key NOT NULL, PassengerName varchar(50), DateOfBirth date, constraint Passenger_ck_DOB check(DateOfBirth>sysdate()),
Gender varchar(1),constraint Passanger_CK_Gender check(Gender="M" or Gender="F"), Address varchar(50)) engine InnoDB;

insert into passenger values (21333254,"Kacper", '1997-11-19', "M", "Stalowa Wola");
insert into passenger values (2112,"Ciara",  '1995-11-19', "F", "Tramore");
# wrong value inserted for gender 
# insert into passenger values (2123231,"Ciara",  '2001-11-19', "O", "Tramore");
# wrong value inserted for DOB, where its greater then the sysDate
# insert into passenger values (2122312,"Ciara",  '2018-11-19', "F", "Tramore");

select * from passenger;