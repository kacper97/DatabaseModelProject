#drop table Contract;

create Table Contract (ContractID INT(50) primary key NOT NULL, ContractStart date, constraint Contract_ck_startDate check (ContractStart <= sysDate()), 
ContractEnd date, constraint Contract_ck_endDate check (ContractEnd > ContractStart AND ContractEnd>SysDate()), ContractMinHours double)engine INNODB;

insert into Contract values(1,'2002-01-01', '2020-02-02', 40);
insert into Contract values(2,'2002-01-01', '2020-02-02', 40);

# Next insert won't complete due to ContractStart being later than todays date 
#insert into Contract values(999,'2032-01-01', '2033-02-02', 40);
# Next insert won't complete due to ContractEnd being before ContractStart
#insert into Contract values(999,'2002-01-01', '2000-02-02', 40);
# Next insert won't complete due to ContractEnd being before todays date
#insert into Contract values(999,'2001-01-01', '2003-02-02', 40);