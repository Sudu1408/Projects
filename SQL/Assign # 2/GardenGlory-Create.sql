--Sudarsan Haridas
--300353099

USE master;
GO


DROP DATABASE IF EXISTS GardenGlory;

CREATE DATABASE GardenGlory;
GO 


USE GardenGlory;
GO 



--Owner Table
CREATE TABLE OWNER(
	OwnerID				INT					NOT NULL IDENTITY(1,1),
	OwnerName			CHAR(35)			NOT NULL,
	OwnerEmail			VARCHAR(100)		NOT NULL,
	OwnerType			CHAR(25)			NOT NULL,
	CONSTRAINT			OWNER_PK			PRIMARY KEY(OwnerID)
	);

--Owned Property Table
CREATE TABLE OWNED_PROPERTY(
	PropertyID			INT 				NOT NULL IDENTITY(1,1),
	PropertyName		CHAR(50)			NOT NULL,
	PropertyType		CHAR(30)			NOT NULL,
	Steet				VARCHAR(100)		NOT NULL,
	City				CHAR(30)			NOT NULL,
	STATE				CHAR(2)				NOT NULL DEFAULT 'WA',
	ZIP					NUMERIC(5)			NOT NULL,
	OwnerID				INT 				NOT NULL,
	CONSTRAINT			OWNED_PROPERTY_PK	PRIMARY KEY(PropertyID),
	CONSTRAINT			OWNDPROP_OWNER_FK	FOREIGN KEY(OwnerID)
							REFERENCES OWNER(OwnerID)
								ON DELETE CASCADE
	);

--We delete Property when Owner is deleted.
--We do not provide UPDATE action as owner ID is auto number...


--GG_Service table
CREATE TABLE GG_SERVICE(
	ServiceID			INT 				NOT NULL IDENTITY(1,1),
	ServiceDescription	CHAR(50)			NOT NULL,
	CostPerHour			NUMERIC(8,2)		NOT NULL,
	CONSTRAINT			GG_SERVICE_PK		PRIMARY KEY(ServiceID)
	);

--Employee table
CREATE TABLE EMPLOYEE(
	EmployeeID			INT  				NOT NULL IDENTITY(1,1),
	LastName			CHAR(25)			NOT NULL,
	FirstName			CHAR(25)			NOT NULL,
	CellPhone			CHAR(12)			NOT NULL,
	ExperienceLevel		CHAR(10)			NOT NULL,
	CONSTRAINT			EMPLOYEE_PK 		PRIMARY KEY(EmployeeID)
	);

--Property_Service Table
CREATE TABLE PROPERTY_SERVICE(
	PropertyServiceID	INT   				NOT NULL IDENTITY(1,1),
	PropertyID 			INT  				NOT NULL,
	ServiceID 			INT   				NOT NULL,
	ServiceDate			DATE 				NOT NULL,
	EmployeeID 			INT  				NOT NULL,
	HoursWorked			NUMERIC(8,2)		NOT NULL,
	CONSTRAINT			PROPERTY_SERVICE_PK	PRIMARY KEY(PropertyServiceID),
	CONSTRAINT			PROPSERV_PROP_FK	FOREIGN KEY(PropertyID)
							REFERENCES OWNED_PROPERTY(PropertyID)
								ON DELETE CASCADE,
	CONSTRAINT			PROPSERV_GGSERV_FK	FOREIGN KEY(ServiceID)
							REFERENCES GG_SERVICE(ServiceID)
								ON DELETE CASCADE,
	CONSTRAINT			PROPSERV_EMP_FK		FOREIGN KEY(EmployeeID)
							REFERENCES EMPLOYEE(EmployeeID)
								ON DELETE CASCADE
	);

--We do not provide UPDATE action as all foreign keys are auto number...
--We delete any Property, Service or Employee deleted in original tables..
















