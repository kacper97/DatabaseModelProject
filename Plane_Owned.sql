#drop table plane_owned;
 create TABLE PLANE_OWNED (PAirport VARCHAR(50),OwnedID INT(50) primary key NOT NULL, OModel VARCHAR(20), PlaneManufacDate DATE, 
 constraint PLANE_CK_PMDate check (PlaneManufacDate>'1974-01-01'  AND PlaneManufacDate< sysdate()),PurchaseDate DATE,  
 constraint PLANE_CK_PDate check (PurchaseDate > PlaneManufacDate AND PurchaseDate< sysdate()),
TotalHours INT(50), TotalCycles INT(50), PurchaseCost DOUBLE, FirstMaintenanceDate DATE,
constraint PLANE_CK_FMDate check (FirstMaintenanceDate>PurchaseDate AND FirstMaintenanceDate<= sysdate())) engine INNODB;

INSERT into PLANE_OWNED values ("Dublin", 1, "Boeing 777",'1980-01-01','2010-01-01', 20000,20000,320200000,'2010-05-03');
INSERT into PLANE_OWNED values ("Dublin", 2, "Boeing 776",'1980-01-01','2010-01-01', 20000,20000,320200000,'2010-05-03');

alter table plane_owned add constraint PAirport_FK foreign key (PAirport) references partner_airport(AirportName);
alter table plane_owned add constraint OModel_FK foreign key (OModel) references plane_model(ModelID);

SELECT * FROM Plane_owned;