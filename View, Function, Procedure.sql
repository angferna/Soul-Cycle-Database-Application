use SoulCycle;

--VIEW
--Creates view showing all relevant clas details. Can be filtered using select statement as shown below
CREATE VIEW ClassDetails
AS
SELECT Class.Class_Id, 
        Instructor.InstructorFName,
		Instructor.InstructorLName,  
        CAST(Class.ClassDay AS Date) AS 'Class Date',
		Class.ClassTime,
        Class_Level.ClassLevelDesc,
        Class_Type.ClassTypeDesc
FROM Class, Instructor, Class_Level, Class_Type
where Class.Instructor_Id = Instructor.Instructor_Id
and Class.ClassLevel_Id = Class_Level.ClassLevel_Id
and Class.ClassType_Id = Class_Type.ClassType_Id;

select * from ClassDetails where InstructorLName = 'Smith';

--FUNCTION
--Creates a function that tells which user if instructor needs to renew certification using user input id and date.

CREATE FUNCTION RenewCertification (@id int, @inputdate date)
returns @Renew table(InstructorId int, InstructorName varchar(100), InstructorCertDate int, renew varchar(3), Cert varchar(100))
as
begin
	insert into @Renew
		select Instructor.Instructor_Id, 
			   concat(Instructor.InstructorFName,' ',Instructor.InstructorLName),
			   (datediff(year, Instructor.InstructorCertDate, @inputdate)), 
			   CASE WHEN datediff(year, Instructor.InstructorCertDate, @inputdate) >=InstructorCertification.CertRenewal THEN 'Yes' ELSE 'No' end AS "Renew",
			   InstructorCertification.CertName
			from Instructor, InstructorCertification
				where Instructor.InstructorCert = InstructorCertification.Certif_Id
				and Instructor.Instructor_id = @id
return
end

SELECT * from RenewCertification(1200, '2019-07-08')

--PROCEDURE
--Creates a stored procedure that returns the first name, last name, telephone number, gender and number of rides
-- taken, sorted by class date in descending order depending on id.
CREATE PROCEDURE returnStudentInfo @id int
	AS
		select Student.Student_Id, 
			   max(StudentFName) AS 'First Name', 
			   max(StudentLName) AS 'Last Name', 
			   max(StudentContact) AS Contact,
			   max(StudentGender) AS Gender,
			   count(Register.Student_Id) AS 'No. Of Classes',
			   (count(Register.Student_Id)-100) AS "Congratulate", 
				CASE WHEN (count(Register.Student_Id)-100) >=0 THEN 'Congratulte' ELSE '' end AS "Congratulate"
			   from Student,
					Register,
					Class,
					Class_Level,
					Class_Type
			   where Student.Student_Id = @id
			   and Student.Student_Id = Register.Student_Id
			   and Register.Class_Id = Class.Class_Id
			   and Class.ClassLevel_Id = Class_Level.ClassLevel_Id
			   and Class.ClassType_Id = Class_Type.ClassType_Id
			   group by Student.Student_Id
			   order by Student.Student_Id
GO

exec returnStudentInfo 2300
