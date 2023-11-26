-- CASE STUDY QUESTIONS
USE fresh_segments;

DESCRIBE fresh_segments.interest_metrics;

SET SQL_SAFE_UPDATES=0;
SET SQL_SAFE_UPDATES=1;

-- DATA EXPLORATION AND CLENSING

/* Q1. Update the fresh_segments.interest_metrics table by modifying 
	the month_year column to be a date data type with the start of the month */

/* Add new column to interest_metrics table with DATE data type */

ALTER TABLE fresh_segments.interest_metrics
ADD COLUMN month_year_2 DATE;

-- Update the new 'month_year_2' with 'month_year' values
UPDATE fresh_segments.interest_metrics
SET month_year_2 = DATE_FORMAT(
		STR_TO_DATE(CONCAT(month_year, '-01'), '%m-%Y-%d'), -- Convert 'month_year' to date
		'%Y-%m-%d' -- Format as 'YYYY-MM-DD'
);

-- Drop the Original 'month_year' Column
ALTER TABLE fresh_segments.interest_metrics
DROP COLUMN month_year;

-- Rename 'month_year_2' to 'month_year'
ALTER TABLE fresh_segments.interest_metrics
CHANGE COLUMN month_year_2 month_year DATE;

-- fresh_segments.interest_metrics table structure
DESCRIBE fresh_segments.interest_metrics;


/* Q2. What is count of records in the fresh_segments.interest_metrics 
for each month_year value sorted in chronological order (earliest to latest) 
with the null values appearing first? */

SELECT 
  month_year,
  COUNT(*) as count
FROM fresh_segments.interest_metrics
GROUP BY month_year
ORDER BY month_year ASC; 

-- NULLs appear first when sorting in ascending order in MSQL


/* Q3. What do you think we should do with these null values 
in the fresh_segments.interest_metrics? */

SELECT *
FROM fresh_segments.interest_metrics
WHERE month_year IS NULL;

/* NULL values in 'month_year' indicate missing 'interest_id' values, 
making other fields meaningless; thus, these records should be deleted */

DELETE FROM fresh_segments.interest_metrics
WHERE interest_id IS NULL;

SELECT *
FROM fresh_segments.interest_metrics
WHERE month_year IS NULL;

SELECT *
FROM fresh_segments.interest_metrics
WHERE interest_id IS NULL;

/* Q4. How many interest_id values exist in the fresh_segments.interest_metrics table 
	but not in the fresh_segments.interest_map table? What about the other way around? */

-- Count of interest_id in interest_metrics not interest_map (id)
SELECT COUNT(DISTINCT im.interest_id) AS count_interest_metrics_not_in_map
FROM fresh_segments.interest_metrics AS im
LEFT JOIN fresh_segments.interest_map AS imap
	ON im.interest_id = imap.id
WHERE imap.id IS NULL;

-- Count of id in interest_map not in interest_metrics (interest_id)
SELECT COUNT(DISTINCT imap.id) AS count_interest_map_not_in_metrics
FROM fresh_segments.interest_map AS imap
LEFT JOIN fresh_segments.interest_metrics AS im
	ON imap.id = im.interest_id
WHERE im.interest_id IS NULL;


-- Q5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table
SELECT COUNT(id) AS records_count
FROM fresh_segments.interest_map;

SELECT COUNT(interest_id) AS imrecords_count
FROM fresh_segments.interest_metrics;

SELECT id,
	interest_name,
	COUNT(*) AS records_count
FROM fresh_segments.interest_map imap
JOIN fresh_segments.interest_metrics im
	ON imap.id = im.interest_id
GROUP BY imap.id, interest_name
ORDER BY records_count DESC, imap.id;


-- Q6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where interest_id = 21246 in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.
/* I used INNER JOIN because I wanted check only records
	with matching values in both interest_map 
    and interest_metrics tables*/
SELECT im._month,
	im._year,
    im.month_year,
    im.interest_id,
	im.interest_id,
	im.composition,
	im.index_value,
	im.ranking,
	im.percentile_ranking,
	im.month_year,
	imap.interest_name,
	imap.interest_summary,
	imap.created_at,
	imap.last_modified
FROM fresh_segments.interest_map imap
INNER JOIN fresh_segments.interest_metrics im
	ON imap.id = im.interest_id
WHERE im.interest_id = '21246'
	AND im._month IS NOT NULL;


-- Q7. Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? Do you think these values are valid and why?
/* There are 188 records where month_year is before the created_at. 
	This is owes to the fact that when modifying month_year column 
	a date data type, we set to default 1st as day for every start
    of the month. I therefore think these values are valid */

SELECT COUNT(*)
FROM interest_metrics im
JOIN interest_map imap
	ON im.interest_id = imap.id
WHERE month_year < created_at
	AND im.interest_id IS NOT NULL;
    
SELECT *
FROM interest_metrics im
JOIN interest_map imap
	ON im.interest_id = imap.id
WHERE month_year < created_at
	AND im.interest_id IS NOT NULL;

/*CREATE VIEW summary_view AS
SELECT im._month,
    im._year,
    im.month_year,
    im.interest_id,
    im.composition,
    im.index_value,
    im.ranking,
    im.percentile_ranking,
    imap.interest_name,
    imap.interest_summary,
    imap.created_at,
    imap.last_modified
FROM fresh_segments.interest_map imap
INNER JOIN fresh_segments.interest_metrics im
    ON imap.id = im.interest_id;

SELECT COUNT(*)
FROM summary_view
WHERE month_year < created_at;*/

-- Interest Analysis
/* */
SELECT interest_id
FROM fresh_segments.interest_metrics
GROUP BY interest_id
HAVING COUNT(DISTINCT month_year) = (SELECT COUNT(DISTINCT month_year) FROM fresh_segments.interest_metrics);


