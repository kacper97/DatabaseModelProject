 #drop table scheduled_flight;
 CREATE TABLE SCHEDULED_FLIGHT (SPath varchar(10), SOwned int(50), ScheduledID INT(50) primary key NOT NULL, Duration double, TimeDelay double, DepartTime datetime, constraint SCHEDULED_CK_DTime check(DepartTime<sysdate()), 
 ArrivalTime datetime, constraint SCHEDULED_CK_ATime check(ArrivalTime>DepartTime), PassengerAmount int(5),
 MealType varchar(50), constraint SCHEDULED_CK_MType check(MealType= "Breakfast" or "Lunch" or "Dinner"), Terminal int(2), Gate int(5)) engine innodb;
 
insert into scheduled_flight values ("FR863", 1, 12323, 3, 0.1, '2018-01-01 10:45:00', '2018-01-01 13:45:00', 230,"Lunch" , 1, 2);
insert into scheduled_flight values ("FR863", 2, 3121, 2, 0.1, '2019-01-01 10:45:00', '2019-01-01 12:45:00', 230,"Lunch" , 1, 2);
# wrong value for meal in the next line
# insert into scheduled_flights values ("FR863", 3, 999, 3, 0.1, '2018-01-01 10:45:00', '2017-01-01 13:46:00', 230,"Ciara", 1, 2);
# wrong value for depart day, must be greater then today in the next line
# insert into scheduled_flights values ("FR863", 4, 999, 3, 0.1, '2012-01-01 10:45:00', '2017-01-01 13:46:00', 230,"Lunch" , 1, 2);
# wrong value for arrival date,must be greater i.e later then the departure date in the next line
# insert into scheduled_flights values ("FR863", 5, 999, 3, 0.1, '2019-01-01 10:45:00', '2017-01-01 13:46:00', 230,"Lunch" , 1, 2);
# wrong value for dates/ duration - duration says 3 hours but dates show 4 hours trip
#insert into scheduled_flights values ("FR863", 2,999, 3, 0.1, '2019-01-01 10:45:00', '2019-01-01 14:45:00', 230,"Lunch" , 1, 2);
# wrong value for duration - cant be negative or 0
#insert into scheduled_flights values ("FR863", 2, 999,  0, 0.1, '2019-01-01 10:45:00', '2019-01-01 13:45:00', 230,"Lunch" , 1, 2);
#insert into scheduled_flights values ("FR863", 2, 999,  -3, 0.1, '2019-01-01 10:45:00', '2019-01-01 13:45:00', 230,"Lunch" , 1, 2);

alter table scheduled_flight add constraint SPath_FK foreign key (SPath) references flight_path (pathID);
alter table scheduled_flight add constraint SOwned_FK foreign key (SOwned) references plane_owned (OwnedID);
select * from scheduled_flight;