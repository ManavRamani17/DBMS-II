--Part – A

--1.Create a cursor Course_Cursor to fetch all rows from COURSE table and display them.
	DECLARE @CourseID VARCHAR(10),@CourseName VARCHAR(100) ,@CourseCredits INT ,@CourseDepartment VARCHAR(50) , @CourseSemester INT
	DECLARE  CR_DISPLAY_COURSE_TABLE CURSOR
	FOR
	SELECT * FROM COURSE

	OPEN CR_DISPLAY_COURSE_TABLE
	FETCH NEXT FROM CR_DISPLAY_COURSE_TABLE INTO  @CourseID ,@CourseName  ,@CourseCredits ,@CourseDepartment , @CourseSemester 

	WHILE @@FETCH_STATUS=0
	BEGIN
			PRINT 'ID:'+ @CourseID
			PRINT 'NAME:'+ @CourseName
			PRINT 'CREDITS:'+ CAST(@CourseCredits AS VARCHAR(5))
			PRINT 'DEPARTMENT:'+ @CourseDepartment
			PRINT 'SEMESTER:'+ CAST(@CourseSemester AS VARCHAR(5))
			PRINT ''
			FETCH NEXT FROM CR_DISPLAY_COURSE_TABLE INTO  @CourseID ,@CourseName  ,@CourseCredits ,@CourseDepartment , @CourseSemester 

	END
	CLOSE CR_DISPLAY_COURSE_TABLE
	DEALLOCATE CR_DISPLAY_COURSE_TABLE

--2.Create a cursor Student_Cursor_Fetch to fetch records in form of StudentID_StudentName (Example: 1_Raj Patel).
    DECLARE @STUID INT ,@STUNAME VARCHAR(20)
	DECLARE STUDENT_CURSOR_FETCH CURSOR
	FOR
	SELECT StudentID,StuName FROM STUDENT
	OPEN STUDENT_CURSOR_FETCH
	FETCH NEXT FROM STUDENT_CURSOR_FETCH INTO  @STUID ,@STUNAME

	WHILE @@FETCH_STATUS=0
	BEGIN
	PRINT CAST(@STUID AS VARCHAR(5)) + '_'+@STUNAME
	FETCH NEXT FROM STUDENT_CURSOR_FETCH INTO  @STUID ,@STUNAME
	END

	CLOSE STUDENT_CURSOR_FETCH
	DEALLOCATE STUDENT_CURSOR_FETCH

--3.Create a cursor to find and display all courses with Credits greater than 3.
	DECLARE @CID VARCHAR(10),@CName VARCHAR(100) ,@CCredits INT ,@CDepartment VARCHAR(50) , @CSemester INT
	DECLARE CR_COURSE_CREDITS CURSOR
	FOR 
		SELECT * FROM COURSE 
		WHERE CourseCredits > 3
	OPEN CR_COURSE_CREDITS
	FETCH NEXT FROM CR_COURSE_CREDITS INTO @CID ,@CName, @CCredits, @CDepartment, @CSemester

	WHILE @@FETCH_STATUS=0
		BEGIN
			PRINT 'ID:'+ @CID
			PRINT 'NAME:'+ @CName
			PRINT 'CREDITS:'+ CAST(@CCredits AS VARCHAR(5))
			PRINT 'DEPARTMENT:'+ @CDepartment
			PRINT 'SEMESTER:'+ CAST(@CSemester AS VARCHAR(5))
			PRINT ''
			FETCH NEXT FROM CR_COURSE_CREDITS INTO @CID ,@CName, @CCredits, @CDepartment, @CSemester

		END

	CLOSE CR_COURSE_CREDITS
	DEALLOCATE CR_COURSE_CREDITS

--4.Create a cursor to display all students who enrolled in year 2021 or later.
	DECLARE @SID INT ,@SName VARCHAR(15) ,@SEmail VARCHAR(15) ,@SPhone VARCHAR(13) ,@SDepartment VARCHAR(20) ,@SDateOfBirth DATE  ,@SEnrollmentYear INT
	DECLARE CR_STUDENT_DATA CURSOR
	FOR
		SELECT StudentID ,StuName ,StuEmail ,StuPhone ,StuDepartment ,StuDateOfBirth ,StuEnrollmentYear 
		FROM STUDENT
		WHERE StuEnrollmentYear >= 2021
	OPEN CR_STUDENT_DATA
	FETCH NEXT FROM CR_STUDENT_DATA INTO  @SID ,@SName ,@SEmail ,@SPhone ,@SDepartment  ,@SDateOfBirth  ,@SEnrollmentYear

	WHILE @@FETCH_STATUS=0
		BEGIN
			PRINT 'ID:'+ CAST(@SID AS VARCHAR(15))
			PRINT 'NAME:'+ @SName
			PRINT 'EMAIL:'+@SEmail
			PRINT 'PHONE:'+ @SPhone
			PRINT 'DEPARTMENT:'+ @SDepartment
			PRINT 'DATEOFBIRTH:'+ CAST(@SDateOfBirth AS VARCHAR(15))
			PRINT 'ENROLLMENTYEAR:'+ CAST(@SEnrollmentYear AS VARCHAR(5))
			PRINT ''
			FETCH NEXT FROM CR_STUDENT_DATA INTO  @SID ,@SName ,@SEmail ,@SPhone ,@SDepartment  ,@SDateOfBirth  ,@SEnrollmentYear
		END

	CLOSE CR_STUDENT_DATA
	DEALLOCATE CR_STUDENT_DATA

--5.Create a cursor Course_CursorUpdate that retrieves all courses and increases Credits by 1 for courses with Credits less than 4.
	DECLARE @C_NAME VARCHAR(20),@C_CREDITS INT,@C_ID VARCHAR(10)
	DECLARE Course_CursorUpdate CURSOR
	FOR
		SELECT CourseID,CourseName,CourseCredits
		FROM COURSE
		WHERE CourseCredits < 4
	OPEN Course_CursorUpdate
	FETCH NEXT FROM Course_CursorUpdate INTO @C_ID, @C_NAME ,@C_CREDITS

	WHILE @@FETCH_STATUS=0
		BEGIN
			UPDATE COURSE
			SET CourseCredits = CourseCredits+1
			WHERE CourseID = @C_ID
			PRINT 'CourseName:'+  @C_NAME
			PRINT 'CourseCredits:'+CAST(@C_CREDITS + 1 AS VARCHAR(5))
			PRINT ''
			FETCH NEXT FROM Course_CursorUpdate INTO  @C_ID,@C_NAME ,@C_CREDITS
		END

		CLOSE Course_CursorUpdate
		DEALLOCATE Course_CursorUpdate
		
	
--6.Create a Cursor to fetch Student Name with Course Name (Example: Raj Patel is enrolled in Database Management System)
	DECLARE @S_NAME VARCHAR(20), @COURSE_NAME VARCHAR(20)
	DECLARE CR_STU_DATA CURSOR
	FOR 
		SELECT S.StuName,C.CourseName 
		FROM ENROLLMENT E INNER JOIN STUDENT S
		ON E.StudentID = S.StudentID
		INNER JOIN COURSE C
		ON E.CourseID = C.CourseID
	OPEN CR_STU_DATA
	FETCH NEXT FROM CR_STU_DATA INTO @S_NAME, @COURSE_NAME

	WHILE @@FETCH_STATUS=0
		BEGIN
			PRINT @S_NAME+' is enrolled in  ' +@COURSE_NAME
			PRINT ''
			FETCH NEXT FROM CR_STU_DATA INTO @S_NAME, @COURSE_NAME
		END

		CLOSE CR_STU_DATA
		DEALLOCATE CR_STU_DATA
	
--7.Create a cursor to insert data into new table if student belong to ‘CSE’ department.(create new table CSEStudent with relevant columns)
	CREATE TABLE CSESTUDENT (StudentID INT,StuName VARCHAR(100),StuEmail VARCHAR(100),StuPhone VARCHAR(15),StuDepartment VARCHAR(50),StuDateOfBirth DATE ,StuEnrollmentYear INT)

	DECLARE @Student_ID INT,@Stu_Name VARCHAR(20),@Stu_Email VARCHAR(20),@Stu_Phone VARCHAR(15),@Stu_Department VARCHAR(20),@Stu_DateOfBirth DATE ,@Stu_EnrollmentYear INT
	DECLARE CR_NEW_STUDENT CURSOR
	FOR
		SELECT StudentID ,StuName ,StuEmail ,StuPhone ,StuDepartment ,StuDateOfBirth ,StuEnrollmentYear 
		FROM STUDENT
		WHERE STUDEPARTMENT = 'CSE'
	OPEN CR_NEW_STUDENT
	FETCH NEXT FROM CR_NEW_STUDENT INTO  @Student_ID ,@Stu_Name,@Stu_Email,@Stu_Phone ,@Stu_Department ,@Stu_DateOfBirth ,@Stu_EnrollmentYear 

	WHILE @@FETCH_STATUS=0
		BEGIN
			INSERT INTO CSESTUDENT VALUES (@Student_ID ,@Stu_Name,@Stu_Email,@Stu_Phone ,@Stu_Department ,@Stu_DateOfBirth ,@Stu_EnrollmentYear)
			FETCH NEXT FROM CR_NEW_STUDENT INTO  @Student_ID ,@Stu_Name,@Stu_Email,@Stu_Phone ,@Stu_Department ,@Stu_DateOfBirth ,@Stu_EnrollmentYear 

		END

		CLOSE CR_NEW_STUDENT
		DEALLOCATE CR_NEW_STUDENT
		SELECT * FROM CSESTUDENT

--Part – B

--8.Create a cursor to update all NULL grades to 'F' for enrollments with Status 'Completed'
	DECLARE @EnrollmentID INT ,@StudentID INT,@Course_ID VARCHAR(10),@EnrollmentDate DATE ,@Grade VARCHAR(2),@EnrollmentStatus VARCHAR(20)
	DECLARE CR_UPDATE_GRADES CURSOR
	FOR
		SELECT *
		FROM ENROLLMENT
		WHERE GRADE IS NULL AND EnrollmentStatus = 'COMPLETED'
	OPEN CR_UPDATE_GRADES
	FETCH NEXT FROM CR_UPDATE_GRADES INTO  @EnrollmentID ,@StudentID ,@Course_ID,@EnrollmentDate ,@Grade,@EnrollmentStatus

	WHILE @@FETCH_STATUS=0
		BEGIN
			UPDATE ENROLLMENT
			SET GRADE = 'F' , EnrollmentStatus = 'COMPLETED'
			WHERE EnrollmentID = @EnrollmentID

			PRINT 'EnrollmentID:' + CAST(@EnrollmentID AS VARCHAR(5))
			PRINT 'StudentID:' + CAST(@StudentID AS VARCHAR(5))
			PRINT 'CourseID:' + @Course_ID
			PRINT 'EnrollmentDate:' + CAST(@EnrollmentDate AS VARCHAR(5))
			PRINT 'Grade:' + @Grade
			PRINT 'EnrollmentStatus:' + @EnrollmentStatus
			PRINT ''
			FETCH NEXT FROM CR_UPDATE_GRADES INTO  @EnrollmentID ,@StudentID ,@Course_ID,@EnrollmentDate ,@Grade,@EnrollmentStatus
		END

		CLOSE CR_UPDATE_GRADES
		DEALLOCATE CR_UPDATE_GRADES

--9.Cursor to show Faculty with Course they teach (EX: Dr. Sheth teaches Data structure)
	DECLARE @FacultyName VARCHAR(15),@COURSE__NAME VARCHAR(20)
	DECLARE CR_FACULTY_WITH_COURSE CURSOR
	FOR
		SELECT F.FacultyName , C.Coursename 
		FROM COURSE_ASSIGNMENT C_A INNER JOIN FACUILTY F
		ON C_A.FacultyID = F.FacultyID
		INNER JOIN COURSE C
		ON C_A.CourseID = C.CourseID
	OPEN CR_FACULTY_WITH_COURSE
	FETCH NEXT FROM CR_FACULTY_WITH_COURSE INTO @FacultyName ,@COURSE__NAME

	WHILE @@FETCH_STATUS=0
		BEGIN
			PRINT  @FacultyName + 'TEACHES' + @COURSE__NAME
			PRINT ''
			FETCH NEXT FROM CR_FACULTY_WITH_COURSE INTO @FacultyName ,@COURSE__NAME
		END

	CLOSE CR_FACULTY_WITH_COURSE
	DEALLOCATE CR_FACULTY_WITH_COURSE

--Part – C

--10.Cursor to calculate total credits per student (Example: Raj Patel has total credits = 15)
	 DECLARE @STUDENT_NAME VARCHAR(20),@CREDITS INT
	 DECLARE CR_CAL_CREDITS_PER_STUDENT CURSOR
	 FOR
		SELECT S.StuName , SUM(C.CourseCredits) AS TOTAL_CREDITS
		FROM ENROLLMENT E INNER JOIN STUDENT S
		ON E.StudentID = S.StudentID
		INNER JOIN COURSE C
		ON E.CourseID = C.CourseID
		GROUP BY StuName
	 OPEN  CR_CAL_CREDITS_PER_STUDENT
	 FETCH NEXT FROM CR_CAL_CREDITS_PER_STUDENT INTO @STUDENT_NAME ,@CREDITS

	 WHILE @@FETCH_STATUS=0
		 BEGIN
			PRINT @STUDENT_NAME + ' has total credits = ' + CAST(@CREDITS AS VARCHAR(5))
			PRINT '' 
			FETCH NEXT FROM CR_CAL_CREDITS_PER_STUDENT INTO @STUDENT_NAME ,@CREDITS
		 END
	 
	 CLOSE CR_CAL_CREDITS_PER_STUDENT
	 DEALLOCATE CR_CAL_CREDITS_PER_STUDENT
