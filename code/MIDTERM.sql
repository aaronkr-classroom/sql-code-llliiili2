--1. 테블 생성하기(4개 테이블)
--2. join문 사용하기 (3개))
--3. SELECT문 사용해서 데이터 탐색하기(3개)

CREATE TABLE COURSE
(
id VARCHAR (20) NOT NULL,
name VARCHAR(20) NOT NULL,
teacher_id VARCHAR(40) NOT NULL
)

INSERT INTO COURSE (id, name, teacher_id) 
VALUES 
('1', 'database design', '1'),
('2', 'English literature', '2'),
('3', 'python programming', '1');

CREATE TABLE STUDENT
(
id VARCHAR (20) NOT NULL,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(40) NOT NULL
)

INSERT INTO STUDENT (id, first_name, last_name)
VALUES
('1', 'Shreya', 'bain'),
('2', 'Rianna', 'foster'),
('3', 'Yosef', 'Naylor');

CREATE TABLE STUDENT_COURSE
(
student_id VARCHAR (20) NOT NULL,
course_id VARCHAR(20) NOT NULL
)

INSERT INTO STUDENT_COURSE (student_id, course_id)
VALUES
('1', '2'),
('1', '2'),
('2', '1'),
('2', '2'),
('2', '3'),
('3', '1');

CREATE TABLE TEACHER
(
id VARCHAR (20) NOT NULL,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(40) NOT NULL
)

INSERT INTO TEACHER (id, first_name, last_name)
VALUES
('1', 'Taylor', 'Booker'),
('2', 'Shara-Louis', 'Blake');

SELECT STUDENT.id, STUDENT.first_name, STUDENT.last_name, STUDENT_COURSE.course_id
FROM STUDENT
INNER JOIN STUDENT_COURSE
ON STUDENT.id = STUDENT_COURSE.student_id;

SELECT TEACHER.id, TEACHER.first_name, TEACHER.last_name, STUDENT_COURSE.student_id, STUDENT_COURSE.course_id
FROM TEACHER
INNER JOIN COURSE
ON TEACHER.id = COURSE.teacher_id
INNER JOIN STUDENT_COURSE
ON COURSE.id = STUDENT_COURSE.course_id;

SELECT COURSE.id, COURSE.name, STUDENT_COURSE.student_id
FROM COURSE
INNER JOIN STUDENT_COURSE
ON COURSE.id = STUDENT_COURSE.course_id;

SELECT STUDENT_COURSE.course_id, COURSE.name, STUDENT_COURSE.student_id, TEACHER.id AS teacher_id
FROM STUDENT_COURSE
INNER JOIN COURSE
ON STUDENT_COURSE.course_id = COURSE.id
INNER JOIN TEACHER
ON COURSE.teacher_id = TEACHER.id
ORDER BY STUDENT_COURSE.student_id;
