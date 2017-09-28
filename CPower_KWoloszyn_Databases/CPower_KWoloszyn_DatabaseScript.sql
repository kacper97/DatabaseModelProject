### DROP AND CREATE DATABASE ~~~ ###

# DROP DATABASE cp_kw_airline;
# CREATE DATABASE cp_kw_airline;
# USE cp_kw_airline;

### ~~~ DROP TABLES ~~~ ###

DROP TABLE booking_passenger;
DROP TABLE booking;
DROP TABLE flight_employee;
DROP TABLE scheduled_flight;
DROP TABLE contract;
DROP TABLE employee;
DROP TABLE flight_path;
DROP TABLE plane_owned;
DROP TABLE airport_company;
DROP TABLE partner_airport;
DROP TABLE supply_company;
DROP TABLE passenger;
DROP TABLE employee_position;
DROP TABLE plane_model;

### ~~~ CREATE TABLES ~~~ ###

CREATE TABLE PLANE_MODEL (ModelID VARCHAR(20)PRIMARY KEY NOT NULL,EngineSize DOUBLE, MaxHours INT(50), MaxCycles INT(50), MinRunwayLength DOUBLE, 
 Capacity INT(5), NumExits INT(2),Weight DOUBLE);

CREATE TABLE Employee_Position (PositionTitle VARCHAR(50) PRIMARY KEY NOT NULL, OvertimeAllowed VARCHAR(1), 
CONSTRAINT EMPLOYEEPOS_CK_OTALL CHECK (OvertimeAllowed="Y" OR OvertimeAllowed="N"), wageRate DOUBLE, CONSTRAINT EMPLOYEEPOS_CK_Wage 
CHECK (wageRate>= 9.15))ENGINE INNODB;


CREATE TABLE PASSENGER(PassportNo INT(50) PRIMARY KEY NOT NULL, PassengerName VARCHAR(50), DateOfBirth DATE, CONSTRAINT Passenger_ck_DOB CHECK(DateOfBirth<SYSDATE()),
Gender VARCHAR(1),CONSTRAINT Passenger_CK_Gender CHECK(Gender="M" OR Gender="F"), Address VARCHAR(50)) ENGINE INNODB;

CREATE TABLE SUPPLY_COMPANY (CompanyID INT(50) PRIMARY KEY NOT NULL, CompanyProduct VARCHAR(50), PhoneNumber INT(20), Location VARCHAR(20), DeliveryDaySchedule VARCHAR(50),
CONSTRAINT Delivery_ck_daySchedule CHECK(DeliveryDaySchedule="Monday" OR "Tuesday" OR "Wednesday" OR "Thursday" OR "Friday" OR "Saturday" OR "Sunday"))ENGINE INNODB;

CREATE TABLE PARTNER_AIRPORT (AirportName VARCHAR(50) PRIMARY KEY NOT NULL,NameAbbreviated VARCHAR(5), Location VARCHAR(20), terminalNo INT(2),
 runwayLength DOUBLE, radioFrequency DOUBLE) ;
 
CREATE TABLE airport_company (Airport VARCHAR(50) NOT NULL, GCompany INT(50) NOT NULL, 
CONSTRAINT Airport_FK FOREIGN KEY (Airport) REFERENCES partner_airport(AirportName), 
CONSTRAINT GCompany_FK FOREIGN KEY (GCompany) REFERENCES supply_company(CompanyID)) ENGINE INNODB;

CREATE TABLE PLANE_OWNED (PAirport VARCHAR(50) NOT NULL,OwnedID INT(50) PRIMARY KEY NOT NULL, OModel VARCHAR(20) NOT NULL, PlaneManufacDate DATE, 
 CONSTRAINT PLANE_CK_PMDate CHECK (PlaneManufacDate>'1974-01-01'  AND PlaneManufacDate< SYSDATE()),PurchaseDate DATE,  
 CONSTRAINT PLANE_CK_PDate CHECK (PurchaseDate > PlaneManufacDate AND PurchaseDate<= SYSDATE()),
TotalHours INT(50), TotalCycles INT(50), PurchaseCost DOUBLE, FirstMaintenanceDate DATE,
CONSTRAINT PLANE_CK_FMDate CHECK (FirstMaintenanceDate>=PurchaseDate AND FirstMaintenanceDate<= SYSDATE()),
CONSTRAINT PAirport_FK FOREIGN KEY (PAirport) REFERENCES partner_airport(AirportName),
CONSTRAINT OModel_FK FOREIGN KEY (OModel) REFERENCES plane_model(ModelID)) ENGINE INNODB;

CREATE TABLE FLIGHT_PATH(PathId VARCHAR(10) PRIMARY KEY NOT NULL, SAirport VARCHAR(50) NOT NULL,DAirport VARCHAR(50) NOT NULL,FoodService VARCHAR(5), 
CONSTRAINT Path_CK_GFood CHECK(FoodService="Yes" OR FoodService="No"),
 FlightTrajectory VARCHAR(100),CONSTRAINT SAirport_FK FOREIGN KEY (SAirport) REFERENCES partner_airport (AirportName),
CONSTRAINT DAirport_FK FOREIGN KEY (DAirport) REFERENCES partner_airport (AirportName));
 
 CREATE TABLE Employee (EAirport VARCHAR(50) NOT NULL, EmployeeID VARCHAR(20) PRIMARY KEY NOT NULL, EmployeeName VARCHAR(30),
 EPosition VARCHAR(50) NOT NULL, EmployeeDOB DATE, CONSTRAINT EMPLOYEE_CK_DOB CHECK (SYSDATE()-EmployeeDOB>=18),
EmployeeAddress VARCHAR(50), EmployeeGender VARCHAR(1), CONSTRAINT EMPLOYEE_CK_Gender CHECK (EmployeeGender="M" OR EmployeeGender="F"),
CONSTRAINT EAirport_FK FOREIGN KEY (EAirport) REFERENCES partner_airport (AirportName),
CONSTRAINT EPosition_FK FOREIGN KEY (EPosition) REFERENCES employee_position(PositionTitle)) ENGINE INNODB;

CREATE TABLE Contract (CEmployeeID VARCHAR(20) NOT NULL, CONSTRAINT Contract_FK FOREIGN KEY (CEmployeeID) REFERENCES employee (employeeID), 
ContractStart DATE, CONSTRAINT Contract_ck_startDate CHECK (ContractStart <= SYSDATE()), 
ContractEnd DATE, CONSTRAINT Contract_ck_endDate CHECK (ContractEnd > ContractStart AND ContractEnd>SYSDATE()), ContractMinHours DOUBLE)ENGINE INNODB;

 CREATE TABLE SCHEDULED_FLIGHT (SPath VARCHAR(10) NOT NULL, SOwned INT(50) NOT NULL, ScheduledID INT(50) PRIMARY KEY NOT NULL, Duration DOUBLE, TimeDelay DOUBLE, DepartTime DATETIME, CONSTRAINT SCHEDULED_CK_DTime CHECK(DepartTime<SYSDATE()), 
 ArrivalTime DATETIME, CONSTRAINT SCHEDULED_CK_ATime CHECK(ArrivalTime>DepartTime), 
 MealType VARCHAR(50), CONSTRAINT SCHEDULED_CK_MType CHECK(MealType= "Breakfast" OR "Lunch" OR "Dinner" OR "None"), Terminal INT(2), Gate INT(5),
CONSTRAINT SPath_FK FOREIGN KEY (SPath) REFERENCES flight_path (pathID),
CONSTRAINT SOwned_FK FOREIGN KEY (SOwned) REFERENCES plane_owned (OwnedID)) ENGINE INNODB;
 
CREATE TABLE flight_employee(Flight INT(50) NOT NULL, SEmployee VARCHAR(20) NOT NULL,
CONSTRAINT SEmployee_FK FOREIGN KEY (SEmployee) REFERENCES employee (employeeID),
CONSTRAINT Flight_FK FOREIGN KEY (Flight) REFERENCES scheduled_flight (scheduledID)) ENGINE INNODB;

CREATE TABLE booking(BookingID INT(50) PRIMARY KEY NOT NULL, BScheduled INT(50) NOT NULL,CustomerEmail VARCHAR(50), CustomerName VARCHAR(30), CustomerAddress VARCHAR(50), NumberInBooking INT(5),
CONSTRAINT Number_ck_InBooking CHECK (NumberInBooking !=0), BookingTotal DOUBLE, CONSTRAINT Booking_ck_Total CHECK (BookingTotal !=0),
CONSTRAINT BScheduled_FK FOREIGN KEY (BScheduled) REFERENCES scheduled_flight (ScheduledID)) ENGINE INNODB;

CREATE TABLE BOOKING_PASSENGER(Booking INT(50) NOT NULL,GPassenger INT(50) NOT NULL,
CONSTRAINT GPassenger_FK FOREIGN KEY (GPassenger) REFERENCES passenger (PassportNo),
CONSTRAINT Booking_FK FOREIGN KEY (Booking) REFERENCES booking (BookingID)) ENGINE INNODB;


### ~~~ CREATE TRIGGERS ~~~ ###

delimiter |

CREATE TRIGGER `cp_kw_airline`.`booking_BEFORE_INSERT` BEFORE INSERT ON `booking` FOR EACH ROW
BEGIN
IF(new.NumberInBooking=0) THEN
SIGNAL SQLSTATE '45000';
END IF;
IF(new.BookingTotal=0) THEN
SIGNAL SQLSTATE '45000';
END IF;
END
|

CREATE TRIGGER `cp_kw_airline`.`contract_BEFORE_INSERT` BEFORE INSERT ON `contract` FOR EACH ROW
BEGIN

IF (new.ContractStart>=SYSDATE()) THEN
SIGNAL SQLSTATE '45000';
END IF;

IF(new.ContractStart>=new.ContractEnd OR new.ContractEnd<SYSDATE())THEN
SIGNAL SQLSTATE '45000';
END IF;
END
|

CREATE TRIGGER `cp_kw_airline`.`employee_position_BEFORE_INSERT` BEFORE INSERT ON `employee_position` FOR EACH ROW
BEGIN
IF (new.OvertimeAllowed!="Y" AND new.OvertimeAllowed!="N")THEN
SIGNAL SQLSTATE '45000';
END IF;
IF (new.wageRate<9.15)THEN
SIGNAL SQLSTATE '45000';
END IF;
END
|

CREATE TRIGGER `cp_kw_airline`.`passenger_BEFORE_INSERT` BEFORE INSERT ON `passenger` FOR EACH ROW
BEGIN
IF(new.Gender!="M" AND new.Gender!="F")THEN
SIGNAL SQLSTATE '45000';
END IF;
IF(new.DateOfBirth>SYSDATE()) THEN
SIGNAL SQLSTATE '45000';
END IF;
END
|

CREATE TRIGGER `cp_kw_airline`.`scheduled_flight_BEFORE_INSERT` BEFORE INSERT ON `scheduled_flight` FOR EACH ROW
BEGIN
 IF new.departTime<SYSDATE()THEN
 SIGNAL SQLSTATE '45000';
 END IF;
 IF new.arrivalTime<new.departTime THEN
SIGNAL SQLSTATE '45000';
END IF;
IF new.Duration<=0 THEN
SIGNAL SQLSTATE '45000';
END IF;
 IF (new.MealType!="Breakfast" AND new.MealType!="Lunch" AND new.MealType!="Dinner"AND new.MealType!="None")THEN
 SIGNAL SQLSTATE '45000';
 END IF;
 IF((TIMESTAMPDIFF(MINUTE,new.DepartTime,new.ArrivalTime)) != (new.Duration))THEN
 SIGNAL SQLSTATE '45000';
 END IF;
END
|

CREATE TRIGGER `cp_kw_airline`.`supply_company_BEFORE_INSERT` BEFORE INSERT ON `supply_company` FOR EACH ROW
BEGIN
IF (new.DeliveryDaySchedule!="Monday" AND new.DeliveryDaySchedule!="Tuesday" AND new.DeliveryDaySchedule!="Wednesday" AND new.DeliveryDaySchedule!="Thursday"  AND new.DeliveryDaySchedule!="Friday"  AND new.DeliveryDaySchedule!="Saturday" AND new.DeliveryDaySchedule!="Sunday"  )THEN
SIGNAL SQLSTATE '45000';
END IF;
END
|

CREATE TRIGGER `cp_kw_airline`.`employee_BEFORE_INSERT` BEFORE INSERT ON `employee` FOR EACH ROW
BEGIN
IF(TIMESTAMPDIFF(YEAR,new.EmployeeDOB,SYSDATE()) <= 18) THEN
SIGNAL SQLSTATE '45000';
END IF;
IF(new.EmployeeGender!="M" AND new.EmployeeGender!="F")THEN
SIGNAL SQLSTATE '45000';
END IF;  
END
|

delimiter ;

### ~~~ TEST TRIGGERS FOR EACH TABLE INSERT ~~~ ###

# Next command won't complete due to DOB being too recent (employee less than 18 years)
# INSERT into Employee values("Dublin", "99999H", "John Nolan", "Pilot", '2004-01-01',"Dublin 2, Ireland", "M");
# Next command won't complete due to incorrect gender value
# INSERT into Employee values("Dublin", "999998H", "Jim Nolan", "Pilot", '1997-01-01',"Dublin 2, Ireland", "H");

# wrong value for meal in the next line
# insert into scheduled_flight values ("FR863", 3, 999, 180, 0.1, '2018-01-01 10:45:00', '2018-01-01 13:45:00',"Ciara", 1, 2);
# wrong value for depart day, must be greater then today in the next line
# insert into scheduled_flight values ("FR863", 4, 999, 60, 0.1, '2012-01-01 10:45:00', '2012-01-01 11:45:00',"Lunch" , 1, 2);
# wrong value for arrival date,must be greater i.e later then the departure date in the next line
# insert into scheduled_flight values ("FR863", 5, 999, 181, 0.1, '2019-01-01 10:45:00', '2018-01-01 13:46:00',"Lunch" , 1, 2);
# wrong value for dates/ duration - duration says 3 hours but dates show 4 hours trip
# insert into scheduled_flight values ("FR863", 2,999, 180, 0.1, '2019-01-01 10:45:00', '2019-01-01 14:45:00',"Lunch" , 1, 2);
# wrong value for duration - cant be negative or 0
# insert into scheduled_flight values ("FR863", 2, 999,  0, 0.1, '2019-01-01 10:45:00', '2019-01-01 10:45:00',"Lunch" , 1, 2);
# insert into scheduled_flight values ("FR863", 2, 999,  -180, 0.1, '2019-01-01 10:45:00', '2019-01-01 13:45:00', "Lunch" , 1, 2);

# wrong value for the booking total
# insert into booking values(2,2,"John@hotmail.com","John", "Tramore",2,0);
# wrong value for the numberInBooking
# insert into booking values(3,3,"John@hotmail.com","John", "Tramore",0,1);

# Next command doesn't complete because value for OvertimeAllowed is not Y or N
# insert into Employee_position values("Not Employed", "K", 12);
# Next command doesn't complete because wageRate is less than the minimum wage in Ireland 9.15
# insert into Employee_position values("Not Employed", "Y", 8);

# Next insert won't complete due to ContractStart being later than todays date 
# insert into Contract values(999,'2032-01-01', '2033-02-02', 40);
# Next insert won't complete due to ContractEnd being before ContractStart
# insert into Contract values(999,'2002-01-01', '2000-02-02', 40);
# Next insert won't complete due to ContractEnd being before todays date
# insert into Contract values(999,'2001-01-01', '2003-02-02', 40);

# wrong value inserted for gender 
# insert into passenger values (2123231,"Ciara",  '2001-11-19', "O", "Tramore");
# wrong value inserted for DOB, where its greater then the sysDate
# insert into passenger values (2122312,"Ciara",  '2018-11-19', "F", "Tramore");

# wrong value for Delivery day schedule, not one of the week days
# insert into supply_company values(2, "Scratch Card", 0912993921, "Waterford", "Never");

### ~~~ INSERT DATA INTO TABLES ~~~ ###

INSERT INTO plane_model VALUES ("Boeing 777", 110000, 44000, 40000, 1678, 396, 8, 135600);
INSERT INTO plane_model VALUES ("Boeing 776", 112000, 44000, 40000, 1676, 396, 8, 135600);
INSERT INTO plane_model VALUES ("Airbus A300 B2", 105000,  67000, 30000, 2701, 180, 4, 73500);
INSERT INTO plane_model VALUES ("Airbus A300 B4", 120000,  66000, 28000, 2721, 200, 6, 80000);
INSERT INTO plane_model VALUES ("Concorde", 100000,  70000, 32000, 3061, 100, 6, 78700);
INSERT INTO plane_model VALUES ("Beechcraft 1900D", 2558,  30000, 18000, 1035, 19, 2, 7530);
INSERT INTO plane_model VALUES ("Short 330", 2396,  30000, 18000, 990, 30, 2, 10387);
INSERT INTO plane_model VALUES ("Boeing 747 LCF", 200000,  50000, 35000, 3061, 2, 2, 364235);
INSERT INTO plane_model VALUES ("Bombardier CRJ700", 105800,  40000, 25000, 1440, 82, 4, 30390);
INSERT INTO plane_model VALUES ("Bombardier CS300ER", 115800,  45000, 30000, 1755, 130, 6, 50348);

INSERT INTO Employee_position VALUES("Pilot", "N", 17);
INSERT INTO Employee_position VALUES("Flight Attendant", "N", 13);
INSERT INTO Employee_position VALUES("Operations Agent", "Y", 13.50);
INSERT INTO Employee_position VALUES("Avionic Technician", "Y", 15);
INSERT INTO Employee_position VALUES("Sales Manager", "Y", 11);
INSERT INTO Employee_position VALUES("Flight Dispatcher", "Y", 15);
INSERT INTO Employee_position VALUES("Airport Station Attendant", "Y", 10.50);
INSERT INTO Employee_position VALUES("Aviation Meteorologist", "Y", 9.25);
INSERT INTO Employee_position VALUES("Passenger Service Agent", "Y", 10);
INSERT INTO Employee_position VALUES("Airline Ticket Agent", "Y", 11);

INSERT INTO passenger VALUES (21333254,"Kacper Woloszyn", '1997-11-19', "M", "23 Rzeszow, Stalowa Wola, Poland");
INSERT INTO passenger VALUES (2112,"Ciara Power",  '1995-11-19', "F", "4 Moonvoy Valley, Tramore, Ireland");
INSERT INTO passenger VALUES (75838583,"Liam Tobin", '1980-03-01', "M", "5 Greenway, Dublin 4, Ireland");
INSERT INTO passenger VALUES (2033984,"Niamh Tobin",  '1978-10-29', "F", "5 Greenway, Dublin 4, Ireland");
INSERT INTO passenger VALUES (55749399,"John O'Reilly", '1960-04-11', "M", "29 RiverWalk, London, England");
INSERT INTO passenger VALUES (1103845,"Mary O'Reilly",  '1963-12-25', "F", "29 RiverWalk, London, England");
INSERT INTO passenger VALUES (5756639,"Emma Quinlan", '1985-06-12', "F", "17 Sea Close, SaltHill, Galway, Ireland");
INSERT INTO passenger VALUES (77744829,"Paul Quinlan",  '1986-09-09', "M", "17 Sea Close, SaltHill, Galway, Ireland");
INSERT INTO passenger VALUES (1284839,"Lee Murphy", '2000-01-02', "M", "102 Sweetbriar, Donegal, Ireland");
INSERT INTO passenger VALUES (211367282,"Ben Watts",  '2000-02-19', "M", "67 King's Terrace, Donegal, Ireland");
INSERT INTO passenger VALUES (9384757,"Sarah Quinlan", '2005-03-07', "F", "17 Sea Close, SaltHill, Galway, Ireland");
INSERT INTO passenger VALUES (11846389,"Catherine Higgins",  '1940-08-24', "F", "56 LeafLane, Sligo, Ireland");
INSERT INTO passenger VALUES (999221,"Luca Piecioni",  '1960-10-14', "F", "42 Amoreno, Milan, Italy");
INSERT INTO passenger VALUES (555643,"John Robberts",  '1987-11-14', "M", "42 Anne Court, London, United Kingdom");
INSERT INTO passenger VALUES (77223,"Amy Long",  '1987-11-14', "M",  "42 John's Court, London, United Kingdom");

INSERT INTO supply_company VALUES(1, "Perfume", 085546412, "Dublin", "Monday");
INSERT INTO supply_company VALUES(2, "Milk", 091349565, "Rzeszow", "Tuesday");
INSERT INTO supply_company VALUES(3, "Games", 09177878, "Dublin", "Sunday");
INSERT INTO supply_company VALUES(4, "Soap", 08512233, "Rzeszow", "Wednesday");
INSERT INTO supply_company VALUES(5, "Sweets", 0912876565, "London", "Tuesday");
INSERT INTO supply_company VALUES(6, "Booklets", 02345928, "London", "Friday");
INSERT INTO supply_company VALUES(7, "Milk", 0851224562, "London", "Sunday");
INSERT INTO supply_company VALUES(8, "Meals", 093456565, "Paris", "Saturday");
INSERT INTO supply_company VALUES(9, "Meals", 092277428, "Dublin", "Thursday");
INSERT INTO supply_company VALUES(10, "Alcohol", 085993612, "Paris", "Thursday");
INSERT INTO supply_company VALUES(11, "Soap", 0912923455, "Milan", "Friday");
INSERT INTO supply_company VALUES(12, "Uniforms", 0913678828, "Milan", "Sunday");

INSERT INTO partner_airport VALUES ("Dublin", "DUB", "Dublin, Ireland", 2, 2637, 118.60);
INSERT INTO partner_airport VALUES ("Rzeszow", "RZE", "Jasionka, Poland", 1, 3200, 126.800);
INSERT INTO partner_airport VALUES ("London", "LCY", "London, Ireland", 1, 1500, 118.075);
INSERT INTO partner_airport VALUES ("Paris", "CDG", "Paris, France", 3, 4215, 121.60);
INSERT INTO partner_airport VALUES ("Milan", "MXP", "Milan, Italy", 2, 3920, 119.0);
INSERT INTO partner_airport VALUES ("Madrid", "MAD", "Madrid, Spain", 5, 4350, 118.07);

INSERT INTO airport_company VALUES("Dublin",1);
INSERT INTO airport_company VALUES("Dublin",3);
INSERT INTO airport_company VALUES("Dublin",9);
INSERT INTO airport_company VALUES("Rzeszow",2);
INSERT INTO airport_company VALUES("Rzeszow",4);
INSERT INTO airport_company VALUES("London",5);
INSERT INTO airport_company VALUES("London",6);
INSERT INTO airport_company VALUES("London",7);
INSERT INTO airport_company VALUES("Paris",8);
INSERT INTO airport_company VALUES("Paris",10);
INSERT INTO airport_company VALUES("Milan",11);
INSERT INTO airport_company VALUES("Milan",12);

INSERT INTO PLANE_OWNED VALUES ("Dublin", 1, "Boeing 777",'1980-01-01','2010-01-01', 44000,30000,320200000,'2010-05-03');
INSERT INTO PLANE_OWNED VALUES ("Dublin", 2, "Boeing 776",'1980-01-01','2010-01-01', 9000,12000,319200000,'2010-08-03');
INSERT INTO PLANE_OWNED VALUES ("Dublin", 3, "Airbus A300 B2",'1984-02-01','1999-01-01', 10000,2000,23700000,'2001-09-03');
INSERT INTO PLANE_OWNED VALUES ("Paris", 4, "Airbus A300 B2",'1986-03-01','1987-01-01', 10000,9000,194200000,'1990-01-13');
INSERT INTO PLANE_OWNED VALUES ("Paris", 5, "Concorde",'1987-01-23','2000-01-01', 2000,6000,122200000,'2001-05-23');
INSERT INTO PLANE_OWNED VALUES ("Paris", 6, "Boeing 776",'1988-01-21','1990-01-01', 7000,12000,45200000,'1991-09-18');
INSERT INTO PLANE_OWNED VALUES ("Rzeszow",7, "Boeing 777",'1989-05-13','1991-01-01', 16000,22000,233200000,'2000-02-03');
INSERT INTO PLANE_OWNED VALUES ("London", 8, "Beechcraft 1900D",'1990-07-11','2001-01-01', 11000,20000,122200000,'2002-05-03');
INSERT INTO PLANE_OWNED VALUES ("London", 9, "Concorde",'1991-10-12','2002-01-01', 6000,7000,199200000,'2003-05-03');
INSERT INTO PLANE_OWNED VALUES ("Milan", 10, "Boeing 776",'1990-11-21','2005-01-01', 5000,6000,188200000,'2006-10-03');
INSERT INTO PLANE_OWNED VALUES ("Madrid", 11, "Concorde",'1992-05-03','2008-01-01', 20000,19000,176200000,'2010-05-13');
INSERT INTO PLANE_OWNED VALUES ("Madrid", 12, "Beechcraft 1900D",'1993-07-11','2000-01-01', 21000,23000,4300000,'2002-11-03');
INSERT INTO PLANE_OWNED VALUES ("Madrid", 13, "Beechcraft 1900D",'1994-01-15','1995-01-01', 22000,23000,111200000,'1996-05-10');
INSERT INTO PLANE_OWNED VALUES ("Rzeszow", 14, "Bombardier CS300ER",'1995-01-18','1997-01-01', 21000,20000,222200000,'2000-11-02');
INSERT INTO PLANE_OWNED VALUES ("Dublin", 15, "Short 330",'1996-04-21','1998-09-01', 18000,16000,234200000,'1999-08-09');
INSERT INTO PLANE_OWNED VALUES ("Dublin", 16, "Boeing 747 LCF",'1997-06-01','2010-01-01', 12000,35000,320200000,'2011-05-13');
INSERT INTO PLANE_OWNED VALUES ("Dublin", 17, "Bombardier CRJ700",'1998-08-06','2003-01-01', 16000,19000,1200000,'2005-12-03');
INSERT INTO PLANE_OWNED VALUES ("Paris", 18, "Short 330",'1999-08-08','2004-01-01', 11000,22000,12200000,'2005-12-05');
INSERT INTO PLANE_OWNED VALUES ("Paris",19, "Bombardier CRJ700",'1999-01-01','2000-01-01', 12000,21000,21200000,'2001-05-08');
INSERT INTO PLANE_OWNED VALUES ("Paris", 20, "Boeing 747 LCF",'1980-10-16','1982-01-01', 9000,22000,823200000,'1983-06-03');
INSERT INTO PLANE_OWNED VALUES ("Rzeszow",21, "Short 330",'1984-08-27','1986-01-01',8000,9000,1200000,'1987-05-03');
INSERT INTO PLANE_OWNED VALUES ("London",22, "Beechcraft 1900D",'1985-02-28','1986-01-01', 22000,21000,4200000,'1987-09-19');
INSERT INTO PLANE_OWNED VALUES ("London", 23, "Short 330",'1987-09-11','1988-01-01', 12000,21000,2200000,'1989-03-22');
INSERT INTO PLANE_OWNED VALUES ("Milan", 24, "Bombardier CRJ700",'1988-05-05','1989-01-01', 22000,23000,320200000,'1990-09-17');
INSERT INTO PLANE_OWNED VALUES ("Madrid", 25, "Short 330",'1983-12-09','2000-01-01', 21000,3000,9200000,'2001-08-18');
INSERT INTO PLANE_OWNED VALUES ("Madrid", 26, "Bombardier CRJ700",'1984-12-01','1992-01-01', 5000,10000,3300000,'1993-08-12');
INSERT INTO PLANE_OWNED VALUES ("Madrid", 27, "Beechcraft 1900D",'1985-11-13','1997-01-01', 6000,20000,8700000,'1998-02-04');
INSERT INTO PLANE_OWNED VALUES ("Rzeszow", 28, "Bombardier CS300ER",'1982-08-10','2008-01-01', 10000,3000,26300000,'2009-05-23');

INSERT INTO flight_path VALUES ("FR863", "Dublin", "Rzeszow", "Yes", "United Kingdom, Netherlands, Germany, Poland");
INSERT INTO flight_path VALUES ("EI595", "Dublin", "Madrid", "Yes", "United Kingdom, France, Spain");
INSERT INTO flight_path VALUES ("EI520", "Dublin", "Paris", "No", "United Kingdom, France");
INSERT INTO flight_path VALUES ("EI432", "Dublin", "Milan", "Yes", "United Kingdom, France, Switzerland, Italy");
INSERT INTO flight_path VALUES ("FR9428","Dublin", "Milan", "Yes", "United Kingdom, France, Switzerland, Italy");
INSERT INTO flight_path VALUES ("FR332", "Dublin", "London", "Yes", "United Kingdom");
INSERT INTO flight_path VALUES ("FR862", "Rzeszow", "Dublin", "Yes", "Germany, Netherlands, United Kingdom, Ireland");
INSERT INTO flight_path VALUES ("EI596", "Madrid", "Dublin", "Yes", "France, United Kingdom, Ireland");
INSERT INTO flight_path VALUES ("EI521", "Paris", "Dublin", "No", "United Kingdom, Ireland");
INSERT INTO flight_path VALUES ("EI433", "Milan", "Dublin", "Yes", "Switzerland, France, United Kingdom, Ireland");

INSERT INTO Employee VALUES("Dublin", "12345H", "Amy Anderson", "Pilot", '1984-01-01',"Dublin 4, Ireland", "F");
INSERT INTO Employee VALUES("Dublin", "12346H", "John Anderson", "Pilot", '1985-04-01',"Dublin 2, Ireland", "M");
INSERT INTO Employee VALUES("Dublin", "12347H", "Jack Widdow", "Flight Dispatcher", '1973-09-11',"Dublin 3, Ireland", "M");
INSERT INTO Employee VALUES("Madrid", "43210D", "Jese Rodriquez", "Pilot", '1980-05-17',"Madrid 1, Spain", "M");
INSERT INTO Employee VALUES("Madrid", "43211F", "Marta Abascal",  "Flight Attendant", '1991-11-19',"Madrid 2, Spain", "F");
INSERT INTO Employee VALUES("Madrid", "43212F", "Sofia Gonzalez", "Avionic Technician", '1978-10-07',"Madrid 3, Spain", "F");
INSERT INTO Employee VALUES("Rzeszow", "23456A", "Andrzej Grabowski", "Pilot", '1969-07-17',"Rzeszow 1,Poland", "M");
INSERT INTO Employee VALUES("Rzeszow", "23457F", "Tadeusz Norek",  "Airport Station Attendant", '1979-03-14',"Rzeszow 2,Poland", "M");
INSERT INTO Employee VALUES("Rzeszow", "23458F", "Andzelika Zadawalska",  "Sales Manager", '1989-06-21',"Rzeszow 3,Poland", "F");
INSERT INTO Employee VALUES("Paris", "34567C", "Sofia Pirre",  "Passenger Service Agent", '1979-05-30',"Paris 1,France", "F");
INSERT INTO Employee VALUES("Paris", "34568D", "Piere Henre",  "Operations Agent", '1981-12-03',"Paris 2,France", "M");
INSERT INTO Employee VALUES("Paris", "34569E", "Henrique Adabio",  "Avionic Technician", '1985-09-11',"Paris 3,France", "M");
INSERT INTO Employee VALUES("Milan", "56789P", "Luca Peroti",  "Airline Ticket Agent", '1987-08-20',"Milan 1, Italy", "M");
INSERT INTO Employee VALUES("Milan", "56788Q", "Lucina Armino",  "Flight Attendant", '1984-02-01',"Milan 2, Italy", "F");
INSERT INTO Employee VALUES("Milan", "56787Q", "Gabriela Lucini",  "Sales Manager", '1978-09-07',"Milan 3, Italy", "F");
INSERT INTO Employee VALUES("London", "98765M", "Garry Bentley",  "Pilot", '1978-04-19',"London 1, United Kingdom", "M");
INSERT INTO Employee VALUES("London", "98764F", "Mary Wilson",  "Airport Station Attendant", '1983-07-12',"London 2, United Kingdom", "F");
INSERT INTO Employee VALUES("London", "98763F", "Bernadette Smith",  "Flight Dispatcher", '1931-02-01',"London 3, United Kingdom", "F");


INSERT INTO Contract VALUES("12345H",'2002-01-01', '2020-02-02', 40);
INSERT INTO Contract VALUES("12346H",'2002-01-01', '2020-02-02', 40);
INSERT INTO Contract VALUES("12347H",'2005-07-01', '2018-08-02', 40);
INSERT INTO Contract VALUES("43210D",'2015-09-29', '2019-01-29', 35);
INSERT INTO Contract VALUES("43211F",'2000-10-21', '2018-10-15', 40);
INSERT INTO Contract VALUES("43212F",'2007-09-16', '2018-02-20', 40);
INSERT INTO Contract VALUES("23456A",'2009-02-07', '2019-06-07', 40);
INSERT INTO Contract VALUES( "23457F",'2003-04-12', '2021-11-03', 20);
INSERT INTO Contract VALUES("23458F",'2005-01-23', '2020-08-28', 40);
INSERT INTO Contract VALUES("34567C",'2000-05-05', '2019-03-25', 40);
INSERT INTO Contract VALUES("34568D",'2005-07-01', '2018-08-02', 40);
INSERT INTO Contract VALUES("34569E",'2015-09-29', '2019-01-29', 42);
INSERT INTO Contract VALUES("56789P",'2000-10-21', '2018-10-15', 40);
INSERT INTO Contract VALUES("56788Q",'2007-09-16', '2018-02-20', 40);
INSERT INTO Contract VALUES("56787Q",'2009-02-07', '2019-06-07', 14);
INSERT INTO Contract VALUES( "98765M",'2003-04-12', '2021-11-03', 40);
INSERT INTO Contract VALUES("98764F",'2005-01-23', '2020-08-28', 22);
INSERT INTO Contract VALUES("98763F",'2000-05-05', '2019-03-25', 40);

INSERT INTO scheduled_flight VALUES ("FR863", 1, 3121, 181, 0.1, '2019-01-01 10:45:00', '2019-01-01 13:46:00', "Lunch" , 1, 2);
INSERT INTO scheduled_flight VALUES ("EI595", 3, 0013, 150, 0.3, '2018-01-01 16:00:00', '2018-01-01 18:30:00',"Dinner" , 1, 32);
INSERT INTO scheduled_flight VALUES ("EI520", 2, 1114, 105, 0, '2018-03-02 09:45:00', '2018-03-02 11:30:00',"None" , 2, 43);
INSERT INTO scheduled_flight VALUES ("EI432", 24, 0002, 180, 0, '2018-03-02 09:45:00', '2018-03-02 12:45:00',"Breakfast" , 4, 14);
INSERT INTO scheduled_flight VALUES ("FR9428", 1, 0048, 190, 0, '2019-01-01 09:45:00', '2019-01-01 12:55:00', "Breakfast" , 3, 3);
INSERT INTO scheduled_flight VALUES ("FR332", 6, 0941, 71, 0.1, '2018-01-03 17:00:00', '2018-01-03 18:11:00', "Dinner" , 1, 34);
INSERT INTO scheduled_flight VALUES ("FR862", 1, 3122, 180, 0, '2019-01-01 15:00:00', '2019-01-01 18:00:00', "Dinner" , 1, 76);
INSERT INTO scheduled_flight VALUES ("EI596", 3, 0014, 60, 0, '2019-01-01 19:00:00', '2019-01-01 20:00:00', "Dinner" , 1, 17);
INSERT INTO scheduled_flight VALUES ("EI520", 2, 1115, 90, 0, '2019-03-02 12:00:00', '2019-03-02 13:30:00',"None" , 2, 9);
INSERT INTO scheduled_flight VALUES ("EI433", 24, 0003, 180, 0, '2018-07-08 13:00:00', '2018-07-08 16:00:00', "Lunch" , 2, 17);

INSERT INTO flight_employee VALUES (3121,"12345H");
INSERT INTO flight_employee VALUES (3121,"12347H");
INSERT INTO flight_employee VALUES (0013,"43210D");
INSERT INTO flight_employee VALUES (0013,"43211F");
INSERT INTO flight_employee VALUES (0013,"43212F");
INSERT INTO flight_employee VALUES (1114,"23456A");
INSERT INTO flight_employee VALUES (0002,"34567C");
INSERT INTO flight_employee VALUES (0002,"34568D");
INSERT INTO flight_employee VALUES (0002,"34569E");
INSERT INTO flight_employee VALUES (0048,"56789P");
INSERT INTO flight_employee VALUES (0048,"56788Q");
INSERT INTO flight_employee VALUES (0048,"56787Q");
INSERT INTO flight_employee VALUES (0941,"56787Q");
INSERT INTO flight_employee VALUES (0941,"98765M");
INSERT INTO flight_employee VALUES (3122,"12346H");
INSERT INTO flight_employee VALUES (0014,"43212F");
INSERT INTO flight_employee VALUES (1115,"34569E");
INSERT INTO flight_employee VALUES (0003,"34569E");

INSERT INTO booking VALUES(1,3121,"Ciara@Hotmail.com","Ciara Power", "4 Moonvoy Valley, Tramore, Ireland",2,120.00);
INSERT INTO booking VALUES(2,3121,"Kacper@Hotmail.com","Kacper Woloszyn", "23 Rzeszow, Stalowa Wola, Poland",2,200.00);
INSERT INTO booking VALUES(3,3121,"Liam@Hotmail.com","Liam Tobin", "5 Greenway, Dublin 4, Ireland",2,290.00);
INSERT INTO booking VALUES(4,0013,"John@Hotmail.com","John O'Reilly", "29 RiverWalk, London, England",2,180.00);
INSERT INTO booking VALUES(5,1114,"Emma@Hotmail.com","Emma Quinlan", "17 Sea Close, SaltHill, Galway, Ireland",3,210.00);
INSERT INTO booking VALUES(6,0002,"Catherine@Hotmail.com","Catherine Higgins", "56 LeafLane, Sligo, Ireland",4,380.00);
INSERT INTO booking VALUES(7,0048,"Luca2@Hotmail.com","Luca Piecioni", "42 Amoreno, Milan, Italy",2,100.00);
INSERT INTO booking VALUES(8,0941,"John@Hotmail.com","John Robberts", "42 Anne Court, London, United Kingdom",1,90.00);
INSERT INTO booking VALUES(9,0941,"Amy@Hotmail.com","Amy Long", "42 John's Court, London, United Kingdom",1,230.00);

INSERT INTO booking_passenger VALUES (1,2112);
INSERT INTO booking_passenger VALUES (1,1284839);
INSERT INTO booking_passenger VALUES (2,21333254);
INSERT INTO booking_passenger VALUES (2,211367282); 
INSERT INTO booking_passenger VALUES (3,75838583);
INSERT INTO booking_passenger VALUES (3,2033984);
INSERT INTO booking_passenger VALUES (4,55749399); 
INSERT INTO booking_passenger VALUES (4,1103845);
INSERT INTO booking_passenger VALUES (5,5756639);
INSERT INTO booking_passenger VALUES (5,77744829);
INSERT INTO booking_passenger VALUES (5,9384757);
INSERT INTO booking_passenger VALUES (6,11846389);
INSERT INTO booking_passenger VALUES (6,1284839);
INSERT INTO booking_passenger VALUES (6,211367282);
INSERT INTO booking_passenger VALUES (6,75838583);
INSERT INTO booking_passenger VALUES (7,999221);
INSERT INTO booking_passenger VALUES (7,9384757);
INSERT INTO booking_passenger VALUES (8,555643);
INSERT INTO booking_passenger VALUES (9,77223);


### ~~~ DISPLAY TABLES ~~~ ###

SELECT * FROM booking_passenger;
SELECT * FROM booking;
SELECT * FROM flight_employee;
SELECT * FROM scheduled_flight;
SELECT * FROM employee;
SELECT * FROM flight_path;
SELECT * FROM plane_owned;
SELECT * FROM airport_company;
SELECT * FROM partner_airport;
SELECT * FROM supply_company;
SELECT * FROM passenger;
SELECT * FROM contract;
SELECT * FROM employee_position;
SELECT * FROM plane_model;


### ~~~ QUERIES ~~~ ###

 # get planes owned by airline older than 1995, useful for determining which planes to dispose of / sell
SELECT OwnedID, PlaneManufacDate FROM plane_owned WHERE PlaneManufacDate<'1995-01-01'; 

# gets the owned ID number, model ID (plane model name) , the airport the owned plane resides at, the capacity of each plane
# useful in planning flights to see what planes are available where, with what capacities
SELECT OwnedID, ModelID, PAirport ,Capacity  FROM plane_model,plane_owned WHERE modelID=OModel ORDER BY PAirport; 

# gets name and date of birth of any child passengers under the age of 18 on all flights
SELECT passengerName, dateofbirth FROM passenger WHERE dateofbirth>'1999-19-04';

# gets the booking id and email associated with the booking and displays with different names, useful for email lists for general airline announcements
SELECT bookingid AS 'Booking Number' ,customeremail AS 'Booking Contact Email' FROM booking;

# gets the booking id, email, and flight details for any bookings on the FR863 flight
# useful for email lists regarding a certain flight scheduled ( delays, cancellations etc)
SELECT bookingid AS 'Booking Number' ,customeremail AS 'Booking Contact Email', bscheduled AS 'Flight ID',Spath AS 'Flight Path'
FROM booking,scheduled_flight WHERE bscheduled=scheduledid AND spath="FR863";
 
 # gets the details for all planes owned that are Boeing 776 models
 # useful for deciding where a newly purchased Boeing 776 should be located 
 SELECT * FROM plane_owned WHERE Omodel="Boeing 776";
 
 # gets the available plane models and how many of that model is owned by the airline, count of 0 if none owned in that model
 # useful in decisions for new plane purchases, to aim to have a suitable amount of each plane model
 SELECT ModelID,COUNT(OModel) AS 'Number Owned' FROM plane_model LEFT OUTER JOIN plane_owned ON omodel=modelID GROUP BY modelID;
 
 # gets the sum of the passengers booked on each flight, and shows the capacity of the plane being used for the flight
 # useful to see if a larger plane is needed for a flight to avoid overbookings
 SELECT  scheduledID AS 'Flight',SUM(numberInBooking) AS 'Passengers',modelID AS 'Plane Model', capacity FROM booking,scheduled_flight,plane_owned,plane_model
 WHERE scheduledid=bscheduled AND sowned=ownedid AND omodel=modelid GROUP BY scheduledid;
 
 # gets the average price, lowest price, and highest price per ticket for each scheduled flight
 # useful to compare flight prices, and see the range of prices for a flight
 SELECT ROUND((AVG(bookingtotal/numberinbooking)),2) AS 'Average Price',ROUND((MAX(bookingtotal/numberinbooking)),2) AS 'Highest Price' ,
 ROUND((MIN(bookingtotal/numberinbooking)),2) AS 'Lowest Price',scheduledid AS 'Flight'
 FROM booking, scheduled_flight WHERE bscheduled=scheduledid GROUP BY scheduledid;

 # gets the source, destination information of a flight, whether foodservice is available, duration and mealtype
 # useful to see if the duration of the flight is adequate to the food service and meal type available
 SELECT sairport AS 'From', dairport AS 'to', foodservice AS 'Food available?', duration, mealtype FROM flight_path,scheduled_flight WHERE mealtype="Dinner" AND foodservice ="Yes";

 # gets the passport number of the passengers that have been booked on each scheduled flight
 SELECT gpassenger AS 'Passport Number',passengername AS 'Name of Passenger',bscheduled FROM booking_passenger, passenger,booking WHERE Gpassenger=PassportNo AND booking=bookingid ORDER BY bscheduled;
 
 # gets the end date for an employee, employee name and position , orders in ascending dates, contract ending sooner is first
 # useful to see when is the nearest day an employee contract will run out
 SELECT contractend AS 'End Date', employeeName AS 'Name of Employee', eposition AS 'Position' FROM employee, contract WHERE CEmployeeID=employeeID AND contractend<'2018-12-31' ORDER BY contractend;
 
 # gets name and date of birth of any employees that are less then 30 years old. Orders with the youngest at the top of the list
 SELECT employeeName, employeeDOB FROM employee WHERE  employeeDOB >'1987-01-01' ORDER BY employeeDOB DESC;

 # gets path id, destination, flight trajectory and duration from 2 tables where source is Milan
 # useful to see over which countries a route is taken, maybe in order for tower radio attendants to contact the relevant airports for airspace clearance.
 SELECT pathid, SAirport AS ' Source', DAirport AS 'Destination', flighttrajectory AS 'Places flown over', duration FROM flight_path, scheduled_flight WHERE Spath= pathID AND SAirport ="Milan";
 
 # gets the name of the airport, day and the product of a company on a sunday to milan
 # useful to see what deliverys come on different days to different airports
 SELECT airportName AS 'Airport', deliverydayschedule AS 'Day', companyproduct AS 'Product Being Delivered' FROM supply_company, partner_airport , airport_company WHERE airportname=airport AND gcompany=companyid AND deliverydayschedule = "Sunday" AND airportName="Milan";
 
  # gets the available positions and how many of that positions are occupied within the airline, count of 0 if no employees for that position
  # useful in decisions whether to hire a worker or not and how many people are working in specific positions
 SELECT positiontitle,COUNT(eposition) AS 'Number Employed' FROM employee_position LEFT OUTER JOIN employee ON positiontitle=eposition GROUP BY positiontitle;
 
 # gets name, airport and flight, from 2 tables matching IDs 
 # useful to see which employee works on what flight and how many flights a specific employee works on, and what the base airport is for that employee
 SELECT employeeName, EAirport,flight  FROM employee, flight_employee WHERE SEmployee=employeeID ORDER BY employeename;
 
 # gets the sum of the employees on each flight, and shows the flight number, model, capacity and duration of the flight
 # useful to see if more employees are needed on a specific flight
 SELECT  scheduledID AS 'Flight Number',COUNT(Semployee) AS 'number of employees',modelID AS 'Plane Model', capacity, duration FROM flight_employee,scheduled_flight,plane_owned,plane_model
 WHERE scheduledid=Flight AND sowned=ownedid AND omodel=modelid GROUP BY scheduledid;
 
 # changes type of numexits to INT(5) instead of INT(2)
 ALTER TABLE PLANE_MODEL MODIFY NumExits INT(5);
 
 
 ### ~~~ VIEWS ~~~ ###    

 DROP VIEW planes_owned_view;
 CREATE VIEW planes_owned_view AS SELECT ownedid, Omodel FROM plane_owned ;
 SELECT * FROM planes_owned_view;
 
 # shows id and model of all bombardier crj700 planes owned
 SELECT Omodel AS 'Model' ,ownedid AS 'ID' FROM planes_owned_view WHERE OModel="Bombardier CRJ700" ORDER BY ownedID;
 
 