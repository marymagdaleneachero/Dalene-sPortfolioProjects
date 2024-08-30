Select *
From PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations$
--order by 3,4

--Select data that we are going to be using
Select Location, date, total_cases, new_cases,total_deaths, population
From PortfolioProject..CovidDeaths$ 
order by 1,2

--Looking at Total cases vs Total deaths
--shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$ 
Where Location like '%states%'
order by 1,2

--Looking at the total_cases vs Population
Select Location, date, total_cases,population,(total_cases/population)*100 as PercentPopulation
From PortfolioProject..CovidDeaths$ 
Where Location like '%states%'
order by 1,2

--Looking at countries with highest infection rate compared to location
Select location,Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$ 
--Where Location like '%states%'
group by location,population
order by PercentPopulationInfected desc


--LET'S BREAK THINGS DOWN BY CONTINENT
--showing continents with highest death per population
Select continent, MAX(cast(total_deaths as integer)) as TotalDeathCount
From PortfolioProject..CovidDeaths$ 
--Where Location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc

--Global numbers
select Sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
--group by date
order by 1,2


--Looking at Total population vs vaccination
select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE
With PopvsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


--TEM Table
DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order
by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location 
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


--Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order
by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select*
from PercentPopulationVaccinated