CREATE DEFINER=`root`@`localhost` TRIGGER `cp_kw_airline`.`employeeposition_BEFORE_INSERT` BEFORE INSERT ON `employeeposition` FOR EACH ROW
BEGIN
if (new.OvertimeAllowed!="Y" AND new.OvertimeAllowed!="N")then
signal sqlstate '45000';
end if;
if (new.wageRate<9.15)then
signal sqlstate '45000';
end if;
END