#drop table flight_path;
 create TABLE FLIGHT_PATH(PathId VARCHAR(10) primary key NOT NULL, SAirport varchar(50),DAirport VARCHAR(50),FoodService VARCHAR(5),
 FlightTrajectory varchar(100));
 
 INSERT into flight_path values ("FR863", "Dublin", "Rzeszow", "Yes", "United Kingdom, Netherlands, Germany, Poland");
 Select * from flight_path;
 
 alter table flight_path add constraint SAirport_FK foreign key (SAirport) references partner_airport (AirportName);
alter table flight_path add constraint DAirport_FK foreign key (DAirport) references partner_airport (AirportName);