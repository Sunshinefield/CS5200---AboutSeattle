CREATE SCHEMA IF NOT EXISTS AboutSeattle;
USE AboutSeattle;

DROP TABLE IF EXISTS Residents;
DROP TABLE IF EXISTS Crimes;
DROP TABLE IF EXISTS Beat;
DROP TABLE IF EXISTS RentalForecast;
DROP TABLE IF EXISTS RentalRegistration;
DROP TABLE IF EXISTS HistoricalRental; 
DROP TABLE IF EXISTS Beat;
DROP TABLE IF EXISTS ZipCodes;

CREATE TABLE ZipCodes (
ZipCode INT,
City VARCHAR(100),
County VARCHAR(100),
State VARCHAR(100),
CONSTRAINT pk_ZipCodes_ZipCode
	PRIMARY KEY (ZipCode)
);

CREATE TABLE Beat (
Beat VARCHAR(255) NOT NULL,
Latitude DECIMAL(15,11) NOT NULL,
Longitude DECIMAL(15,11) NOT NULL,
ZipCode INT,
CONSTRAINT pk_Beat_Name
	PRIMARY KEY (Beat),
CONSTRAINT fk_Beat_ZipCode
	FOREIGN KEY (ZipCode)
	REFERENCES ZipCodes(ZipCode)
	ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE HistoricalRental (
ListingId INT AUTO_INCREMENT,
ZipCode INT,
City VARCHAR(255) NOT NULL,
State VARCHAR(255) NOT NULL,
Metro VARCHAR(255) NOT NULL,
County VARCHAR(255) NOT NULL,
Price_2013 DECIMAL(15,10),
Price_2014 DECIMAL(15,10),
Price_2015 DECIMAL(15,10),
Price_2016 DECIMAL(15,10),
Price_2017 DECIMAL(15,10),
Price_2018 DECIMAL(15,10),
CONSTRAINT pk_HistoricalRental_ListingId
	PRIMARY KEY (ListingId),
CONSTRAINT fk_HistoricalRental_ZipCode
	FOREIGN KEY (ZipCode)
    REFERENCES ZipCodes(ZipCode)
    ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE RentalRegistration (
    RegistrationNum VARCHAR(255) NOT NULL,
    RentalUnits INT NOT NULL,
    RegDate DATE,
    ExpDate DATE,
    Status VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(100) NOT NULL,
    ZipCode INT DEFAULT NULL,
    CONSTRAINT pk_CurrentRental_RegistrationNum PRIMARY KEY (RegistrationNum)
);

CREATE TABLE RentalForecast (
	ForecastId INT AUTO_INCREMENT,
    ZipCode INT,
	RunDate Date,
	State VARCHAR(100) NOT NULL,
	Metro VARCHAR(255) NOT NULL,
	County VARCHAR(255) NOT NULL,
	City VARCHAR(255) NOT NULL,
	SizeRank INT,	
	Zri	INT,
	YoY	DECIMAL(15,12),
	ZriRecordCnt INT,
	CONSTRAINT pk_RentalForecast_ForecastId 
		PRIMARY KEY (ForecastId),
	CONSTRAINT fk_RentalForecast_ZipCode 
		FOREIGN KEY (ZipCode)
		REFERENCES ZipCodes(ZipCode)
		ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Crimes(
ReportId BIGINT AUTO_INCREMENT,
ReportedDate DATETIME NOT NULL,
ReportedTime TIMESTAMP,
OccurDate DATE NULL,
CrimeSubCat VARCHAR(255) NOT NULL,
Description LONGTEXT,
Precinct VARCHAR(35) ,
Sector VARCHAR(200) ,
Beat VARCHAR(200),
Neighborhood VARCHAR(255) ,
CONSTRAINT pk_Crimes_ReportId
	PRIMARY KEY (ReportId)
);

CREATE TABLE Residents (
ResidentsId INT AUTO_INCREMENT,
ZipCode INT,
AverageHouseValue INT,
AverageIncome INT,
MedianAge DECIMAL(15,10),
CONSTRAINT pk_Residents_ResidenstId
	PRIMARY KEY (ResidentsId),
CONSTRAINT fk_Residents_ZipCode
	FOREIGN KEY (ZipCode)
    REFERENCES ZipCodes(ZipCode)
    ON UPDATE CASCADE ON DELETE CASCADE
);

LOAD DATA LOCAL INFILE '/Users/Sunshinefield/Documents/NEU MS CS/CS5200 - Database Management/CS5200---AboutSeattle/Zipcodes.csv' INTO TABLE ZipCodes
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;
  
LOAD DATA LOCAL INFILE '/Users/Sunshinefield/Documents/NEU MS CS/CS5200 - Database Management/CS5200---AboutSeattle/Beats.csv' INTO TABLE Beat
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;
  
LOAD DATA LOCAL INFILE '/Users/Sunshinefield/Documents/NEU MS CS/CS5200 - Database Management/CS5200---AboutSeattle/RentalRegistration.csv' INTO TABLE RentalRegistration
  FIELDS TERMINATED BY ',' ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (  RegistrationNum,  RentalUnits, @RegDate,  @ExpDate, Status, Address, City, State, @ZipCode)
  set RegDate = STR_TO_DATE(@RegDate, '%m/%d/%Y'),
      ExpDate = STR_TO_DATE(@ExpDate, '%m/%d/%Y'),
      ZipCode = if(@ZipCode = 0, 0, @ZipCode);
  
LOAD DATA LOCAL INFILE '/Users/Sunshinefield/Documents/NEU MS CS/CS5200 - Database Management/CS5200---AboutSeattle/RentalPricePerSqft.csv' INTO TABLE HistoricalRental
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (ZipCode,
	City,
	State,
	Metro,
	County,
	Price_2013,
	Price_2014,
	Price_2015,
	Price_2016,
	Price_2017,
	Price_2018)
  SET ListingId = NULL;
  

    
LOAD DATA LOCAL INFILE '/Users/Sunshinefield/Documents/NEU MS CS/CS5200 - Database Management/CS5200---AboutSeattle/RentalForecast.csv' INTO TABLE RentalForecast
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  ( 
    ZipCode,
	@RunDate,
	State,
	Metro,
	County,
	City,
	SizeRank,	
	Zri,
	YoY,
	ZriRecordCnt)
  SET ForecastId = NULL,
    RunDate = STR_TO_DATE(@RunDate, '%m/%d/%Y');

LOAD DATA LOCAL INFILE '/Users/Sunshinefield/Documents/NEU MS CS/CS5200 - Database Management/CS5200---AboutSeattle/Crime_Data.csv' INTO TABLE Crimes
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (@col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11) 
  SET ReportId=@col1,ReportedDate=if(@col4 = '', NULL, STR_TO_DATE( @col4, '%m/%d/%Y')),
  ReportedTime=NULL,
  OccurDate=if(@col2 = '', NULL, STR_TO_DATE( @col2, '%m/%d/%Y')),
  CrimeSubCat=@col5,Description=@col6,Precinct=@col7,Sector=@col8,Beat=@col9,Neighborhood=@col10,
  ReportId=NULL
  ;

LOAD DATA LOCAL INFILE '/Users/Sunshinefield/Documents/NEU MS CS/CS5200 - Database Management/CS5200---AboutSeattle/Residents.csv' INTO TABLE Residents
  FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (ZipCode,
	AverageHouseValue,
	AverageIncome,
	MedianAge)
  SET ResidentsId=NULL;
 
 
 