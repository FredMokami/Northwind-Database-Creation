CREATE SCHEMA fresh_segments;
USE fresh_segments;

-- fresh_segments.interest_map table creation
CREATE TABLE fresh_segments.interest_map (
  id INTEGER,
  interest_name TEXT,
  interest_summary TEXT,
  created_at TIMESTAMP,
  last_modified TIMESTAMP
);

-- Only one column of VALUES interest_map TABLE,there is more
INSERT INTO fresh_segments.interest_map
  (id, interest_name, interest_summary, created_at, last_modified)
VALUES
  ('1', 'Fitness Enthusiasts', 'Consumers using fitness tracking apps and websites.', '2016-05-26 14:57:59', '2018-05-23 11:30:12');
  
 -- update the null values in fresh_segments.interest_map table
UPDATE fresh_segments.interest_map
SET interest_summary = NULL
WHERE interest_summary = '';

SELECT * FROM fresh_segments.interest_map;

-- Remove and update 'safe mode' to allow UPDATES
SET SQL_SAFE_UPDATES=0;
SET SQL_SAFE_UPDATES=1;

-- fresh_segments.interest_metrics table
CREATE TABLE fresh_segments.interest_metrics (
	_month VARCHAR(4),
	_year VARCHAR(4),
	month_year VARCHAR(7),
	interest_id VARCHAR(5),
	composition FLOAT,
	index_value FLOAT,
	ranking INTEGER,
	percentile_ranking FLOAT
	);

-- Alter year and month colums
ALTER TABLE fresh_segments.interest_metrics
CHANGE COLUMN year _year VARCHAR(4);

ALTER TABLE fresh_segments.interest_metrics
CHANGE COLUMN month _month VARCHAR(4);



-- -- Only one column of VALUES in interest_metrics TABLE,there is more
INSERT INTO fresh_segments.interest_metrics
  (_month, _year, month_year, interest_id, composition, index_value, ranking, percentile_ranking)
VALUES
  ('7', '2018', '07-2018', '32486', '11.89', '6.19', '1', '99.86');
  
  
-- Update "_month NULL values" - "fresh_segments.interest_metrics table"
UPDATE fresh_segments.interest_metrics
SET _month = CASE 
		WHEN _month = 'NULL'THEN NULL
		ELSE CAST(_month AS SIGNED)
		END;
        
        
SET SQL_SAFE_UPDATES=0;

-- Update "_year" NULL values
UPDATE fresh_segments.interest_metrics
SET _year = CASE 
		WHEN _year = 'NULL' THEN NULL
		ELSE CAST(_year AS SIGNED)
		END;

        
SELECT * FROM fresh_segments.interest_metrics;

-- Update "month_year" NULL values
UPDATE fresh_segments.interest_metrics
SET month_year = NULL
WHERE month_year = 'NULL';

-- Update "interest_id" NULL values
UPDATE fresh_segments.interest_metrics
SET interest_id = NULL
WHERE interest_id = 'NULL';

-- Checking for duplicates and assign PK - id is the PK for interest_map
SELECT id, COUNT(*) as count
FROM interest_map
GROUP BY id
HAVING COUNT(*) > 1;

/*SELECT id, interest_name, interest_summary, created_at, last_modified, COUNT(*)
FROM fresh_segments.interest_map
GROUP BY id, interest_name, interest_summary, created_at, last_modified
HAVING COUNT(*) > 1;*/

-- Update id as PK for interest_map
ALTER TABLE fresh_segments.interest_map
ADD PRIMARY KEY (id);

SELECT *
FROM fresh_segments.interest_map
WHERE id IS NULL;

DESCRIBE fresh_segments.interest_map;
DESCRIBE fresh_segments.interest_metrics;

SELECT * FROM interest_map LIMIT 5;

SELECT COUNT(interest_id) AS imrecords_count
FROM fresh_segments.interest_metrics;