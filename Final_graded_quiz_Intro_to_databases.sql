CREATE DATABASE SportsClub;
USE SportsClub;
SELECT * FROM Players;

-- Players Table
CREATE TABLE Players (
	playerID INT
	,playerName VARCHAR(50)
	,age INT
	,PRIMARY KEY (playerID)
	);
    
-- Insert values into Players table
INSERT INTO Players (
	playerID
	,playerName
	,age
	)
VALUES (
	1
	,"Jack"
	,25
	);
    
-- INSERT three extra rows in the Players table
INSERT INTO Players (playerID, playerName, age)
VALUES 
    (2, "Karl", 20),
    (3, "Mark", 21),
    (4, "Andrew", 22);
    
SELECT PlayerName FROM Players WHERE PlayerID = 2;

-- All Players
SELECT playerName AS Player 
FROM Players;

-- Update age to 23 for ID 3
UPDATE Players
SET age = 22
WHERE playerID = 3;

-- Delete record for ID 4
DELETE FROM Players WHERE playerID = 4;

-- Evaluate if the playerID is odd or even
SELECT playerID % 2 AS Parity, playerName
FROM Players;

SELECT playerID, playerID % 2 AS Parity FROM Players;

SELECT playerName, playerID,
	CASE 
		WHEN playerID % 2 = 0 THEN "Even"
			ELSE "odd"
		END AS Parity
	FROM Players;
    
-- Names of players older than 25 years (NOT FOR This Players DB)
SELECT playerName, age FROM Players WHERE age > 25;

-- Names of players older than 25 years (NOT FOR This Players DB)
CREATE TABLE Course(
					CourseID INT NOT NULL, CourseName VARCHAR(50), PRIMARY KEY (courseID),
                    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID));
