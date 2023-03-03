Select *
From CovidDeaths$
Order By 3,4

Select *
From CovidVaccinations$
Order By 3,4

--Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths$
Order by 1, 2

--Looking at Total Cases vs Total Deaths
Shows likelihood of dying if you got Covid

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From CovidDeaths$
Where location Like 'Malaysia'
Order By 1, 2

--Looking at the total cases vs population

Select location, date, total_cases, population, (total_cases/population)*100 As CovidPercentage
From CovidDeaths$
Where location Like 'Malaysia'
Order By 1, 2

--Looking at countries with highest infection rate

Select location, population, Max(total_cases) As HighestInfection, Max((total_cases/population)*100) As CovidPercentage
From CovidDeaths$
Group By location, population
Order By 4 Desc

--Looking at countries with highest death count by countries

Select location, Max(Cast(total_deaths AS int)) As HighestDeath
From CovidDeaths$
Where continent Is Not Null
Group By location
Order By 2 Desc

--Looking at countries with highest death count by continents

Select continent, Max(Cast(total_deaths AS int)) As HighestDeath
From CovidDeaths$
Where continent Is Not Null 
Group By continent
Order By 2 Desc

--Global numbers

Select date, SUM(new_cases) As TotalCases, SUM(Cast(new_deaths As int)) As TotalDeaths, SUM(Cast(new_deaths As int))/SUM(new_cases)*100 as DeathPercentage
From CovidDeaths$
Where continent Is Not Null
Group By date
Order By 1, 2

--Looking at Total Population vs Total Vaccinations
--CTE table

With PopvsVac (Continent, Location, Date, Population, Vaccinations, RollingVaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)

Select *, (RollingVaccinations/Population)*100 As PercentageofRolling
From PopvsVac


--Temp Table

Drop Table if Exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPopulationVaccinated numeric)

Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select *, (RollingPopulationVaccinated/Population)*100 As PercentageofRolling
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select *
From PercentPopulationVaccinated 
