CREATE DEFINER=`root`@`localhost` TRIGGER `cp_kw_airline`.`scheduled_flights_BEFORE_INSERT` BEFORE INSERT ON `scheduled_flights` FOR EACH ROW
BEGIN
 if new.departTime<sysDate()then
 signal sqlstate '45000';
 end if;
 if new.arrivalTime<new.departTime then
signal sqlstate '45000';
end if;
if new.Duration<=0 then
signal sqlstate '45000';
end if;
 if (new.MealType!="Breakfast" and new.MealType!="Lunch" and new.MealType!="Dinner")then
 signal sqlstate '45000';
 end if;
 if((timestampdiff(Minute,new.DepartTime,new.ArrivalTime)) != (new.Duration*60))then
 signal sqlstate '45000';
 end if;
 
END