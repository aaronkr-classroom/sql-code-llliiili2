CREATE TABLE char_data_types(
	char_column char(10),
	varchar_column varchar(10),
	text_column text
);
INSERT INTO char_data_types
VALUES
	('abc', 'abc', 'abc'),
	('defghij', 'defghij', 'defghij');
SELECT * FROM char_data_types;

--숫자 릴레이션 만들
CREATE TABLE num_data_types (
	numeric_colume numeric(20, 5),
	real_column real,
	double_column double precision
);

INSERT INTO num_data_types
VALUES
	(.7, .7, .7),
	(2.13579, 2.13579, 2.13579),
	(2.1357987654321, 2.1357987654321, 2.1357987654321);

	SELECT * FROM num_data_types;

--날짜/시간 릴레이션 만들기

CREATE TABLE data_time_types(
	timestamp_col timestamp with time zone,
	interval_col interval
);

INSERT INTO data_time_types
VALUES
	('2024-09-24 12:10 KST', '2 days'),
	('2024-10-01 08:00 +9', '1 month'),
	('2024-10-31 00:00 Australia/Melbourne', '1 century'),
	(now(), '1 week');
SELECT
    timestamp_col,
    interval_col,
    timestamp_col - interval_col AS new_date
FROM data_time_types;

--CAST 함수()
SELECT timestamp_col, CAST(timestamp_col AS varchar(10))
FROM data_time_types;

SELECT numeric_colume,
       CAST(numeric_colume AS integer),
       CAST(numeric_colume AS text)
FROM num_data_types;

--SELECT CAST(char_column AS integer) FROM char_data_types;--오류 발생:;
