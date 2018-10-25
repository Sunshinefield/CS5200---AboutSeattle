CREATE SCHEMA IF NOT EXISTS AboutSeattle;
USE AboutSeattle;

DROP TABLE IF EXISTS Residents;
DROP TABLE IF EXISTS Crimes;
DROP TABLE IF EXISTS RentalForecast;
DROP TABLE IF EXISTS Beat;
DROP TABLE IF EXISTS CurrentRental;
DROP TABLE IF EXISTS HistoricalRental;
DROP TABLE IF EXISTS Residence; 
DROP TABLE IF EXISTS PropertyName;
DROP TABLE IF EXISTS LandUsePermit;
DROP TABLE IF EXISTS BuildingPermit;
DROP TABLE IF EXISTS Permits;
DROP TABLE IF EXISTS Beat;
DROP TABLE IF EXISTS ZipCodes;

CREATE TABLE ZipCodes (
ZipCode INT NOT NULL,
City VARCHAR(100),
County VARCHAR(100),
State VARCHAR(2),
CONSTRAINT pk_ZipCodes_ZipCode
	PRIMARY KEY (ZipCode)
);

-- CREATE TABLE Permits (
-- PermitId INT NOT NULL,
-- Category ENUM('COMMERCIAL','INDUSTRIAL','INSTITUTIONAL','MULTIFAMILY','SINGLE FAMILY/DUPLEX'),
-- Latitude DECIMAL,
-- Longitude DECIMAL,
-- Zipcode INT NOT NULL,
-- Description LONGTEXT NOT NULL,
-- PermitDetails LONGTEXT NOT NULL,
-- Value INT NOT NULL,
-- Applicant VARCHAR(255) NOT NULL,
-- ApplicationDate DATE NOT NULL,
-- IssueDate DATE NOT NULL,
-- Status VARCHAR(255) NOT NULL,
-- Contractor VARCHAR(255) NOT NULL,
-- CONSTRAINT pk_Permits_PermitId
-- 	PRIMARY KEY (PermitId),
-- CONSTRAINT fk_Permits_Location
-- 	FOREIGN KEY (Zipcode)
--     REFERENCES ZipCodes(Zipcode)
--     ON UPDATE CASCADE ON DELETE SET NULL
-- );

CREATE TABLE Beat (
Beat VARCHAR(255) NOT NULL,
Latitude DECIMAL NOT NULL,
Longitude DECIMAL NOT NULL,
ZipCode INT,
CONSTRAINT pk_Beat_Name
	PRIMARY KEY (Beat),
CONSTRAINT fk_Beat_ZipCode
	FOREIGN KEY (ZipCode)
    REFERENCES ZipCodes(ZipCode)
    ON UPDATE CASCADE ON DELETE SET NULL
);

-- CREATE TABLE LandUsePermit (
-- PermitId INT NOT NULL,
-- LandUsePermitType VARCHAR(255) NOT NULL,
-- DecisionType ENUM('I','II','III','IV','V'),
-- DecisionReview BOOLEAN,
-- DecisionDate DATE NOT NULL,
-- CONSTRAINT pk_LandUsePermit_PermitId
-- 	PRIMARY KEY (PermitId),
-- CONSTRAINT fk_LandUsePermit_PermitId
-- 	FOREIGN KEY (PermitId)
--     REFERENCES Permits(PermitId)
--     ON UPDATE CASCADE ON DELETE CASCADE
-- );
-- 
-- CREATE TABLE BuildingPermit (
-- PermitId INT NOT NULL,
-- BuildingPermitType ENUM('CONSTRUCTION','DEMOLITION','SITE DEVELOPMENT'),
-- ActionType VARCHAR(255) NOT NULL,
-- PlanReview BOOLEAN,
-- FinalDate DATE NOT NULL,
-- ExpirationDate DATE NOT NULL,
-- CONSTRAINT pk_BuildingPermit_PermitId
-- 	PRIMARY KEY (PermitId),
-- CONSTRAINT fk_BuildingPermit_PermitId
-- 	FOREIGN KEY (PermitId)
--     REFERENCES Permits(PermitId)
--     ON UPDATE CASCADE ON DELETE CASCADE
-- );


CREATE TABLE PropertyName (
PropertyId INT NOT NULL,
PropertyName VARCHAR(255) NOT NULL,
PropertyManager VARCHAR(255) NOT NULL,
CONSTRAINT pk_PropertyName_PropertyId
	PRIMARY KEY (PropertyId),
CONSTRAINT uk_PropertyName_PropertyName
	UNIQUE KEY (PropertyName)
);

CREATE TABLE CurrentRental ( #this refers to current and future residental forecasts
RegistrationNum INT NOT NULL,
RentalUnits INT NOT NULL,
PropertyName VARCHAR(255) NOT NULL,
Status VARCHAR(255) NOT NULL,
Address VARCHAR(255) NOT NULL,
City VARCHAR(255) NOT NULL,
State VARCHAR(255) NOT NULL,
Latitude DECIMAL NOT NULL,
Longitude DECIMAL NOT NULL,
ZipCode INT NOT NULL,
PropertyContact VARCHAR(255) NOT NULL,
CONSTRAINT pk_CurrentRental_RegistrationNum
	PRIMARY KEY (RegistrationNum),
CONSTRAINT fk_CurrentRental_PropertyName
	FOREIGN KEY (PropertyName)
    REFERENCES PropertyName(PropertyName)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE HistoricalRental (
ListingId INT NOT NULL,
PropertyType ENUM('APARTMENT','HOUSE','TOWNHOUSE','CONDO/CO-OP'),
Address VARCHAR(255) NOT NULL,
City VARCHAR(255) NOT NULL,
State VARCHAR(255) NOT NULL,
Price INT NOT NULL,
Sqf INT NOT NULL,
PriceSqf DECIMAL NOT NULL,
ZipCode INT NOT NULL,
CONSTRAINT pk_HistoricalRental_ListingId
	PRIMARY KEY (ListingId),
CONSTRAINT fk_HistoricalRental_ZipCode
	FOREIGN KEY (ZipCode)
    REFERENCES ZipCodes(ZipCode)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- CREATE TABLE RentalForecast (
-- 	RunDate Date,
--     RegionName INT NOT NULL,
--     State VARCHAR(2) NOT NULL,
--     Metro VARCHAR(255) NOT NULL,
--     County VARCHAR(255) NOT NULL,
--     City VARCHAR(255) NOT NULL,
--     SizeRank INT,	
--     Zri	INT,
--     MoM	DECIMAL,
--     QoQ	DECIMAL,
--     YoY	DECIMAL,
--     ZriRecordCnt INT,
--     CONSTRAINT pk_RentalForecast_RegionName 
-- 		PRIMARY KEY (RegionName),
--     CONSTRAINT fk_RentalForecast_RegionName 
-- 		FOREIGN KEY (RegionName)
-- 		REFERENCES ZipCodes(ZipCode)
--         ON UPDATE CASCADE ON DELETE SET NULL
-- );

CREATE TABLE Crimes(
ReportId BIGINT AUTO_INCREMENT,
ReportedDate DATETIME NOT NULL,
ReportedTime TIMESTAMP,
OccurDate DATE NOT NULL,
CrimeSubCat VARCHAR(255) NOT NULL,
Description LONGTEXT,
Precinct VARCHAR(35) NOT NULL,
Sector CHAR NOT NULL,
Beat VARCHAR(10),
Neighborhood VARCHAR(255) NOT NULL,
CONSTRAINT pk_Crimes_ReportId
	PRIMARY KEY (ReportId),
CONSTRAINT fk_Crimes_Beat
	FOREIGN KEY (Beat)
    REFERENCES Beat(Beat)
    ON UPDATE CASCADE ON DELETE SET NULL #beats get edited all the time and I don't want the crime to disappear just because where it took place has changed.
);

CREATE TABLE Residents (
ResidentsId INT NOT NULL,
Name VARCHAR(255) NOT NULL,
Age VARCHAR(255) NOT NULL,
Race VARCHAR(255) NOT NULL,
Address VARCHAR(255) NOT NULL,
ZipCode INT NOT NULL,
CONSTRAINT pk_Residents_ResidenstId
	PRIMARY KEY (ResidentsId),
CONSTRAINT fk_Residents_ZipCode
	FOREIGN KEY (ZipCode)
    REFERENCES ZipCodes(ZipCode)
    ON UPDATE CASCADE ON DELETE CASCADE
);


   LOAD DATA LOCAL INFILE 'Users/Sunshinefield/Documents/NEU MS CS/CS5200 - Database Management/CS5200---AboutSeattle/Zipcodes.csv' INTO TABLE ZipCodes
  # Fields are not quoted. Windows platforms may need '\r\n'.
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
	(@col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10) 
  SET ZipCode=@col5,Latitude=@col3,Longitude=@col4;
  
  LOAD DATA LOCAL INFILE '/Users/Goch/Desktop/Beats.csv' INTO TABLE Beat
  # Fields are not quoted.
  FIELDS TERMINATED BY ','
  # Windows platforms may need '\r\n'.#  # Windows platforms may need '\r\n'.
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (@col1,@col2,@col3,@col4,@col5) 
  SET Beat=@col1,Latitude=@col3,Longitude=@col4,ZipCode=@col5;
  
--   LOAD DATA LOCAL INFILE '/Users/Goch/Desktop/Permits.csv' INTO TABLE Permits
--   # Fields are not quoted.
--   FIELDS TERMINATED BY ','
--   LINES TERMINATED BY '\n'
--   IGNORE 1 LINES;         
--   
--   LOAD DATA LOCAL INFILE '/Users/Goch/Desktop/LandUsePermit.csv' INTO TABLE LandUsePermits
--   # Fields are not quoted.
--   FIELDS TERMINATED BY ','
--   LINES TERMINATED BY '\n'
--   IGNORE 1 LINES;
--     
--   LOAD DATA LOCAL INFILE '/Users/Goch/Desktop/PropertyName.csv' INTO TABLE PropertyName
--   # Fields are not quoted.
--   FIELDS TERMINATED BY ','
--   LINES TERMINATED BY '\n'
--   IGNORE 1 LINES;
  
	LOAD DATA LOCAL INFILE '/Users/Goch/Desktop/CurrentRental.csv' INTO TABLE CurrentRental
  # Fields are not quoted.
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;
  
   LOAD DATA LOCAL INFILE '/Users/Goch/Desktop/HistoricalRental.csv' INTO TABLE HistoricalRental
  # Fields are not quoted.
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/Goch/Desktop/Crime_Data.csv' INTO TABLE Crimes
  # Fields are not quoted.
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (@col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11) 
  SET ReportId=@col1,ReportedDate=@col4,ReportedTime=@col5,OccurDate=@col2,CrimeSubCat=@col6,Description=@col7,Precinct=@col8,Sector=@col9,Beat=@col10,Neighborhood=@col11;
  
  LOAD DATA LOCAL INFILE '/Users/Goch/Desktop/Residents.csv' INTO TABLE Residents
  # Fields are not quoted.
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;
 
  
 
 
  
 