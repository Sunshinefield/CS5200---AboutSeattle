USE NeighborhoodRecommendationApplication;

# Looking for the most affordable rental neighborhood
SELECT AVG(CompleteTable.Price) AS AveragePrice,CompleteTable.Neighborhood
FROM (
	SELECT HistoricalRental.Price, ZipCodesToNeighborhood.ZipCode, ZipCodesToNeighborhood.Neighborhood
    FROM (
	SELECT ZipCodes.ZipCode AS ZipCode, Crimes.Neighborhood AS Neighborhood
	FROM ZipCodes INNER JOIN Crimes
		ON ZipCodes.Beat = Crimes.Beat AS ZipCodesToNeighborhood INNER JOIN
        HistoricalRental ON HistoricalRental.ZipCode = ZipCodesToNeighborhood.ZipCode) AS CompleteTable
)
GROUP BY CompleteTable.Neighborhood
ORDER BY AveragePrice ASC
LIMIT 1;

#cheapest most diverse neighborhood to live in

(SELECT Race, COUNT(*) AS Amount, ZipCode
FROM Residents
GROUP BY Race, ZipCode) AS RacialDemographicsByZipCode

SELECT AVG(CompleteTable.Price) AS AveragePrice,CompleteTable.Neighborhood,CompleteTable.ZipCode
FROM (
	SELECT HistoricalRental.Price, ZipCodesToNeighborhood.ZipCode, ZipCodesToNeighborhood.Neighborhood
    FROM (
	(SELECT ZipCodes.ZipCode AS ZipCode, Crimes.Neighborhood AS Neighborhood
	FROM ZipCodes INNER JOIN Crimes
		ON ZipCodes.Beat = Crimes.Beat) AS ZipCodesToNeighborhood INNER JOIN
        HistoricalRental ON HistoricalRental.ZipCode = ZipCodesToNeighborhood.ZipCode) AS CompleteTable
)
GROUP BY CompleteTable.Neighborhood, ZipCode
ORDER BY CompleteTable.Price ASC

	