#drop table Employee_Position;

create table Employee_Position (PositionTitle VARCHAR(50) primary key NOT NULL, OvertimeAllowed VARCHAR(1), 
constraint EMPLOYEEPOS_CK_OTALL check (OvertimeAllowed="Y" or OvertimeAllowed="N"), wageRate DOUBLE, constraint EMPLOYEEPOS_CK_Wage 
check (wageRate>= 9.15))engine INNODB;

insert into Employee_position values("Pilot", "N", 12);

# Next command doesn't complete because value for OvertimeAllowed is not Y or N
# insert into Employeeposition values("Not Employed", "K", 12);
# Next command doesn't complete because wageRate is less than the minimum wage in Ireland 9.15
# insert into Employeeposition values("Not Employed", "Y", 8);