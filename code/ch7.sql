--숫자 내장 함수
SELECT ABS(17), ABS(-17), CEIL(3.28), FLOOR(4.97);

SELECT 학번, 
	SUM(기말성적)::FLOAT / COUNT(*) AS 평균성적
	--ROUND(SUM(기말성적)::FLOAT / COUNT(*), 2)
FROM 수강2
GROUP BY 학번;

SELECT LENGTH(소속학과), RIGHT(학번, 2), REPEAT('*', 나이), 
	CONCAT(소속학과, '학과')
FROM 학생;

SELECT SUBSTRING(주소, 1, 2), REPLACE(휴대폰번호, '-', '*')
FROM 학생;

SELECT 신청날짜, DATE_TRUNC('MONTH', 신청날짜) + INTERVAL '1 MONTH - 1 DAY' AS 마지막날
FROM 수강
WHERE EXTRACT(YEAR FROM 신청날짜) = 2019;

SELECT CURRENT_TIMESTAMP, 신청날짜 - DATE '2019-01-01' AS 일수차이
FROM 수강;

SELECT 신청날짜,
	TO_CHAR(신청날짜, 'Mon/DD/YY') AS 형식1,
	TO_CAHR(신청날짜, 'YYYY"년"MM"월"DD"일"') AS 형식2
FROM 수강;

CREATE OR REPLACE PROCEDURE InsertOrUpdateCourse(
	In CourseNo VARCHAR(4),
	In CourseName VARCHAR(20),
	In CourseRoom CHAR(3),
	In CourseDept VARCHAR(20),
	In CourseCredit INT
)
LANGUAGE plpgsql
AS $$
DECLARE
	Count INT;
BEGIN
	SELECT COUNT(*) INTO Count FROM 과목 WHERE 과목번호 = CourseNo;

	IF Count = 0 THEN
		INSERT INTO 과목(과목번호, 이름, 강의실, 개설학과, 시수)
		VALUES(CourseName, CourseName, CourseRoom, CourseDept, CourseCredit);
	ELSE--과목이 존재하면 기존 과목 업데이트
		UPDATE 과목
		SET 이름 = CourseName, 강의실 = CourseRoom, 개설학과 = CourseDept, 시수 = CourseCredit
		WHERE 과목번호 = Course;
	END IF;
END;
$$;

CALL InsertOrUpdateCourse('c006', '연극학개론', '310', '교양학부', 2);
SELECT * FROM 과목;

CALL InsertOrUpdateCourse('c006', '연극학개론', '410', '교양학부', 1);
SELECT * FROM 과목;

CREATE OR REPLACE PROCEDURE SelectAveragerOfBsetScore(
	In Score INT,
	OUT Count INT
)
LANGUAGE plpgsql
AS $$
DECLARE
	NoMoreData BOOLEAN DEFAULT FALSE;
	Midterm INT;
	Final INT;
	Best INT;
	ScoreListCursor CURSOR FOR SELECT 중간성적, 기말성적 FROM 수강;
BEGIN
	Count := 0;--Count 초기화
	OPEN ScoreListCursor--커서를 열고 각 레코드 반복
	LOOP
		FETCH ScoreListCursor INTO Midterm, Final;
		EXIT WHEN NOT FOUND;

		IF Midterm > Final THEN
			Best := Midterm;
		ELSE
			BEST := Final;
		END IF;
		
		--주어진 점수 이상인 경우 Count 증가
		IF Best >= Score THEN
			COUNT := Count + 1;
		END IF;
	END LOOP;
	CLOSE ScoreListCursor;
END;
$$;

DO $$
DECLARE Count INT;
BEGIN
	CALL SelectAverageOfBestScore(95, Count);
	RAISE NOTICE 'Count: %', Count;
END;
$$;

CREATE TABLE 남녀학생총수
	(성별 CHAR(1) NOT NULL DEFAULT 0,
	인원수 INT NOT NULL DEFAULT 0,
	PRIMARY KEY (성별));
INSERT INTO 남녀학생총수 SELECT '남', COUNT(*) FROM 학생 WHERE 성별 = '남';
INSERT INTO 남녀학생총수 SELECT '여', COUNT(*) FROM 학생 WHERE 성별 = '여';
SELECT * FROM 남녀학생총수;

CREATE OR REPLACE TRIGGER AfterInsertStudent()
RETURNS TRIGGER AS $$
BEGIN
	IF (NEW.성별 = '남') THEN
		UPDATE 남녀학생총수 SET 인원수 = 인원수 + 1 WHERE 성별 = '남';
	ELSIF (NEW.성별 = '여') THEN
		UPDATE 남녀학생총수 SET 인원수 = 인원수 + 1 WHERE 성별 = '여';
	END IF;
	RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE after_insert_student
AFTER INSERT ON 학생 FOR EACH ROW
EXECUTE FUNCTION AfterInsertStudent();

INSERT INTO 학생
VALUES ('s008', '최동석', '경기 수원', 2, 26, '남', '010-8888-6666', '컴퓨터');

SELECT * FROM 남녀학생총수;

CREATE OR REPLACE FUNCTION Fn_Grade(grade CHAR)
RETURNS TEXT AS $$
BEGIN
	 CASE grade
	 	WHEN 'A' THEN RETURN '최우수';
		 WHEN 'B' THEN RETURN '우수';
		 WHEN 'C' THEN RETURN '보통';
		 ELSE RETURN '미흡';
		END CASE;
	END;
	$$ LANGUAGE plpgsql;

	SELECT 학번, 과목번호, 평가학점, Fn_Grade(평가학점) AS 평가등급 FROM 수강;
		 
