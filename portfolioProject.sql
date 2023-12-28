*/ Exploring Covid-19 Dataset */

select *
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject.dbo.CovidVaccinations
--order by 3,4

--select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2

--Looking at total cases vs total deaths

SELECT
    location,
    date,
    total_cases,
    total_deaths,
    CASE
        WHEN TRY_CAST(total_cases AS float) <> 0
        THEN TRY_CAST(total_deaths AS float) / TRY_CAST(total_cases AS float)*100
        ELSE NULL
    END AS death_rate
FROM
    PortfolioProject..CovidDeaths
WHERE location LIKE '%Malaysia%'
ORDER BY 1, 2;

--Lokking at Total cases vs Population
--Showing percentage of population got Covid

SELECT
    location,
    date,
	population,
    total_cases,
    CASE
        WHEN TRY_CAST(total_cases AS float) <> 0
        THEN TRY_CAST(total_cases AS float) / TRY_CAST(population AS float)*100
        ELSE NULL
    END AS death_rate
FROM
    PortfolioProject..CovidDeaths
WHERE location LIKE '%Malaysia%'
ORDER BY 1, 2

--Lokking for country with highest infection rate compared to population

SELECT
    location,
    population,
    MAX(total_cases) AS HighestInfection,
    MAX(CASE
        WHEN TRY_CAST(total_cases AS float) IS NOT NULL AND TRY_CAST(population AS float) IS NOT NULL AND TRY_CAST(population AS float) <> 0
        THEN TRY_CAST(total_cases AS float) / TRY_CAST(population AS float) * 100
        ELSE NULL
    END) AS PercentPopulationInfected
FROM
    PortfolioProject..CovidDeaths
GROUP BY
    location, population
ORDER BY
    PercentPopulationInfected DESC

--Country with highest death count per population

SELECT 
	location,
	MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY 
	location
ORDER BY TotalDeathCount DESC

--Lets break things down by continent

SELECT 
	continent,
	MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY 
	continent
ORDER BY TotalDeathCount DESC

--Global numbers

SELECT 
	date,
    SUM(CAST(new_cases AS INT)) AS TotalNewCases,
    SUM(CAST(new_deaths AS INT)) AS TotalNewDeaths,
    CASE
        WHEN SUM(CAST(new_cases AS INT)) = 0 THEN 0
        ELSE SUM(CAST(new_deaths AS INT)) * 100.0 / SUM(CAST(new_cases AS INT))
    END AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY 
	date
ORDER BY 
    1,2

--Lokking at Total population vs Vaccinations 

SELECT 
    cda.continent, 
    cda.location, 
    cda.date, 
    cda.population, 
    cva.new_vaccinations,
    SUM(CONVERT(BIGINT, cva.new_vaccinations)) OVER (PARTITION BY cda.location ORDER BY cda.date) AS TotalVaccinations
FROM PortfolioProject..CovidDeaths cda
JOIN PortfolioProject..CovidVaccinations cva
    ON cda.location = cva.location
    AND cda.date = cva.date
WHERE cda.continent IS NOT NULL
ORDER BY 2, 3

--With CTE

WITH PopVsVac (continent, location, date, population, new_vaccination, TotalVaccinations)
AS
(
    SELECT 
        cda.continent, 
        cda.location, 
        cda.date, 
        cda.population, 
        cva.new_vaccinations,
        SUM(CONVERT(BIGINT, cva.new_vaccinations)) OVER (PARTITION BY cda.location ORDER BY cda.date) AS TotalVaccinations
    FROM PortfolioProject..CovidDeaths cda
    JOIN PortfolioProject..CovidVaccinations cva
        ON cda.location = cva.location
        AND cda.date = cva.date
    WHERE cda.continent IS NOT NULL
)
SELECT *, (TotalVaccinations/population)*100
FROM PopVsVac
ORDER BY 2,3


--Creating view to store data for later visualization

CREATE VIEW PopVsVac AS
 SELECT 
        cda.continent, 
        cda.location, 
        cda.date, 
        cda.population, 
        cva.new_vaccinations,
        SUM(CONVERT(BIGINT, cva.new_vaccinations)) OVER (PARTITION BY cda.location ORDER BY cda.date) AS TotalVaccinations
FROM PortfolioProject..CovidDeaths cda
JOIN PortfolioProject..CovidVaccinations cva
     ON cda.location = cva.location
     AND cda.date = cva.date
WHERE cda.continent IS NOT NULL














