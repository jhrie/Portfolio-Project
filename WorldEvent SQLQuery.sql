--Exploring datasets--
SELECT *
FROM 
	WorldEvents.dbo.tblCategory
JOIN WorldEvents.dbo.tblContinent
	ON tblCategory.CategoryID = tblContinent.ContinentID
WHERE ContinentID IS NOT NULL
SELECT *
FROM WorldEvents.dbo.tblEvent
SELECT *
FROM WorldEvents.dbo.tblCountry



--I am searching for the most recent event--
--The latest event in this dataset occurred in 2016--

SELECT TOP 4
	tc.ContinentID,
	tc.CountryName,
	te.EventDate,
	te.EventName,
	te.EventDetails
FROM
	WorldEvents.dbo.tblCountry tc
JOIN WorldEvents.dbo.tblEvent te
	ON tc.CountryID = te.CountryID
ORDER BY te.EventDate DESC


--Exploring how the landscape of events has evolved over the years--

SELECT 
	YEAR(EventDate) AS EventYear,
	COUNT(EventID) AS EventCount
FROM 
	WorldEvents.dbo.tblEvent
GROUP BY 
	YEAR(EventDate)
ORDER BY
	EventYear


--Looking for event in ASIA--
--I am looking for events in Asia, excluding Australasia, as it has been unintentionally included in the table, and I specifically want to focus on the Asian continent.--
--Here, I added the condition AND tco.ContinentName <> 'Australasia' to exclude the "Australasia" region.--

SELECT 
	tca.CategoryID,
	tco.ContinentID,
	tco.ContinentName,
	tc.CountryName,
	te.EventDate,
	te.EventName,
	te.EventDetails
FROM
	WorldEvents.dbo.tblCategory tca
JOIN WorldEvents.dbo.tblContinent tco
	ON tca.CategoryID = tco.ContinentID
JOIN WorldEvents.dbo.tblCountry tc
	ON tco.ContinentID = tc.ContinentID
JOIN WorldEvents.dbo.tblEvent te
	ON tc.CountryID = te.CountryID
WHERE 
	tco.ContinentName LIKE '%Asia%'
  AND tco.ContinentName <> 'Australasia'


--I want to determine the count of events for each category--
	
SELECT 
    tce.CategoryID,
    tce.CategoryName,
    COUNT(te.EventID) AS EventCount
FROM
    WorldEvents.dbo.tblCategory tce
JOIN WorldEvents.dbo.tblEvent te
    ON tce.CategoryID = te.CategoryID
GROUP BY
    tce.CategoryID,
    tce.CategoryName
ORDER BY 
	EventCount DESC


--Explore the geographic distribution of events. Which continents or countries have the highest number of events?--

SELECT 
	tco.ContinentID,
	tco.ContinentName,
	tc.CountryName,
	COUNT(te.CountryID) AS EventCount
FROM 
	WorldEvents.dbo.tblContinent tco
JOIN WorldEvents.dbo.tblCountry tc
	ON tco.ContinentID = tc.ContinentID
JOIN WorldEvents.dbo.tblEvent te
	ON tc.CountryID = te.CountryID
GROUP BY 
	tco.ContinentID,
	tco.ContinentName,
	tc.CountryName
ORDER BY 
	EventCount DESC


--Investigate if certain categories are more prevalent in specific continents. Are there any interesting patterns or correlations?--

SELECT 
	tco.ContinentName,
	tce.CategoryName,
	COUNT(te.EventID) AS CategoryInfluence
FROM
	WorldEvents.dbo.tblContinent tco
JOIN WorldEvents.dbo.tblCountry tc
	ON tco.ContinentID = tc.ContinentID
JOIN WorldEvents.dbo.tblEvent te
	ON tc.CountryID = te.CountryID
JOIN WorldEvents.dbo.tblCategory tce
	ON te.CategoryID = tce.CategoryID
GROUP BY 
	tco.ContinentName,
	tce.CategoryName
ORDER BY
	tco.ContinentName,
	CategoryInfluence DESC





