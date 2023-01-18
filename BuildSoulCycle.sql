-- SoulCycle database developed and written by Angel Fernandes
-- Originally Written: October 2022 | Updated: 13 October 2022
-----------------------------------------------------------
-- Replace <data_path> with the full path to this file 
-- Ensure it ends with a backslash 
-- E.g., C:\MyDatabases\ See line 17
-----------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE NAME = N'SoulCycle')
	CREATE DATABASE SoulCycle
GO
USE SoulCycle
--
-- Alter the path so the script can find the CSV files 
--
DECLARE @data_path NVARCHAR(256);
SELECT @data_path = 'C:\Users\Angel.Fernandes\Desktop\SoulCycle\';
--
-- Delete existing tables
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Register'
       )
	DROP TABLE Register;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Class'
       )
	DROP TABLE Class;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Class_Type'
       )
	DROP TABLE Class_Type;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Class_Level'
       )
	DROP TABLE Class_Level;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Student'
       )
	DROP TABLE Student;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Studio'
       )
	DROP TABLE Studio;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Instructor'
       )
	DROP TABLE Instructor;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'InstructorCertification'
       )
	DROP TABLE InstructorCertification;
--
-- Create tables
--
CREATE TABLE InstructorCertification
	(Certif_Id int CONSTRAINT pk_certif_id primary key,
	CertName nvarchar(200) CONSTRAINT nn_CertName NOT NULL,
	CertRenewal int CONSTRAINT nn_CertRenewal NOT NULL,
	CertType nvarchar(50) CONSTRAINT nn_CertRenewal NOT NULL
	);
--
CREATE TABLE Instructor
	(Instructor_Id int CONSTRAINT pk_instructor_id primary key,
	InstructorFName nvarchar(20) CONSTRAINT nn_InstructorFName NOT NULL,
	InstructorLName nvarchar(20) CONSTRAINT nn_InstructorLName NOT NULL,
	InstructorContact bigint CONSTRAINT nn_InstructorContact NOT NULL,
	InstructorCert int CONSTRAINT fk_InstructorCert FOREIGN KEY
		REFERENCES InstructorCertification(Certif_Id),
	InstructorCertDate date CONSTRAINT nn_InstructorCertDate NOT NULL
	);
--
CREATE TABLE Student
	(Student_Id int CONSTRAINT pk_student_id primary key,
	StudentFName nvarchar(20) CONSTRAINT nn_StudentFName NOT NULL,
	StudentLName nvarchar(20) CONSTRAINT nn_StudentLName NOT NULL,
	StudentContact bigint CONSTRAINT nn_StudentContact NOT NULL,
	StudentAge int CONSTRAINT nn_StudentAge NOT NULL,
	StudentGender nvarchar(3) CONSTRAINT nn_StudentGender NOT NULL
	);
--
CREATE TABLE Studio
	(Studio_Id int CONSTRAINT pk_studio_id primary key,
	StudioName nvarchar(50) CONSTRAINT nn_StudioName NOT NULL
	);
--
CREATE TABLE Class_Level
	(ClassLevel_Id int CONSTRAINT pk_classlevel_Id  primary key,
	ClassLevelDesc nvarchar(50) CONSTRAINT nn_ClassLevelDesc  NOT NULL
	);
--
CREATE TABLE Class_Type
	(ClassType_Id int CONSTRAINT pk_classtype_Id primary key,
	ClassTypeDesc nvarchar(50) CONSTRAINT nn_ClassTypeDesc  NOT NULL
	);
--
CREATE TABLE Class
	(Class_Id bigint CONSTRAINT pk_class_id primary key, 
	Instructor_Id int CONSTRAINT fk_Instructor_Id FOREIGN KEY
		REFERENCES Instructor(Instructor_Id),
	Studio_Id int CONSTRAINT fk_Studio_Id FOREIGN KEY
		REFERENCES Studio(Studio_Id),
	ClassLevel_Id int CONSTRAINT nn_ClassLevel_Id FOREIGN KEY
		REFERENCES Class_Level(ClassLevel_Id),
	ClassType_Id int CONSTRAINT nn_ClassType_Id FOREIGN KEY
		REFERENCES Class_Type(ClassType_Id),
	ClassSize int CONSTRAINT nn_ClassSize NOT NULL, 
	ClassDay date CONSTRAINT nn_ClassDay NOT NULL, 
	ClassTime nvarchar(10) CONSTRAINT nn_ClassTime NOT NULL,
	ClassRoom nvarchar(10) CONSTRAINT nn_ClassRoom NOT NULL
	);
--
CREATE TABLE Register
	(Register_Id int CONSTRAINT pk_register_id primary key,
	Student_Id int CONSTRAINT fk_Student_Id FOREIGN KEY
		REFERENCES Student(Student_Id),
	Class_Id bigint CONSTRAINT fk_Class_Id FOREIGN KEY
		REFERENCES Class(Class_Id),
	RegisterDate date CONSTRAINT nn_RegisterDate NOT NULL,
	);
--
-- Load table data
--
EXECUTE (N'BULK INSERT InstructorCertification FROM ''' + @data_path + N'InstructorCertification.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
EXECUTE (N'BULK INSERT Instructor FROM ''' + @data_path + N'Instructor.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
EXECUTE (N'BULK INSERT Student FROM ''' + @data_path + N'Student.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
EXECUTE (N'BULK INSERT Studio FROM ''' + @data_path + N'Studio.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
EXECUTE (N'BULK INSERT Class_Level FROM ''' + @data_path + N'Class_Level.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
EXECUTE (N'BULK INSERT Class_Type FROM ''' + @data_path + N'Class_Type.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
EXECUTE (N'BULK INSERT Class FROM ''' + @data_path + N'Class.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
EXECUTE (N'BULK INSERT Register FROM ''' + @data_path + N'Register.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
-- List table names and row counts for confirmation
--
GO
SET NOCOUNT ON
SELECT 'InstructorCertification' AS "Table",	COUNT(*) AS "Rows"	FROM InstructorCertification	UNION
SELECT 'Instructor',							COUNT(*)			FROM Instructor					UNION
SELECT 'Student',								COUNT(*)			FROM Student					UNION
SELECT 'Studio',								COUNT(*)			FROM Studio						UNION
SELECT 'Class_Level',							COUNT(*)			FROM Class_Level				UNION
SELECT 'Class_Type',							COUNT(*)			FROM Class_Type					UNION
SELECT 'Class',									COUNT(*)			FROM Class						UNION
SELECT 'Register',								COUNT(*)			FROM Register
ORDER BY 1;
SET NOCOUNT OFF
GO
