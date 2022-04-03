--
-- Looking at Total Cases vs Total deaths. 
-- Likelihood of dying if you contact covid in Nigeria
SELECT location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) death_percent 
FROM covid_death
WHERE location = 'Nigeria'
ORDER BY date

--
-- Looking at Total Cases vs population. 
-- What percentage of each country has got Covid
-- WHERE location = 'Nigeria'
SELECT location, population, Max(total_cases) max_case, Max(((total_cases/population)*100)) covid_pop_percent 
FROM covid_death
GROUP BY location, population 
ORDER BY covid_pop_percent DESC

--
-- Looking at Total Cases vs death. 
-- Which continent has the highest number of death?
-- What is the death count per continent?
SELECT continent, count(total_deaths) high_death, max(total_deaths) max_death 
FROM covid_death
WHERE continent is not NULL
GROUP BY continent
ORDER BY max_death DESC

--
-- Looking at New Cases vs New death - Global number. 
-- What is the total percentage of new death compared to new cases for the whole countries?
SELECT sum(new_cases) totcase, sum(new_deaths) totdeath, (sum(new_deaths))/(sum(new_cases)) * 100 deathpercent
FROM covid_death
-- WHERE continent is not NULL
ORDER BY 1,2

--
-- USING JOIN & CTE
-- What is the total amount of people in the world that has been Vaccinated? 

WITH popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevac)
as 
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) rollingpeoplevac
-- (rollingpeoplevac/population)*100
FROM covid_death d
JOIN covid_vaccine v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent is not NULL
-- ORDER BY 2,3
)
SELECT *, (rollingpeoplevac/population)*100
FROM popvsvac

--
-- USING JOIN & TEMP TABLE
-- CREATE TABLE percentpopvac
(
continent nvarchar(255),
location  nvarchar(255),
date datetime,
population NUMERIC,
new_vaccinations NUMERIC,
rollingpeoplevac NUMERIC
)
INSERT INTO percentpopvac
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) rollingpeoplevac
-- (rollingpeoplevac/population)*100
FROM covid_death d
JOIN covid_vaccine v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent is not NULL
-- ORDER BY 2,3
SELECT *, (rollingpeoplevac/population)*100
FROM percentpopvac