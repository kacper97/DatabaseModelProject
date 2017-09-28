CREATE DEFINER=`root`@`localhost` TRIGGER `cp_kw_airline`.`planes_owned_BEFORE_INSERT` BEFORE INSERT ON `planes_owned` FOR EACH ROW
BEGIN
if (new.PlaneManufacDate < '1974-01-01') then
signal sqlstate '45000';
end if;
if (new.PurchaseDate > new.PlaneManufacDate OR new.PurchaseDate< sysdate()) then
signal sqlstate '45000';
end if;
END