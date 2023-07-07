select * 
from PortfolioProject..CovidDeaths$
Where continent is not null


--Looking at the total cases vs Total deaths

SELECT location, date, total_cases, total_deaths, 
    (CONVERT(float, total_deaths) / CONVERT(float, total_cases)) * 100 AS Deathpercentage
FROM PortfolioProject..CovidDeaths$
Where continent is not null
ORDER BY location, date;


--Looking at the total cases vs the population
--Shows what percentage of population got covid

SELECT location, date, total_cases,population , 
    (CONVERT(float, total_deaths) / CONVERT(float, population)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
Where continent is not null
ORDER BY location, date;


--Looking at countries with highest infection rate compared to population

SELECT location, population , Max(total_cases) AS HighestInfectionCount, Max((CONVERT(float, total_cases) / CONVERT(float, population))) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
Where continent is not null
group by  location, population
ORDER BY PercentPopulationInfected desc;


--Showing the countries with the highest death count per population

SELECT location, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
Where continent is not null
group by  location
ORDER BY TotalDeathCount desc;


--Breaking down by continent
--Showing the continent with the highest death count per population

SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
Where continent is not null
group by  continent
ORDER BY TotalDeathCount desc;


--Global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null 
order by 1,2
  
-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select det.continent, det.location, det.date, det.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by det.Location Order by det.location, det.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ det
Join PortfolioProject..[Covid vaccinations$] vac
	On det.location = vac.location
	and det.date = vac.date
where det.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..[Covid vaccinations$] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..[Covid vaccinations$] vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..[Covid vaccinations$] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
























































































