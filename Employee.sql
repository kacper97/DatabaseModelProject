#drop table Employee;

create TABLE Employee (EAirport VARCHAR(50), EmployeeID VARCHAR(20) primary key NOT NULL, EmployeeName VARCHAR(30),
EContract INT(50), EPosition VARCHAR(50), EmployeeDOB date, constraint EMPLOYEE_CK_DOB check (sysDate()-EmployeeDOB>=18),
EmployeeAddress VARCHAR(50), EmployeeGender VARCHAR(1), constraint EMPLOYEE_CK_Gender check (EmployeeGender="M" or EmployeeGender="F")) engine INNODB;


INSERT into Employee values("Dublin", "12345H", "Amy Anderson", 1, "Pilot", '1985-01-01',"Dublin 4, Ireland", "F");
INSERT into Employee values("Dublin", "12346H", "John Anderson", 2, "Pilot", '1985-01-01',"Dublin 2, Ireland", "M");

# Next command won't complete due to DOB being too recent (employee less than 18 years)
#INSERT into Employees values("Dublin", "99999H", "John Nolan", 999, "Pilot", '2004-01-01',"Dublin 2, Ireland", "M");
# Next command won't complete due to incorrect gender value
# INSERT into Employees values("Dublin", "999998H", "Jim Nolan", 998, "Pilot", '1997-01-01',"Dublin 2, Ireland", "H");

select * from Employee;

Alter table Employee add constraint EAirport_FK foreign key (EAirport) references partner_airport (AirportName);
Alter table Employee add constraint EContract_FK foreign key (EContract) references contract (ContractID);
Alter table Employee add constraint EPosition_FK foreign key (EPosition) references employee_position(PositionTitle);