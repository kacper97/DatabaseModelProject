 # drop table plane_model;
 create TABLE PLANE_MODEL (ModelID VARCHAR(20)primary key,EngineSize DOUBLE, MaxHours INT(50), MaxCycles INT(50), MinRunwayLength DOUBLE, 
 Capacity INT(5), NumExits INT(2),Weight DOUBLE);

 
INSERT into plane_model values("Boeing 777", 110000, 44000, 40000, 1678, 396, 8, 135600);
INSERT into plane_model values("Boeing 776", 112000, 44000, 40000, 1676, 396, 8, 135600);
Insert into plane_model values ("Airbus A300 B2", 105000,  67000, 30000, 2701, 180, 4, 73500);
Insert into plane_model values ("Airbus A300 B4", 120000,  66000, 28000, 2721, 200, 6, 80000);
Insert into plane_model values ("Concorde", 100000,  70000, 32000, 3061, 100, 6, 78700);
Insert into plane_model values ("Beechcraft 1900D", 2558,  30000, 18000, 1035, 19, 2, 7530);

 
 SELECT * from plane_model;