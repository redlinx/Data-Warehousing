-- Step 1
-- use this statement to extract data from the country table and load them in the country table of the datawarehouse 
-- SQL-001
INSERT INTO dw_world.dim_country()
SELECT 	row_number() OVER (ORDER BY world.country.name ASC) AS country_Id,
		world.country.name,
		world.country.continent,
        world.country.region
FROM world.country;

-- SQL-002
INSERT INTO dw_world.dim_city()
SELECT	row_number() OVER (ORDER BY world.city.name ASC) AS country_Id,
		world.city.name,
		world.city.district,
        -- world.country.name,
        dw_world.dim_country.country_id
FROM world.city
INNER JOIN world.country ON world.city.CountryCode = world.country.code
INNER JOIN dw_world.dim_country ON dw_world.dim_country.country = world.country.name;

-- SQL-003
INSERT INTO dw_world.fact_city_population()
SELECT	dw_world.dim_city.city_id,
		-- world.city.name,
		world.city.Population
FROM world.city
INNER JOIN dw_world.dim_city ON dw_world.dim_city.city = world.city.name;

-- SQL-004
INSERT INTO dw_world.fact_country_population()
SELECT	dw_world.dim_country.country_id,
		-- world.country.name,
		world.country.population,
		world.country.LifeExpectancy,
        world.country.GNP,
        world.country.GNPOld
FROM world.country
INNER JOIN dw_world.dim_country ON dw_world.dim_country.country = world.country.name;

-- SQL-005
INSERT INTO dw_world.dim_language(language)
SELECT	DISTINCT world.countrylanguage.language
FROM world.countrylanguage;

-- SQL-006
INSERT INTO dw_world.fact_country_language()
SELECT 	dw_world.dim_language.language_id,
		-- world.countrylanguage.Language,
		dw_world.dim_country.country_id,
		-- world.country.name,
		world.countrylanguage.Percentage 
FROM world.countrylanguage
INNER JOIN world.country ON world.country.code = world.countrylanguage.countrycode
INNER JOIN dw_world.dim_country ON dw_world.dim_country.country = world.country.name
INNER JOIN dw_world.dim_language ON dw_world.dim_language.language = world.countrylanguage.Language;

-- SQL-007 OLAP Operation Rollup by Country
SELECT dw_world.dim_country.country,
		SUM(dw_world.fact_city_population.CityPopulation)
FROM dw_world.fact_city_population
INNER JOIN dw_world.dim_city ON dw_world.fact_city_population.city_id = dw_world.dim_city.city_id
INNER JOIN dw_world.dim_country ON dw_world.dim_city.country_id = dw_world.dim_country.country_id
GROUP BY dw_world.dim_country.country_id;


-- SQL-008 OLAP Operation Rollup by Continent
SELECT dw_world.dim_country.continent,
		SUM(dw_world.fact_city_population.CityPopulation)
FROM dw_world.fact_city_population
INNER JOIN dw_world.dim_city ON dw_world.fact_city_population.city_id = dw_world.dim_city.city_id
INNER JOIN dw_world.dim_country ON dw_world.dim_city.country_id = dw_world.dim_country.country_id
GROUP BY dw_world.dim_country.continent;
















