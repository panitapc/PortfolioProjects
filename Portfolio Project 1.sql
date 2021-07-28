Select *
From [PortfolioProject-1]..covidDeaths
order by 3,4

--Select *
--From [PortfolioProject-1]..covidVaccinations
--order by 3,4

--** Selecting the data that we are using

Select location, date, total_cases, new_cases, total_deaths, population 
From [PortfolioProject-1]..covidDeaths
order by 1,2

-- Looking at total cases vs total cases
Select location, max(total_cases) as MaxCases, max(total_deaths) as MaxDeaths, max(population) as Population
, (max(total_deaths)/Max(total_cases))*100 as PercDeathsCases
, (max(total_deaths)/Max(population))*100 as PercDeathsPop
from [PortfolioProject-1]..covidDeaths
Group by Location
order by 6 desc

-- Shows the likelihood of dying if you contract covid in your country
Select location, date, total_cases,total_deaths, total_deaths/total_cases*100 as DeathPercentage
from [PortfolioProject-1]..covidDeaths
where location like '%states%'
order by 1,2

-- Shows the percentage of population that contracted covid
Select location, max(total_cases/population) as MaxRate MaxCases, max(population) as Population
, max(todate, population,total_cases, total_cases/population*100 as PercentPopulationInfected
from [PortfolioProject-1]..covidDeaths
where location like '%states%'
order by 1,2

-- Looking at countries with highest infection rate compared to population

Select location, date, population,total_cases, total_cases/population*100 as total infected
from [PortfolioProject-1]..covidDeaths
where location like '%states%'
order by 5

Select location,population, Max(Total_cases) HighestInfectionCount, (Max(Total_cases)/Population)*100 InfectionRate
from [PortfolioProject-1]..covidDeaths
group by location, population
order by 4 desc

Select location, total_cases/population, total_cases, population
from [PortfolioProject-1]..covidDeaths
where location = 'Andorra'
order by 2 desc

-- Showing countries with highest death count per population
Select location, Max(total_deaths) as Deaths, population, Max(Total_deaths)/population*100 as DeathRatePercentage
from [PortfolioProject-1]..covidDeaths
Group by location, population
order by 4 desc

-- Showing countries with the highest Deathcounts
Select location, Max(cast(total_deaths as int)) as Deaths
from [PortfolioProject-1]..covidDeaths
Where location Not in ('World','Europe','Asia','South America', 'North America', 'European Union'
	, 'Africa')
Group by location
order by 2 desc

Select location, Max(cast(total_deaths as int)) as Deaths
from [PortfolioProject-1]..covidDeaths
Where location Not in ('World','Europe','Asia','South America', 'North America', 'European Union'
	, 'Africa')
Group by location
order by 2 desc

Select location, Max(cast(total_deaths as int)) as Deaths
from [PortfolioProject-1]..covidDeaths
Where continent is not Null
Group by location
order by 2 desc

-- LETS BREAK THINGS DOWN BY CONTINENT
Select location, max(cast(total_deaths as int)) as Deaths
from [PortfolioProject-1]..covidDeaths
Where continent is null
Group by location
order by 2 desc

Select Continent, Location, max(total_deaths) MaxDeathsLoc
	from [PortfolioProject-1]..covidDeaths
	Where continent is not null
	Group by continent, location
order by 1


Select Table2.continent, sum(Table2.MaxDeathsLoc) as TotalDeaths 
from 
	(Select Continent, Location, max(cast(total_deaths as int)) MaxDeathsLoc
	from [PortfolioProject-1]..covidDeaths
	Where continent is not null
	Group by continent, location
	--order by 3 desc
	) as Table2
Group by continent

select Max(cast(Total_deaths as int))
from [PortfolioProject-1]..covidDeaths
where location = 'world'
group by location

Select continent, location, date, cast(Total_deaths as int)
from [PortfolioProject-1]..covidDeaths
where continent = 'oceania'
order by 4 desc

Select location, max(cast(total_deaths as int)) as TotalDeathCount
from [PortfolioProject-1]..covidDeaths
Where continent is  null
group by location
order by 2 desc

-- Showing the continents with the higherst Death counts
Select Table2.continent, sum(Table2.MaxDeathsLoc) as TotalDeaths 
from 
	(Select Continent, Location, max(cast(total_deaths as int)) MaxDeathsLoc
	from [PortfolioProject-1]..covidDeaths
	Where continent is not null
	Group by continent, location
	--order by 3 desc
	) as Table2
Group by continent
order by 2 desc

-- Global numbers
Select date, 
sum(cast(total_cases as int)) as GlobalCases, 
sum(cast(total_deaths as int)) as GlobalDeaths, 
(cast(total_deaths as int)/cast(total_cases as int))*100 as DeathPerc
from [PortfolioProject-1]..covidDeaths
group by date

Select date, 
sum(cast(total_cases) as GlobalCases, 
sum(total_deaths) as GlobalDeaths, 
sum(total_deaths)/sum(total_cases)*100 as DeathPerc
from [PortfolioProject-1]..covidDeaths
group by date

Select date, total_cases,total_deaths, total_deaths/total_cases*100 as DeathPercentage
from [PortfolioProject-1]..covidDeaths
--where location like '%states%'
group by date
order by 1,2

Select date, SUM(new_cases) as GlobalCases, sum(cast(new_deaths as int)) as GlobalDeaths
, (sum(cast(new_deaths as int))/sum(new_cases))*100 PercDeaths
from [PortfolioProject-1]..covidDeaths
where continent is not null
group by date
order by 1,2

Select  SUM(new_cases) as GlobalCases, sum(cast(new_deaths as int)) as GlobalDeaths
, (sum(cast(new_deaths as int))/sum(new_cases))*100 PercDeaths
from [PortfolioProject-1]..covidDeaths
where continent is not null

-- Looking at total population vs vaccination.
Select * 
from [PortfolioProject-1]..covidDeaths as dea
join [PortfolioProject-1]..covidVaccinations as vac
	on dea.date = vac.date and dea.location = vac.location

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from [PortfolioProject-1]..covidDeaths as dea
join [PortfolioProject-1]..covidVaccinations as vac
	on dea.date = vac.date and dea.location = vac.location
where dea.continent is not null
order by 2,3

-- adding a rolling total

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location)
from [PortfolioProject-1]..covidDeaths as dea
join [PortfolioProject-1]..covidVaccinations as vac
	on dea.date = vac.date and dea.location = vac.location
where dea.continent is not null
order by 2,3


--Use CTE to compare vaccionations to population, CTE must have the same number of columns


With PopvsVac(continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) 
OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
from [PortfolioProject-1]..covidDeaths as dea
join [PortfolioProject-1]..covidVaccinations as vac
	on dea.date = vac.date and dea.location = vac.location
where dea.continent is not null
)
Select *,RollingPeopleVaccinated/Population*100 from PopvsVac
Select * from PopvsVac
--order by 2,3


-- use Temp table to compare vaccionations to population

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255), 
Date datetime, 
Population numeric, 
New_Vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, sum(convert(int,vac.new_vaccinations)) 
	OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
	from [PortfolioProject-1]..covidDeaths as dea
	join [PortfolioProject-1]..covidVaccinations as vac
		on dea.date = vac.date and dea.location = vac.location
	where dea.continent is not null

Select *,RollingPeopleVaccinated/Population*100 
from #PercentPopulationVaccinated


--- Creating a view to store data for later visualizations.
Create View PercentPopulationVaccinated as 
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, sum(convert(int,vac.new_vaccinations)) 
	OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
	from [PortfolioProject-1]..covidDeaths as dea
	join [PortfolioProject-1]..covidVaccinations as vac
		on dea.date = vac.date and dea.location = vac.location
	where dea.continent is not null

Select * 
From PercentPopulationVaccinated


