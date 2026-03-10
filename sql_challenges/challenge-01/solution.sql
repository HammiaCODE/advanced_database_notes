-- lesson 1
SELECT title FROM movies;
SELECT director FROM movies;
SELECT title,director FROM movies;
SELECT title,year FROM movies;
SELECT * FROM movies;

-- lesson 2
SELECT * FROM movies where id == 6;
SELECT * FROM movies where year BETWEEN 2000 AND 2010;
SELECT * FROM movies where year NOT BETWEEN 2000 AND 2010;
SELECT title,year FROM movies where id<6;

-- lesson 3
SELECT * FROM movies WHERE Title LIKE "%Toy Story%";
SELECT * FROM movies WHERE Director LIKE "%John%";
SELECT * FROM movies WHERE Director NOT LIKE "%John%";
SELECT * FROM movies WHERE title like "WALL%";

-- lesson 4
SELECT DISTINCT Director FROM movies ORDER BY Director;
SELECT * FROM movies ORDER BY Year DESC LIMIT 4;
SELECT * FROM movies ORDER BY Title LIMIT 5;
SELECT * FROM movies ORDER BY Title LIMIT 5 OFFSET 5;

-- lesson 5
SELECT * FROM north_american_cities WHERE Country = "Canada";
SELECT * FROM north_american_cities WHERE Country LIKE "United%" ORDER BY Latitude DESC;
SELECT * FROM north_american_cities WHERE Longitude < -87.629798 ORDER BY Longitude ASC;
SELECT * FROM north_american_cities WHERE Country LIKE "Mex%" ORDER BY Population DESC LIMIT 2;
SELECT * FROM north_american_cities WHERE Country LIKE "United%" ORDER BY Population DESC LIMIT 2 OFFSET 2;