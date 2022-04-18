-- Day 7/100 is for cleaning the Indian Premier league (IPL) deliveries and matches dataset between 2017 and 2019 in SQL. 

-- dataset is publicly available on Kaggle(https://www.kaggle.com/ramjidoolla/ipl-data-set). 

--Change date format from general to date in excel/spreadsheet before importing into Sqlite

-- Write query to fetch all the duplicate date with their corresponding team 1 and 2 from the matches table
Select date, team1, team2
FROM
(
SELECT *,
row_number() over (PARTITION BY date, team1, team2) rn 
FROM matches
) dup
WHERE dup.rn > 1

-- Remove rows with NULL Umpire1 and Umpire2
DELETE
FROM matches
WHERE umpire1 is NULL and umpire2 is NULL

-- Remove the Umpire2 Column since there is no data from 2016 - 2018
ALTER TABLE matches
DROP umpire3

-- Highest win by run is 146 by Mumbai Indians
SELECT Season,	city,	date,	team1,	team2, winner,
max(win_by_runs) highest_win_by_run
FROM matches

-- The highest toss winner is Sunrisers Hyderabad
SELECT Season,	city,	date,	team1,	team2, winner,
max(toss_winner) highest_toss_winner
FROM matches