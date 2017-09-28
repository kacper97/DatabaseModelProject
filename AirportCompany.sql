#drop table airport_company;

create table airport_company (Airport varchar(50), GCompany INT(50) NOT NULL) engine INNODB;

Insert into airport_company values("Dublin",1);

Insert into airport_company values("Rzeszow",2);

alter table airport_company add constraint Airport_FK foreign key (Airport) references partner_airport(AirportName);
alter table airport_company add constraint GCompany_FK foreign key (GCompany) references supply_company(CompanyID);
select * from airport_company;		
