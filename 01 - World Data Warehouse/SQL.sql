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














