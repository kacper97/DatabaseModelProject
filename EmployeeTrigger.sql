CREATE DEFINER=`root`@`localhost` TRIGGER `cp_kw_airline`.`employees_BEFORE_INSERT` BEFORE INSERT ON `employees` FOR EACH ROW
BEGIN
if(timestampdiff(YEAR,new.EmployeeDOB,sysDate()) <= 18) then
signal sqlstate '45000';
end if;
if(new.EmployeeGender!="M" AND new.EmployeeGender!="F")then
signal sqlstate '45000';
end if;  

END