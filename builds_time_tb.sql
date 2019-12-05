--Refs:
--[1] http://elliot.land/post/redshift-does-not-support-generate-series
--[2] http://elliot.land/post/building-a-date-dimension-table-in-redshift
DROP TABLE date_dimension;

--Cria a tabela
CREATE TABLE date_dimension (
  "date_id" INTEGER NOT NULL PRIMARY KEY,

  -- DATE
  "full_date" DATE NOT NULL,
  "br_format_date" CHAR(10) NOT NULL,
  "us_format_date" CHAR(10) NOT NULL,

  -- YEAR
  "year_number" SMALLINT NOT NULL,
  "year_week_number" SMALLINT NOT NULL,
  "year_day_number" SMALLINT NOT NULL,

  -- QUARTER
  "qtr_number" SMALLINT NOT NULL,

  -- MONTH
  "month_number" SMALLINT NOT NULL,
  "month_name" CHAR(9) NOT NULL,
  "month_day_number" SMALLINT NOT NULL,

  -- WEEK
  "week_day_number" SMALLINT NOT NULL,

  -- DAY
  "day_name" CHAR(9) NOT NULL,
  "day_is_weekday" SMALLINT NOT NULL,
  "day_is_last_of_month" SMALLINT NOT NULL
) DISTSTYLE ALL SORTKEY (date_id);


--Insere as datas na tabela criada
INSERT INTO date_dimension
SELECT cast(seq + 1 AS INTEGER) AS date_id,

		-- DATE
		datum AS full_date,
		TO_CHAR(datum, 'DD/MM/YYYY') :: CHAR(10) AS br_format_date,
		TO_CHAR(datum, 'MM/DD/YYYY') :: CHAR(10) AS us_format_date,

		-- YEAR
		cast(extract(YEAR FROM datum) AS SMALLINT) AS year_number,
		cast(extract(WEEK FROM datum) AS SMALLINT) AS year_week_number,
		cast(extract(DOY FROM datum) AS SMALLINT) AS year_day_number,

		-- QUARTER
		cast(to_char(datum, 'Q') AS SMALLINT) AS qtr_number,

		-- MONTH
		cast(extract(MONTH FROM datum) AS SMALLINT) AS month_number,
		to_char(datum, 'Month') AS month_name,
		cast(extract(DAY FROM datum) AS SMALLINT) AS month_day_number,

		-- WEEK
		cast(to_char(datum, 'D') AS SMALLINT) AS week_day_number,

		-- DAY
		to_char(datum, 'Day') AS day_name,
		CASE 
			WHEN to_char(datum, 'D') IN ('1', '7')
			THEN 0
			ELSE 1
		END AS day_is_weekday,
		CASE
			WHEN extract(DAY FROM (datum + (1 - extract(DAY FROM datum))::INTEGER + INTERVAL '1' MONTH)::DATE -	INTERVAL '1' DAY) = extract(DAY FROM datum)	THEN 1
			ELSE 0
		END AS day_is_first_of_month
FROM
	-- Generate days for the next ~110 years starting from 1920.
	(SELECT '1920-01-01'::DATE + number AS datum,
			number AS seq
	FROM number
	WHERE number < 110 * 365
	) AS DQ
ORDER BY 1;

--Visão geral da tabela
SELECT min(full_date), max(full_date), count(*)
FROM date_dimension;

--Confere a tabela para o ano atual
SELECT *
FROM date_dimension
WHERE year_number = 2019
ORDER BY full_date
LIMIT 100;