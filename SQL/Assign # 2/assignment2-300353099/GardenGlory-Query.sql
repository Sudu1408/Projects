--Sudarsan Haridas
--300353099

USE GardenGlory;
GO 




--c

SELECT	PropertyName
FROM 	OWNED_PROPERTY
WHERE 	City = 'Redmond'
	  	AND 
	  	PropertyType = 'Apartments';


--d

SELECT	City, COUNT(*) as NumberOfProperties
FROM 	OWNED_PROPERTY
GROUP BY City
ORDER BY NumberOfProperties DESC;


--e

SELECT	LastName, FirstName, CellPhone
FROM	EMPLOYEE
WHERE 	ExperienceLevel = 'Master'
		AND
		FirstName LIKE 'J%';