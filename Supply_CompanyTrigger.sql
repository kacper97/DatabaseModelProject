CREATE DEFINER=`root`@`localhost` TRIGGER `cp_kw_airline`.`supply_companies_BEFORE_INSERT` BEFORE INSERT ON `supply_companies` FOR EACH ROW
BEGIN
if (new.DeliveryDaySchedule!="Monday" and new.DeliveryDaySchedule!="Tuesday" and new.DeliveryDaySchedule!="Wednesday" and new.DeliveryDaySchedule!="Thursday"  and new.DeliveryDaySchedule!="Friday"  and new.DeliveryDaySchedule!="Saturday" and new.DeliveryDaySchedule!="Sunday"  )then
signal sqlstate '45000';
end if;
END