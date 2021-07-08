USE AboutSeattle;


SELECT * FROM BEAT;
SELECT * FROM HistoricalRental;
SELECT * FROM RentalForecast;
SELECT * FROM RentalRegistration;
SELECT * FROM Crimes;
SELECT * FROM ZipCodes;
SELECT * FROM Residents;

-- 732 row(s) affected, 64 warning(s): 1265 Data truncated for column 'State' at row 1 1265 Data truncated for column 'State' at row 2 1265 Data truncated for column 'State' at row 3 1265 Data truncated for column 'State' at row 4 1265 Data truncated for column 'State' at row 5 1265 Data truncated for column 'State' at row 6 1265 Data truncated for column 'State' at row 7 1265 Data truncated for column 'State' at row 8 1265 Data truncated for column 'State' at row 9 1265 Data truncated for column 'State' at row 10 1265 Data truncated for column 'State' at row 11 1265 Data truncated for column 'State' at row 12 1265 Data truncated for column 'State' at row 13 1265 Data truncated for column 'State' at row 14 1265 Data truncated for column 'State' at row 15 1265 Data truncated for column 'State' at row 16 1265 Data truncated for column 'State' at row 17 1265 Data truncated for column 'State' at row 18 1265 Data truncated for column 'State' at row 19 1265 Data truncated for column 'State' at row 20 1265 Data truncated for column 'State' at row 21 1265 Data truncated for column 'State' at row 22 1265 Data truncated for column 'State' at row 23 1265 Data truncated for column 'State' at row 24 1265 Data truncated for column 'State' at row 25 1265 Data truncated for column 'State' at row 26 1265 Data truncated for column 'State' at row 27 1265 Data truncated for column 'State' at row 28 1265 Data truncated for column 'State' at row 29 1265 Data truncated for column 'State' at row 30 1265 Data truncated for column 'State' at row 31 1265 Data truncated for column 'State' at row 32 1265 Data truncated for column 'State' at row 33 1265 Data truncated for column 'State' at row 34 1265 Data truncated for column 'State' at row 35 1265 Data truncated for column 'State' at row 36 1265 Data truncated for column 'State' at row 37 1265 Data truncated for column 'State' at row 38 1265 Data truncated for column 'State' at row 39 1265 Data truncated for column 'State' at row 40 1265 Data truncated for column 'State' at row 41 1265 Data truncated for column 'State' at row 42 1265 Data truncated for column 'State' at row 43 1265 Data truncated for column 'State' at row 44 1265 Data truncated for column 'State' at row 45 1265 Data truncated for column 'State' at row 46 1265 Data truncated for column 'State' at row 47 1265 Data truncated for column 'State' at row 48 1265 Data truncated for column 'State' at row 49 1265 Data truncated for column 'State' at row 50 1265 Data truncated for column 'State' at row 51 1265 Data truncated for column 'State' at row 52 1265 Data truncated for column 'State' at row 53 1265 Data truncated for column 'State' at row 54 1265 Data truncated for column 'State' at row 55 1265 Data truncated for column 'State' at row 56 1265 Data truncated for column 'State' at row 57 1265 Data truncated for column 'State' at row 58 1265 Data truncated for column 'State' at row 59 1265 Data truncated for column 'State' at row 60 1265 Data truncated for column 'State' at row 61 1265 Data truncated for column 'State' at row 62 1265 Data truncated for column 'State' at row 63 1265 Data truncated for column 'State' at row 64 Records: 732  Deleted: 0  Skipped: 0  Warnings: 731


# Looking for the most affordable rental neighborhood
SELECT AVG(CompleteTable.Price_2018) AS AveragePrice,CompleteTable.Neighborhood
FROM (
	SELECT HistoricalRental.Price_2018, ZipCodesToNeighborhood.ZipCode, ZipCodesToNeighborhood.Neighborhood
    FROM (
		SELECT Beat.ZipCode AS ZipCode, Crimes.Neighborhood AS Neighborhood
		FROM Beat 
        INNER JOIN Crimes
			ON Beat.Beat = Crimes.Beat) AS ZipCodesToNeighborhood 
		INNER JOIN HistoricalRental 
			ON HistoricalRental.ZipCode = ZipCodesToNeighborhood.ZipCode) AS CompleteTable
GROUP BY CompleteTable.Neighborhood
ORDER BY AveragePrice ASC
LIMIT 1;

# second lowest income neighborhood to live in

SELECT *
FROM Residents
ORDER BY AverageIncome LIMIT 2,1;


#Find the safest zipcodes with lower price
SELECT AVG(CompleteTable.Price) AS AveragePrice, COUNT(*) AS CrimeCNT, CompleteTable.Neighborhood,CompleteTable.ZipCode
FROM (
	SELECT HistoricalRental.Price_2018 as Price, ZipCodesToNeighborhood.ZipCode, ZipCodesToNeighborhood.Neighborhood
    FROM (
		SELECT Beat.ZipCode AS ZipCode, Crimes.Neighborhood AS Neighborhood
		FROM Beat 
        RIGHT JOIN Crimes
			ON Beat.Beat = Crimes.Beat) AS ZipCodesToNeighborhood 
		INNER JOIN HistoricalRental 
			ON HistoricalRental.ZipCode = ZipCodesToNeighborhood.ZipCode) AS CompleteTable
GROUP BY CompleteTable.Neighborhood, ZipCode
ORDER BY CrimeCNT ASC, AveragePrice ASC;



# Which 5 zipcodes has the cheapest medium rental price in terms of price/sft rental in 2017?
SELECT ZipCode, Price_2017
FROM HistoricalRental
ORDER BY Price_2017 
LIMIT 5;


# Which zipcodes are in the range of price $2/sft - $2.5/sft in 2018?
SELECT ZipCode, Price_2018
FROM HistoricalRental
WHERE Price_2018 < 2.5 
AND Price_2018 > 2;

# Which 5 zipcodes has the cheapest medium rental price in terms of price/sft rental in 2018 ordered by number of car crisis in ascending order?
SELECT ZipCode, AVG(FINAL.Price_2018 ) AS Price, count(*) as CRIMECNT, CrimeSubCat
	FROM (
		 SELECT Price_2018, CrimeSubCat, ZipNeighbors.ZipCode FROM (SELECT Beat.ZipCode AS ZipCode, Crimes.CrimeSubCat
		FROM Crimes INNER JOIN Beat
			ON Crimes.Beat = Beat.Beat
            Where Crimes.CrimeSubCat = 'CAR PROWL') AS ZipNeighbors
		INNER JOIN HistoricalRental
			ON HistoricalRental.ZipCode = ZipNeighbors.ZipCode) AS FINAL
	GROUP BY ZipCode, CrimeSubCat
    ORDER BY Price, CRIMECNT
    LIMIT 5;
    
            
# What is the estimated rental price in 2019 for 98004?

SELECT HR.Price_2018 * (YoY + 1)  as Price_2019, RF.ZipCode FROM RentalForecast RF inner join HistoricalRental HR on RF.ZipCode = HR.ZipCode
WHERE RF.ZipCode = 98004;


# Looking for the most affordable rental neighborhood in 2018
SELECT Neighborhood, AVG(Price) AS Price
FROM (
	SELECT Neighborhood, HistoricalRental.ZipCode, HistoricalRental.Price_2018 as Price
	FROM (
		(SELECT Crimes.Neighborhood AS Neighborhood, Beat.ZipCode AS ZipCode
		FROM Crimes INNER JOIN Beat
			ON Crimes.Beat = Beat.Beat) AS ZipNeighbors
		INNER JOIN HistoricalRental
			ON HistoricalRental.ZipCode = ZipNeighbors.ZipCode)
            ) AS Aggregation
GROUP BY Neighborhood
ORDER BY Price ASC
LIMIT 1;

#most young community to live in
SELECT ZipCode FROM Residents order by MedianAge LIMIT 1;
-- 

#  crime demographic rank in each neighborhood 
 SELECT CrimeSubCat, Neighborhood, CNT,
   @CrimeSubCat:=CASE WHEN @Neighborhood <> Neighborhood THEN 0 ELSE @CrimeSubCat+1 END AS rn,
   @Neighborhood:=Neighborhood AS clset
FROM
  (SELECT @CrimeSubCat:= -1) s,
  (SELECT @Neighborhood:= -1) c,
  (SELECT *
   FROM (SELECT CrimeSubCat, COUNT(CrimeSubCat) AS CNT, Neighborhood
 	FROM Crimes
 	GROUP BY CrimeSubCat, Neighborhood) AS CrimeSubCategories
   ORDER BY Neighborhood, CNT desc
  ) t;

#neighborhood with lowest crime
SELECT COUNT(*) AS CRIMECOUNT, Neighborhood
FROM Crimes
WHERE Neighborhood <> 'UNKNOWN'
GROUP BY Neighborhood
ORDER BY CRIMECOUNT ASC
LIMIT 1;
 



	
