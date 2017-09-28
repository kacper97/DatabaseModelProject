drop table planes_owned;
 create TABLE PLANES_OWNED (PAirport VARCHAR(50),OwnedID INT(50) primary key, OModel VARCHAR(20), PlaneManufacDate DATE, 
 constraint PLANE_CK_PMDate check (PlaneManufacDate>'1974-01-01'),PurchaseDate DATE,  
 constraint PLANE_CK_PDate check (PurchaseDate > PlaneManufacDate AND PurchaseDate< sysdate()),
TotalHours INT(50), TotalCycles INT(50), PurchaseCost DOUBLE, FirstMaintenanceDate DATE,
constraint PLANE_CK_FMDate check (FirstMaintenanceDate>PurchaseDate AND FirstMaintenanceDate<= sysdate())) engine INNODB;

INSERT into PLANES_OWNED values ("Dublin", 6, "Boeing 777",'1980-01-01','2010-01-01', 44000,40000,320200000,'2010-05-03');

INSERT into PLANES_OWNED values ("Dublin", 2, "Boeing 777",'1960-01-01','2010-01-01', 44000,40000,320200000,'2010-05-03');
INSERT into PLANES_OWNED values ("Dublin", 3, "Boeing 777",'1980-01-01','1970-01-01', 44000,40000,320200000,'2010-05-03');
INSERT into PLANES_OWNED values ("Dublin", 3, "Boeing 777",'1980-01-01','2020-01-01', 44000,40000,320200000,'2010-05-03');
INSERT into PLANES_OWNED values ("Dublin", 4, "Boeing 777",'1950-01-01','2020-01-01', 44000,40000,320200000,'2010-05-03');

SELECT * FROM Planes_owned;