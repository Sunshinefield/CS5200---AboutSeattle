USE AboutSeattle;

# Looking for the most affordable rental neighborhood
SELECT AVG(CompleteTable.Price) AS AveragePrice,CompleteTable.Neighborhood
FROM (
	SELECT HistoricalRental.Price, ZipCodesToNeighborhood.ZipCode, ZipCodesToNeighborhood.Neighborhood
    FROM (
		SELECT ZipCodes.ZipCode AS ZipCode, Crimes.Neighborhood AS Neighborhood
		FROM ZipCodes 
        INNER JOIN Crimes
			ON ZipCodes.Beat = Crimes.Beat) AS ZipCodesToNeighborhood 
		INNER JOIN HistoricalRental 
			ON HistoricalRental.ZipCode = ZipCodesToNeighborhood.ZipCode) AS CompleteTable
GROUP BY CompleteTable.Neighborhood
ORDER BY AveragePrice ASC
LIMIT 1;

#cheapest most diverse neighborhood to live in

SELECT Race, COUNT(*) AS Amount, ZipCode
FROM Residents
GROUP BY Race, ZipCode;

SELECT AVG(CompleteTable.Price) AS AveragePrice,CompleteTable.Neighborhood,CompleteTable.ZipCode
FROM (
	SELECT HistoricalRental.Price, ZipCodesToNeighborhood.ZipCode, ZipCodesToNeighborhood.Neighborhood
    FROM (
		SELECT ZipCodes.ZipCode AS ZipCode, Crimes.Neighborhood AS Neighborhood
		FROM ZipCodes 
        INNER JOIN Crimes
			ON ZipCodes.Beat = Crimes.Beat) AS ZipCodesToNeighborhood 
		INNER JOIN HistoricalRental 
			ON HistoricalRental.ZipCode = ZipCodesToNeighborhood.ZipCode) AS CompleteTable
GROUP BY CompleteTable.Neighborhood, ZipCode
ORDER BY CompleteTable.Price ASC



# Which 5 zipcodes has the cheapest medium rental price in terms of price/sft rental in 2017?


# Which zipcodes are in the range of price $2/sft - $2.5/sft?

# Which 5 zipcodes has the cheapest medium rental price in terms of price/sft rental in 2018 ordered by number of car crisis in ascending order?

# What is the estimated rental price

USE NeighborhoodRecommendationApplication;

# Looking for the most affordable rental neighborhood
SELECT Neighborhood, AVG(Price) AS Price
FROM (
	SELECT Neighborhood, HistoricalRental.ZipCode, HistoricalRental.Price
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

#most diverse neighborhood to live in
SELECT MAX(UpdatedRaceCount + UpdatedAgeCount) AS MAX, Neighborhood
FROM (
	SELECT Race, RaceCount * .80 AS UpdatedRaceCount, Age, AgeCount * .20 AS UpdatedAgeCount, Neighborhood 
	FROM (
		SELECT Race, COUNT(Race) AS RaceCount, Age, COUNT(Age) AS AgeCount, Neighborhood 
		FROM (
			SELECT Race, Age, Neighborhood
			FROM 
				(SELECT Race, ResidentsByRaceAndAge.ZipCode, Age, Beat
				FROM 
					(SELECT Race, ZipCode, Age
					FROM Residents
					ORDER BY  Race, Age ASC) AS ResidentsByRaceAndAge INNER JOIN Beat
						ON ResidentsByRaceAndAge.ZipCode = Beat.ZipCode) AS BeatWithResidentInfo INNER JOIN Crimes
							ON BeatWithResidentInfo.Beat = Crimes.Beat) AS DemographicCount
		GROUP BY Race, Age, Neighborhood
		ORDER BY RaceCount, AgeCount DESC) AS UpdatedTable) AS CurrentTable
GROUP BY Neighborhood
ORDER BY MAX
LIMIT 1;

# largest crime demographic in each neighborhood 
SELECT CrimeSubCat, MAX(CNT) AS MaxAmount, Neighborhood
FROM (
	SELECT CrimeSubCat, COUNT(CrimeSubCat) AS CNT, Neighborhood
	FROM Crimes
	GROUP BY CrimeSubCat, Neighborhood) AS CrimeSubCategories
GROUP BY Neighborhood;

#neighborhood with lowest crime

SELECT COUNT(*) AS CRIMECOUNT, Neighborhood
FROM Crimes
GROUP BY Neighborhood
ORDER BY CRIMECOUNT ASC
LIMIT 1;

# Average age of residents in Neighborhood
SELECT AVG(AVERAGEAGE) AS AverageAge, Neighborhood
FROM 
	(SELECT Beat, AVG(Age) AS AVERAGEAGE
	FROM Beat INNER JOIN Residents
		ON Beat.ZipCode = Residents.ZipCode
	GROUP BY Beat) AS BeatAndAge INNER JOIN Crimes
		ON BeatAndAge.Beat = Crimes.Beat
GROUP BY Neighborhood;

# Has crime decreased from 2000 to 2013



	
