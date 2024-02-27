--Sudarsan Haridas
--300353099

USE WP;
GO 


-----------------Q1-----------------

DROP VIEW IF EXISTS ProjectInfoView;
GO

CREATE VIEW ProjectInfoView AS
SELECT	p.ProjectName, p.Department, e.FirstName, 
		e.LastName, a.HoursWorked
FROM	PROEJCT p JOIN ASSIGNMENT a
			ON p.ProjectID = a.ProjectID
		JOIN EMPLOYEE e 
			ON a.EmployeeNumber = e.EmployeeNumber;

GO

SELECT	*
FROM	ProjectInfoView;


-----------------Q2-----------------

DROP PROCEDURE IF EXISTS ProjectEmpSearch;
GO

CREATE PROCEDURE ProjectEmpSearch
@ProjectName CHAR(50)
AS 
SELECT	FirstName, LastName, HoursWorked
FROM	ProjectInfoView 
WHERE	ProjectName = @ProjectName;

GO

EXEC ProjectEmpSearch @ProjectName = '2019 Q4 Marketing Plan';

-----------------Q3-----------------

DROP FUNCTION IF EXISTS dbo.ProjectCost;
GO

CREATE FUNCTION dbo.ProjectCost
(
	@ProjectName CHAR(50),
	@HourlyRate FLOAT
)
RETURNS NUMERIC(12,2)
AS
BEGIN
	DECLARE @ProjectLaborCost NUMERIC(12,2);

	SELECT @ProjectLaborCost = SUM(HoursWorked) * @HourlyRate
	FROM	ProjectInfoView
	WHERE	ProjectName = @ProjectName
	GROUP BY ProjectName;

	RETURN @ProjectLaborCost;
	
END;

GO

SELECT	ProjectName, dbo.ProjectCost('2019 Q3 Production Plan', 37.50) AS ProjectLaborCost
FROM	ProjectInfoView;

SELECT	ProjectName, dbo.ProjectCost('2019 Q3 Marketing Plan', 37.50) AS ProjectLaborCost
FROM	ProjectInfoView

SELECT	ProjectName, dbo.ProjectCost('2019 Q3 Portfolio Analysis', 37.50) AS ProjectLaborCost
FROM	ProjectInfoView

SELECT	ProjectName, dbo.ProjectCost('2019 Q3 Tax Preparation', 37.50) AS ProjectLaborCost
FROM	ProjectInfoView

SELECT	ProjectName, dbo.ProjectCost('2019 Q4 Production Plann', 37.50) AS ProjectLaborCost
FROM	ProjectInfoView

SELECT	ProjectName, dbo.ProjectCost('2019 Q4 Marketing Plan', 37.50) AS ProjectLaborCost
FROM	ProjectInfoView

SELECT	ProjectName, dbo.ProjectCost('2019 Q4 Portfolio Analysis', 37.50) AS ProjectLaborCost
FROM	ProjectInfoView

------------------------------------