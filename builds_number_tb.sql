--Refs:
--[1] http://elliot.land/post/redshift-does-not-support-generate-series
--[2] http://elliot.land/post/building-a-date-dimension-table-in-redshift


CREATE TABLE IF NOT EXISTS number (
  number INTEGER NOT NULL
) DISTSTYLE ALL SORTKEY (number);

--Nº de registros de números dobra a acada INSERT
INSERT INTO number VALUES (1), (2), (3), (4), (5), (6), (7), (8);
INSERT INTO number SELECT number + 8 FROM number;
INSERT INTO number SELECT number + 16 FROM number;
INSERT INTO number SELECT number + 32 FROM number;
INSERT INTO number SELECT number + 64 FROM number;
INSERT INTO number SELECT number + 128 FROM number;
INSERT INTO number SELECT number + 256 FROM number;
INSERT INTO number SELECT number + 512 FROM number;
INSERT INTO number SELECT number + 1024 FROM number;
INSERT INTO number SELECT number + 2048 FROM number;
INSERT INTO number SELECT number + 4096 FROM number;
INSERT INTO number SELECT number + 8192 FROM number;
INSERT INTO number SELECT number + 16384 FROM number;
INSERT INTO number SELECT number + 32768 FROM number;
INSERT INTO number SELECT number + 65536 FROM number;

--Para checar, roda a query abaixo e lembre que 1+2+3+...+n = n*(n+1)/2
SELECT COUNT(*), SUM(number)
FROM number;