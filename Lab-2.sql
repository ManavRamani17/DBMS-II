---PART-A
SELECT * FROM STUDENT

-- 1. INSERT Procedures: Create stored procedures to insert records into STUDENT tables(SP_INSERT_STUDENT)
CREATE OR ALTER PROCEDURE PR_INSERT_STUDENT
@STUID INT,
@STUNAME  VARCHAR(20),
@STUEMAIL VARCHAR(20),
@STUPHONE VARCHAR(20),
@STUDEPARTMENT VARCHAR(20),
@STUDATEOFBIRTH DATE,
@STUENROLLMENTYEAR INT,
@CGPA INT
AS
BEGIN
	INSERT INTO STUDENT(STUDENTID, StuName, STUEMAIL, STUPHONE, STUDEPARTMENT, STUDATEOFBIRTH, STUEnrollmentYear,CGPA)
	VALUES (@STUID, @STUNAME, @STUEMAIL, @STUPHONE, @STUDEPARTMENT ,@STUDATEOFBIRTH, @STUENROLLMENTYEAR,@CGPA)
END
EXEC PR_INSERT_STUDENT  10, 'Harsh Parmar' ,'harsh@univ.edu', '9876543219', 'CSE', '2005-09-18' ,2023 , NULL
EXEC PR_INSERT_STUDENT  11, 'Om Patel',' om@univ.edu',' 9876543220',' IT', '2002-08-22', 2022,NULL


SELECT * FROM COURSE
--2. INSERT Procedures: Create stored procedures to insert records into COURSE tables(SP_INSERT_COURSE)
    CREATE OR ALTER PROCEDURE PR_INSERT_COURSE
	@CourseID  VARCHAR(10),
	@CourseName VARCHAR(50),
	@CourseCredits INT,
	@CourseDepartment VARCHAR(50),
	@CourseSemester INT
	AS
	BEGIN
	INSERT INTO COURSE (CourseID,CourseName,CourseCredits,CourseDepartment,CourseSemester)
	            VALUES(@CourseID,@CourseName,@CourseCredits,@CourseDepartment,@CourseSemester)
	END
	EXEC PR_INSERT_COURSE 'CS330', 'Computer Networks', 4 ,'CSE', 5
	EXEC PR_INSERT_COURSE 'EC120', 'Electronic Circuits','3','ECE',2

--3. UPDATE Procedures: Create stored procedure SP_UPDATE_STUDENT to update Email and Phone inSTUDENT table. (Update using studentID)
	CREATE OR ALTER PROCEDURE PR_UPDATE_STUDENT
	@EMAIL VARCHAR(50),
	@PHONE VARCHAR(15),
	@STUID VARCHAR(15)
	AS
	BEGIN
	UPDATE STUDENT
	SET STUEMAIL = @EMAIL, STUPHONE=@PHONE
	WHERE STUDENTID=@STUID
	END

	EXEC PR_UPDATE_STUDENT  @STUID=5 ,@EMAIL='ASDF@GMAIL',@PHONE='9876543216'

--4. DELETE Procedures: Create stored procedure SP_DELETE_STUDENT to delete records from STUDENTwhere Student Name is Om Patel.
	CREATE OR ALTER PROCEDURE PR_DELETE_STUDENT
	@STUNAME VARCHAR(50)
	AS
	BEGIN
	DELETE STUDENT
	WHERE STUNAME=@STUNAME
	END

	EXEC PR_DELETE_STUDENT @STUNAME='OM PATEL'

--5. SELECT BY PRIMARY KEY: Create stored procedures to select records by primary key(SP_SELECT_STUDENT_BY_ID) from Student table.
	CREATE OR ALTER PROCEDURE PR__SELECT_STUDENT_BY_ID
	@STUID VARCHAR(15)
	AS
	BEGIN
	SELECT *
	FROM STUDENT
	WHERE STUDENTID=@STUID
	END

	EXEC PR__SELECT_STUDENT_BY_ID  3


--6. Create a stored procedure that shows details of the first 5 students ordered by EnrollmentYear.
	CREATE OR ALTER PROCEDURE PR_DISPLAY_FIRST_FIVE
	@TOPN INT
	AS
	BEGIN
	SELECT  TOP(@TOPN) * 
	FROM STUDENT
	ORDER BY STUENROLLMENTYEAR
	END

	EXEC PR_DISPLAY_FIRST_FIVE @TOPN=5

--Part – B
--7. Create a stored procedure which displays faculty designation-wise count.
	CREATE OR ALTER PROCEDURE PR_FACULTY_COUNT
	AS
	BEGIN
	SELECT COUNT(FACULTYID) AS TOTAL_FACULTY,FacultyDesignation
	FROM FACUILTY
	GROUP BY FacultyDesignation
	END

	EXEC PR_FACULTY_COUNT
	

--8. Create a stored procedure that takes department name as input and returns all students in that department.
	CREATE OR ALTER PROCEDURE PR_DEPTWISE_STUDENT
	 @DEPTNAME VARCHAR(50)
	AS
	BEGIN
	SELECT *
	FROM STUDENT 
	WHERE STUDEPARTMENT =@DEPTNAME
	END

	EXEC PR_DEPTWISE_STUDENT 'CSE'


--Part – C

--9. Create a stored procedure which displays department-wise maximum, minimum, and average credits of courses.
	CREATE OR ALTER PROCEDURE PR_DEPTWISE_CREDITS
	AS
	BEGIN
	SELECT MAX(COURSECREDITS) AS MAX_CREDIT,MIN(COURSECREDITS) AS MIN_CREDIT, AVG(COURSECREDITS) AS AVG_CREDIT,COURSEDEPARTMENT
	FROM COURSE
	GROUP BY COURSEDEPARTMENT
	END

	EXEC PR_DEPTWISE_CREDITS
	
--10. Create a stored procedure that accepts StudentID as parameter and returns all courses the student is enrolled in with their grades.
	CREATE OR ALTER PROCEDURE PR_STUDENT_COURSES_GRADE
	@STUDENTID INT
	AS
	BEGIN
		SELECT 
			E.COURSEID,
			C.COURSENAME,
			E.GRADE
		FROM ENROLLMENT E
		INNER JOIN COURSE C 
			ON E.COURSEID = C.COURSEID
		WHERE E.STUDENTID = @STUDENTID;
	END


	EXEC PR_STUDENT_COURSES_GRADE 1
