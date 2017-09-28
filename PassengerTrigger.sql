CREATE DEFINER=`root`@`localhost` TRIGGER `cp_kw_airline`.`passenger_BEFORE_INSERT` BEFORE INSERT ON `passenger` FOR EACH ROW
BEGIN
if(new.Gender!="M" AND new.Gender!="F")then
signal sqlstate '45000';
end if;
if(new.DateOfBirth>sysDate()) then
signal sqlstate '45000';
end if;
END