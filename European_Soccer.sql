-- In this exercise, I identified matches played between FC Schalke 04 and FC Bayern Munich. 
SELECT
	-- Select the team long name and team API id
	team_long_name,
	team_api_id
FROM Team_Germany
-- Only include FC Schalke 04 and FC Bayern Munich
WHERE team_long_name IN ('FC Schalke 04', 'FC Bayern Munich');


-- I Created a CASE statement that identifies whether a match in Germany included FC Bayern Munich, FC Schalke 04, or neither as the home team.
-- Identify the home team as Bayern Munich, Schalke 04, or neither
SELECT 
	Case When home_team_api_id = 10189 then 'FC Schalke 04'
        When home_team_api_id = 9823 then 'FC Bayern Munich'
         ELSE 'Other' END AS home_team,
	COUNT(id) AS total_matches
FROM Matches_Germany
-- Group by the CASE statement alias
GROUP BY home_team;