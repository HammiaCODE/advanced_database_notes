-- 1
SELECT Movies.Title, Boxoffice.domestic_sales, Boxoffice.international_sales
    FROM movies 
        INNER JOIN Boxoffice ON Id = Movie_id
        ORDER BY Id ASC; 


SELECT Movies.Title, Boxoffice.domestic_sales, Boxoffice.international_sales
    FROM movies 
        INNER JOIN Boxoffice ON Id = Movie_id
        WHERE Domestic_sales < International_sales; 

SELECT Movies.Title, Boxoffice.domestic_sales, Boxoffice.international_sales
    FROM movies 
        INNER JOIN Boxoffice ON Id = Movie_id
        ORDER BY Rating DESC; 


--2
SELECT DISTINCT Building FROM employees;

SELECT * FROM Buildings;

SELECT DISTINCT Building_name , Role FROM Buildings
    LEFT JOIN Employees ON Building_name = Building;


--3
SELECT pages.page_id FROM pages
  LEFT JOIN page_likes ON page_likes.page_id = pages.page_id
  WHERE page_likes.page_id IS NULL

  ORDER BY pages.page_id ASC;
