--Part – A
--1. Create a stored procedure that accepts a date and returns all faculty members who joined on that date.
	CREATE OR ALTER PROCEDURE PR_FACULTY_JOININGDATE
	@DATE DATE
	AS
	BEGIN
	SELECT *
	FROM FACUILTY
	WHERE FACULTYJOININGDATE = @DATE
	END

	EXEC PR_FACULTY_JOININGDATE '2010-07-15'

--2. Create a stored procedure for ENROLLMENT table where user enters either StudentID and returns EnrollmentID, EnrollmentDate, Grade, and Status.
	CREATE OR ALTER PROCEDURE PR_ENROLLMENTDATA
	@STUID INT
	AS
	BEGIN
	SELECT StudentID, CourseID, EnrollmentDate ,Grade ,EnrollmentStatus
	FROM ENROLLMENT
	WHERE STUDENTID = @STUID
	END

	EXEC PR_ENROLLMENTDATA 1

--3. Create a stored procedure that accepts two integers (min and max credits) and returns all courses whose credits fall between these values.
	CREATE OR ALTER PROCEDURE PR_CREDITWISE_COURSENAME
	@MAXCREDIT INT,
	@MINCREDIT INT
	AS
	BEGIN
	SELECT COURSENAME,COURSECREDITS
	FROM COURSE
	WHERE COURSECREDITS BETWEEN  @MINCREDIT AND @MAXCREDIT
	END

	EXEC PR_CREDITWISE_COURSENAME 4,3

--4. Create a stored procedure that accepts Course Name and returns the list of students enrolled in that course.
	CREATE OR ALTER PROCEDURE PR_STUDENTDATA
	@COURSENAME VARCHAR(20)
	AS
	BEGIN 
	SELECT S.STUNAME,C.COURSENAME,E.COURSEID
	FROM ENROLLMENT E JOIN STUDENT S
	ON E.StudentID = S.STUDENTID
	JOIN COURSE C
	ON E.CourseID = C.CourseID
	WHERE COURSENAME = @COURSENAME
	END

	EXEC PR_STUDENTDATA 'DATA STRUCTURES'
    
--5. Create a stored procedure that accepts Faculty Name and returns all course assignments.
	CREATE OR ALTER PROCEDURE PR_FACULTYDATA
	@FACULTYNAME VARCHAR(30)
	AS
	BEGIN
	SELECT DISTINCT F.FacultyDepartment,F.FacultyName,C_A.ClassRoom,F.FacultyID
	FROM COURSE_ASSIGNMENT C_A JOIN FACUILTY F
	ON C_A.FacultyID = F.FacultyID
	WHERE F.FacultyName = @FACULTYNAME
	END

	EXEC PR_FACULTYDATA 'Dr. Singh'

--6. Create a stored procedure that accepts Semester number and Year, and returns all course assignments with faculty and classroom details.
	CREATE OR ALTER PROCEDURE PR_FACULTYDETAILS
	@SEM INT,
	@YEAR INT
	AS
	BEGIN
	SELECT DISTINCT F.FacultyName,F.FacultyID,CA.ClassRoom
	FROM COURSE_ASSIGNMENT CA JOIN FACUILTY F
	ON CA.FacultyID = F.FacultyID
	WHERE Semester = @SEM AND YEAR = @YEAR
	END                                                                 

	EXEC PR_FACULTYDETAILS  4,2024

--Part – B
--7. Create a stored procedure that accepts the first letter of Status ('A', 'C', 'D') and returns enrollment details.
	CREATE OR ALTER PROCEDURE PR_ENROLLSTATUS_DATA
	@FIRST_LETTER VARCHAR(2)
	AS
	BEGIN
	SELECT *
	FROM ENROLLMENT 
	WHERE EnrollmentStatus LIKE @FIRST_LETTER+'%'
	END

	EXEC PR_ENROLLSTATUS_DATA C

--8. Create a stored procedure that accepts either Student Name OR Department Name and returns student data accordingly.
	CREATE OR ALTER PROCEDURE PR_STUDENT_DATA
	@STUNAME VARCHAR(20) = NULL,
	@DEPARTMENTNAME VARCHAR(20)=NULL
	AS
	BEGIN
	SELECT *
	FROM STUDENT
	WHERE STUNAME = @STUNAME OR STUDEPARTMENT = @DEPARTMENTNAME
	END

	EXEC PR_STUDENT_DATA @DEPARTMENTNAME = 'CSE'

--9. Create a stored procedure that accepts CourseID and returns all students enrolled grouped by enrollment status with counts.
	CREATE OR ALTER PROCEDURE PR_STU_DETAILS
	@COURSEID VARCHAR(20)
	AS
	BEGIN
	SELECT COUNT(*) AS TOTAL_STUDENT,EnrollmentStatus
	FROM ENROLLMENT 
	WHERE CourseID = @COURSEID
	GROUP BY EnrollmentStatus
	END

	EXEC PR_STU_DETAILS  'CS101'

--Part – C
--10. Create a stored procedure that accepts a year as input and returns all courses assigned to faculty in that year with classroom details.
	CREATE OR ALTER PROCEDURE PR_FACULTY_COURSE_ASSIGNMENT
	@YEAR INT
	AS
	BEGIN
	SELECT CA.YEAR , CA.COURSEID , F.FACULTYNAME,C.COURSENAME,CA.ClassRoom
	FROM COURSE_ASSIGNMENT CA JOIN FACUILTY F
	ON CA.FacultyID = F.FacultyID
	JOIN COURSE C
	ON CA.COURSEID = C.COURSEID
	WHERE CA.YEAR = @YEAR
	END

	EXEC PR_FACULTY_COURSE_ASSIGNMENT 2024

--11. Create a stored procedure that accepts From Date and To Date and returns all enrollments within that range with student and course details.
	CREATE OR ALTER PROCEDURE PR_ENROLLMENTS_DATA
	@INITALDATE DATE,
	@FINALDATE DATE
	AS
	BEGIN
	SELECT *
	FROM ENROLLMENT
	WHERE EnrollmentDate BETWEEN @INITALDATE AND @FINALDATE
	END

	EXEC PR_ENROLLMENTS_DATA '2021-07-01' , '2022-05-01'

--12. Create a stored procedure that accepts FacultyID and calculates their total teaching load (sum of credits of all courses assigned)
	CREATE OR ALTER PROCEDURE PR_FACULTY_TEACHING_LOAD
	@FACULTYID INT
	AS
	BEGIN
	SELECT  F.FacultyID,F.FACULTYNAME,
	SUM(C.CourseCredits) AS TOTAL_CREDITS
	FROM COURSE_ASSIGNMENT CA JOIN  COURSE C
	ON CA.COURSEID = C.COURSEID
	JOIN  FACUILTY F
	ON CA.FacultyID = F.FacultyID
	WHERE F.FacultyID = @FACULTYID
	GROUP BY F.FacultyID, F.FacultyName
	END

	EXEC PR_FACULTY_TEACHING_LOAD 102

-- SP TO FIND THE NUMBER OF COURSES OFFERED BY GIVEN DEPATRMENT. ( USING OUT PARAMETER )