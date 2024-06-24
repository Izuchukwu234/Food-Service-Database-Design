CREATE DATABASE FoodserviceDB

USE FoodserviceDB

-- Setting composite Primary Key on Consumer_ID and Restaurant_ID on Ratings table --
ALTER TABLE Ratings
ADD CONSTRAINT PK_Ratings PRIMARY KEY (Consumer_ID, Restaurant_ID);

-- Setting composite Primary Key on Restaurant_ID and Cuisine on Restaurant_Cuisines table --
ALTER TABLE Restaurant_Cuisines
ADD CONSTRAINT PK_Restaurant_Cuisines PRIMARY KEY (Restaurant_ID, Cuisine);

-- Adding foreign key constraints for Ratings table --
ALTER TABLE Ratings
ADD CONSTRAINT FK_Ratings_Consumer FOREIGN KEY (Consumer_ID) REFERENCES Consumers(Consumer_ID),
	CONSTRAINT FK_Ratings_Restaurant FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID);

-- Adding foreign key constraint for Restaurant_Cuisines table --
ALTER TABLE Restaurant_Cuisines
ADD CONSTRAINT FK_Restaurant_Cuisines_Restaurant FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID);

-- QUESTION 1
SELECT DISTINCT b.* FROM Restaurant b
INNER JOIN Restaurant_Cuisines ba
ON b.Restaurant_ID = ba.Restaurant_ID
WHERE b.Price = 'Medium' AND b.Area = 'Open'
AND EXISTS (
    SELECT 1 
    FROM Restaurant_Cuisines 
    WHERE Restaurant_ID = b.Restaurant_ID 
    AND Cuisine = 'Mexican'
);

-- QUESTION 2
SELECT ba.Cuisine, COUNT(*) AS [Rating 1 Total Count] FROM  Restaurant_Cuisines ba
WHERE ba.Restaurant_ID IN (SELECT b.Restaurant_ID FROM Ratings b
													WHERE b.Overall_Rating = 1)
AND ba.Cuisine IN ('Mexican', 'Italian')
GROUP BY ba.Cuisine
HAVING COUNT(*) > 0
ORDER BY ba.Cuisine;


-- QUESTION 3
SELECT AVG(b.Age) AS [Average Age]
FROM Consumers b
INNER JOIN (SELECT Consumer_ID FROM Ratings 
						WHERE Service_Rating = 0) 
AS [Zero Ratings]
ON b.Consumer_ID = [Zero Ratings].Consumer_ID;


-- QUESTION 4
SELECT 
			b.Name AS [Restaurant Name], 
			bc.Food_Rating AS [Food Rating],
			Y_Consumer.[Minimum Age] AS [Youngest Consumer Age]
FROM Restaurant b
INNER JOIN Ratings bc ON b.Restaurant_ID = bc.Restaurant_ID
INNER JOIN (SELECT Restaurant_ID, MIN(a.Age) AS [Minimum Age] FROM Ratings r
						JOIN Consumers a ON r.Consumer_ID = a.Consumer_ID
						GROUP BY Restaurant_ID)
AS Y_Consumer 
ON b.Restaurant_ID = Y_Consumer.Restaurant_ID
WHERE EXISTS (SELECT 1 FROM Consumers a 
								WHERE a.Consumer_ID = bc.Consumer_ID 
								AND a.Age = Y_Consumer.[Minimum Age])
ORDER BY bc.Food_Rating DESC;

-- QUESTION 5
CREATE PROCEDURE UpdateServiceRating
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @number_updated INT;

    UPDATE Ratings
    SET Service_Rating = '2'
    WHERE Restaurant_ID IN (
        SELECT b.Restaurant_ID
        FROM Restaurant b
        WHERE b.Parking IN ('yes', 'public')
    );

    SET @number_updated = @@ROWCOUNT;
    PRINT 'Service rating updated for restaurants with parking available is ' + CAST(@number_updated AS VARCHAR);
END;

EXEC UpdateServiceRating;

SELECT a.Parking, b.Service_Rating
FROM Ratings b
INNER JOIN Restaurant a 
ON b.Restaurant_ID = a.Restaurant_ID
WHERE a.Parking IN ('yes', 'public');


-- QUESTION 6
-- First query: It returns all restaurant that have a parking space
SELECT * FROM Restaurant b
WHERE EXISTS (SELECT 1 FROM Ratings bc
								WHERE bc.Restaurant_ID = b.Restaurant_ID
								AND b.Parking = 'Yes');

-- Second query: It returns the Restaurant that serves Japanese cuisine and which doesn't allows smoking
SELECT b.Name AS [Restaurant Name], 
			   bc.Cuisine, 
			   b.Smoking_Allowed AS [Smoking Allowed]
FROM Restaurant b
INNER JOIN Restaurant_Cuisines bc 
ON b.Restaurant_ID = bc.Restaurant_ID
WHERE b.Restaurant_ID IN (SELECT DISTINCT Restaurant_ID 
												FROM Restaurant_Cuisines
												WHERE Cuisine = 'Japanese')
AND b.Smoking_Allowed = 'No';

-- Third query: It returns the total number of Consumers from each cities with a service rating of 1
SELECT 
    UPPER(City) AS City,
    COUNT(*) AS [Number Of Consumers]
FROM Consumers
WHERE Consumer_ID IN (SELECT Consumer_ID FROM Ratings
											WHERE Service_Rating = 1)
GROUP BY UPPER(City)
ORDER BY [Number Of Consumers] ASC;

-- Fourth query: It returns the students and their ages who did a food rating of 2
SELECT b.Food_Rating, c.Occupation, c.Age FROM Ratings b
INNER JOIN Consumers c
ON b.Consumer_ID = b.Consumer_ID
WHERE b.Food_Rating = 2 AND c.Occupation = 'Student'
GROUP BY b.Food_Rating, c.Occupation, c.Age
HAVING COUNT(*) > 0
ORDER BY c.Age DESC;