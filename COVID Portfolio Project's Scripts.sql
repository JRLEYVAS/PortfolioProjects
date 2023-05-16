SELECT * 
FROM PortfolioProject..CovidDeaths

SELECT *
FROM PortfolioProject..CovidVaccinations



--Identify data that will be used
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2



--Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2



--Total Cases vs Population
SELECT location, date, total_cases, population, (total_cases/population) * 100 AS PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2



--Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) AS MaxInfectionCount, MAX((total_cases/population)) * 100 AS PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC



--Countries with Highest Death Count Per population
SELECT location, MAX(total_deaths) AS Deaths
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY Deaths DESC



--Global Numbers
SELECT date, SUM(new_cases), SUM(new_deaths)
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1 



--Looking at Total Population vs Vaccinations
SELECT Death.continent, Death.location, Death.date, death.population, Vaccine.new_vaccinations,
SUM(Vaccine.new_vaccinations) OVER (Partition by death.location ORDER BY Death.location, death.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS Death 
	JOIN PortfolioProject..CovidVaccinations AS Vaccine
		ON Death.location = Vaccine.location
		AND Death.date = Vaccine.date
WHERE death.continent is not null
ORDER BY 2,3



--USE Common TABLE Expression
WITH POPvsVAC( Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS 
(
SELECT Death.continent, Death.location, Death.date, death.population, Vaccine.new_vaccinations,
SUM(Vaccine.new_vaccinations) OVER (Partition by death.location ORDER BY Death.location, death.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS Death 
	JOIN PortfolioProject..CovidVaccinations AS Vaccine
		ON Death.location = Vaccine.location
		AND Death.date = Vaccine.date
WHERE death.continent is not null
)
SELECT *, (RollingPeopleVaccinated/Population) * 100 AS PercentagePeopleVaccinated
FROM POPvsVAC



--TEMPT TABLE
DROP TABLE IF exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric 
)
INSERT into #PercentPopulationVaccinated 
SELECT Death.continent, Death.location, Death.date, death.population, Vaccine.new_vaccinations,
SUM(Vaccine.new_vaccinations) OVER (Partition by death.location ORDER BY Death.location, death.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS Death 
	JOIN PortfolioProject..CovidVaccinations AS Vaccine
		ON Death.location = Vaccine.location
		AND Death.date = Vaccine.date
WHERE death.continent is not null

SELECT *, (RollingPeopleVaccinated/Population) * 100 AS PercentagePeopleVaccinated
FROM #PercentPopulationVaccinated



--Creating View to store data for later visualizations
CREATE View PercentPopulationVaccinated AS
SELECT Death.continent, Death.location, Death.date, death.population, Vaccine.new_vaccinations,
SUM(Vaccine.new_vaccinations) OVER (Partition by death.location ORDER BY Death.location, death.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS Death 
	JOIN PortfolioProject..CovidVaccinations AS Vaccine
		ON Death.location = Vaccine.location
		AND Death.date = Vaccine.date
WHERE death.continent is not null