CREATE DEFINER=`root`@`localhost` TRIGGER `cp_kw_airline`.`booking_BEFORE_INSERT` BEFORE INSERT ON `booking` FOR EACH ROW
BEGIN
if(new.NumberInBooking=0) then
signal sqlstate '45000';
end if;
if(new.BookingTotal=0) then
signal sqlstate '45000';
end if;
END