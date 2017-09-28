#drop table partner_airport;
 create TABLE PARTNER_AIRPORT (AirportName VARCHAR(50) primary key NOT NULL,NameAbbreviated VARCHAR(5), Location VARCHAR(20), terminalNo INT(2),
 runwayLength DOUBLE, radioFrequency DOUBLE) ;
 
INSERT into partner_airport values ("Dublin", "Dub", "Dublin, Ireland", 2, 2.637, 118.60);
INSERT into partner_airport values ("Rzeszow", "Rze", "Jasionka, Poland", 1, 3.2, 126.800);
Select * from partner_airport;
 