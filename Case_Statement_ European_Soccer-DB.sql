-- BASIC CASE STATEMENT

-- Select the team's long name and API id from the teams_germany table.
-- Filter the query for FC Schalke 04 and FC Bayern Munich using IN, giving you the team_api_IDs needed for the next step.
SELECT
	team_long_name,
	team_api_id
FROM teams_germany
-- Only include FC Schalke 04 and FC Bayern Munich
WHERE team_long_name in ('FC Schalke 04', 'FC Bayern Munich');

-- Using Case Statement to identify matches played between FC Schalke 04 and FC Bayern Munich.
-- Identify the home team as Bayern Munich, Schalke 04, or neither
SELECT 
	Case When hometeam_id = 10189 then 'FC Schalke 04'
        When hometeam_id = 9823 then 'FC Bayern Munich'
         ELSE 'Other' END AS home_team,
	COUNT(id) AS total_matches
FROM matches_germany
-- Group by the CASE statement alias
GROUP BY home_team;

-- CASE statements comparing column values
-- CASE statement to identify matches as home wins, home losses, or ties.

SELECT 
	-- Select the date of the match
	date,
	-- Identify home wins, losses, or ties
	Case When home_goal > away_goal then 'Home win!'
        When home_goal < away_goal then 'Home loss :(' 
        Else 'Tie' End As outcome
FROM matches_spain;

-- Retrieved away team's identity using Left JOIN
SELECT 
	m.date,
	--Select the team long name column and call it 'opponent'
	t.team_long_name AS opponent, 
	-- Complete the CASE statement with an alias
	CASE WHEN m.home_goal > m.away_goal THEN 'Home win!'
         WHEN m.home_goal < m.away_goal THEN 'Home loss :('
         ELSE 'Tie' END AS outcome
FROM matches_spain AS m
-- Left join teams_spain onto matches_spain
LEFT JOIN teams_spain AS t
ON m.awayteam_id = t.team_api_id;

-- Filtered for matches where the home team is FC Barcelona (id = 8634)
--CASE statement to identify Barcelona's away team games (id = 8634) as wins, losses, or ties using Left Join.
--  retrieved identity of the home team opponent.
-- Queried filtered to only include matches where Barcelona was the away team.
SELECT 
	m.date,
	t.team_long_name AS opponent,
    -- Complete the CASE statement with an alias
	Case When m.home_goal > m.away_goal then 'Barcelona win!'
        When m.home_goal < m.away_goal then 'Barcelona loss :(' 
        Else 'Tie' End As outcome 
FROM matches_spain AS m
LEFT JOIN teams_spain AS t 
ON m.awayteam_id = t.team_api_id
-- Filter for Barcelona as the home team
WHERE m.hometeam_id = 8634; 

--CASE statement identifying Barcelona or Real Madrid as the home team using the hometeam_id column.
SELECT 
	date,
	-- Identify the home team as Barcelona or Real Madrid
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END AS home,
    -- Identify the away team as Barcelona or Real Madrid
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END AS away
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);
	  
-- CASE statement identifying who won each match using Logical Operators to identify Barcelona or Real Madrid as the winner.
SELECT 
	date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as home,
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as away,
	-- Identify all possible match outcomes
	Case When home_goal > away_goal AND hometeam_id = 8634 Then 'Barcelona win!'
        WHEN home_goal > away_goal AND hometeam_id = 8633 Then 'Real Madrid win!'
        WHEN home_goal < away_goal AND awayteam_id = 8634 Then 'Barcelona win!'
        WHEN home_goal < away_goal AND awayteam_id = 8633 Then'Real Madrid win!'
        Else 'Tie!' End as outcome
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);
	  
-- CASE statement so that only Bologna's home and away wins are identified.
-- Select the season and date columns
SELECT 
	season,
	date,
    -- Identify when Bologna won a match
	Case When hometeam_id = 9857 
        And home_goal > away_goal 
        Then 'Bologna Win'
		When awayteam_id = 9857 
        And away_goal > home_goal 
        Then 'Bologna Win' 
		End AS outcome
FROM matches_italy;

-- CASE statement in the WHERE clause to filter all NULL
-- Select the season, date, home_goal, and away_goal columns
SELECT 
	season,
	date,
	home_goal,
	away_goal
FROM matches_italy
WHERE
-- Exclude games not won by Bologna
	CASE WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
         WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win' 
         END IS NOT NULL;

-- CASE statement that identifies the id of matches played in the 2012/2013 season. Using Joins
SELECT 
	c.name AS country,
    -- Count games from the 2012/2013 season
	COUNT(CASE WHEN m.season = '2012/2013' 
          	   THEN m.id ELSE NULL END) AS matches_2012_2013
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;

-- CASE WHEN statements counting the matches played in each country across the 3 seasons using JOINs
SELECT 
	c.name AS country,
    -- Count matches in each of the 3 seasons
	Count(Case When m.season = '2012/2013' Then m.id End) AS matches_2012_2013,
	Count(Case When m.season = '2013/2014' Then m.id End) AS matches_2013_2014,
	Count(Case When m.season = '2014/2015' Then m.id End) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
Group By country;

-- CASE statement that returns a 1 for every match you want to include, and a 0 for every match to exclude. 
-- Using Joins and Group By
SELECT 
	c.name AS country,
    -- Sum the total records in each season where the home team won
	Sum(Case When m.season = '2012/2013' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 End) AS matches_2012_2013,
 	Sum(Case When m.season = '2013/2014' And m.home_goal > m.away_goal  
        THEN 1 Else 0 End) AS matches_2013_2014,
        Sum(Case When m.season = '2013/2014' And m.home_goal > m.away_goal  
        THEN 1 Else 0 End) AS matches_2013_2014,
	Sum(Case When m.season = '2014/2015' And m.home_goal > m.away_goal  
        THEN 1 Else 0 End) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;

-- Calculating percent with CASE and AVG
-- Calculating the Average number of ties for 2 seasons, rounding them up to 2 significant places. 
-- Using Joins
SELECT 
	c.name AS country,
    -- Round the percentage of tied games to 2 decimal points
	Round(AVG(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2013_2014,
	Round(AVG(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;

--