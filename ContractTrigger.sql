CREATE DEFINER=`root`@`localhost` TRIGGER `cp_kw_airline`.`contract_BEFORE_INSERT` BEFORE INSERT ON `contract` FOR EACH ROW
BEGIN

if (new.ContractStart>=SysDate()) then
signal sqlstate '45000';
end if;

if(new.ContractStart>=new.ContractEnd OR new.ContractEnd<SysDate())then
signal sqlstate '45000';
end if;
END