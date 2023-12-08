--QUESTION:  write a SQL query to find the students who have the highest GPA in each course.

--Create and insert values into tables (Enrollments Table, Students Table & Courses Table)
create table [Enrollments Table] 
(EnrollmentId int, StudentId int, CourseID int,
Semester varchar (30))

insert into [Enrollments Table] values
('1', '1', '101', 'Fall 20222'),
('2', '2', '102', 'Fall 2022'),
('3', '3', '103', 'Fall 2022'),
('4', '1', '104', 'Spring 2023'),
('5', '2', '105', 'Spring 2023')

create table [Students Table]
(StudentID int, FirstName varchar(20), LastName varchar(50),
Age int, GPA decimal (4,1))

insert into [Students Table] values
('1', 'Alice', 'Johnson', '20', '3.5'),
('2', 'Bob', 'Smith', '22', '3.8'),
('3', 'Carol', 'Brown', '21', '3.2'),
('4', 'David', 'Lee', '23', '3.9'),
('5', 'Eve', 'Davis', '20', '3.4')

create table [Courses Table]
(CourseID int, CourseName varchar(30), Credits int)

insert into [Courses Table] values
('101', 'Math', '3'),
('102', 'English', '4'),
('103', 'History', '3'),
('104', 'Chemistry', '4'),
('105', 'Computer Science', '3')

--Select all three tables to confirm data entry.
select * from [Smart Joshua's Job]..[Enrollments Table]
select * from [Smart Joshua's Job]..[Students Table]
select * from [Smart Joshua's Job]..[Courses Table]

--Students who have the highest GPA in each course.
select concat(firstname, ' ', lastname)FullName, en.StudentId,
semester, CourseName, Credits, GPA
from [Smart Joshua's Job]..[enrollments table] en
join [Smart Joshua's Job]..[students table] st
on en.studentid = st.studentid
join [Smart Joshua's Job]..[courses table] cr
on en.courseid = cr.courseid
order by GPA DESC