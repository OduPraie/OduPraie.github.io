--Question 1: Write a query to find all the players in the "Arizona" team.

SELECT *
FROM [dbo].[01-Football Players Data]
WHERE Team = 'Arizona'

--Question 2: Write a query to find all the players who play as a "WR" (Wide Receiver).

 SELECT *
 FROM [dbo].[01-Football Players Data]
 WHERE Pos = 'WR'

 --Question 3: Write a query to list all players taller than 6 feet 2 inches (74 Inches).

SELECT * 
FROM [dbo].[01-Football Players Data]
WHERE Inches > '74'

--Question 4: Write a query to find all players who attended the "Washington" college.

SELECT * 
FROM [dbo].[01-Football Players Data]
WHERE College = 'Washington State'

--Question 5: Write a query to list players who are 25 years old or younger

SELECT * 
FROM [dbo].[01-Football Players Data]
WHERE Age <= '25'

--Question 6: Write a query to find all players with missing Age data.

SELECT * 
FROM [dbo].[01-Football Players Data]
WHERE Age IS NULL

--Question 7: Write a query to find players who are rookies (Exp = 'R')

SELECT *                               -- Due to data type issues (column data type is small int) any Exp that is 'R' returned as Null
FROM [dbo].[01-Football Players Data]
WHERE Exp IS NULL

--Question 8: Write a query to find the tallest player on the "New Orleans" team

SELECT *, MAX(Inches) OVER() AS [Tallest player in New Orleans]
FROM [dbo].[01-Football Players Data]
WHERE Team = 'New Orleans'

--Question 9: Write a query to find players weighing more than 250 pounds

SELECT *
FROM [dbo].[01-Football Players Data]
WHERE Wt > 250

--Question 10: Write a query to calculate the average height of players at each position

SELECT *, AVG(Inches) OVER(PARTITION BY Pos) AS [Average height]
FROM [dbo].[01-Football Players Data]

--Question 11: Write a query to find the heaviest player for each position

SELECT *, MAX(Wt) OVER(PARTITION BY Pos) AS [Position]
FROM [dbo].[01-Football Players Data]

--Question 12: Write a query to rank players by age within their team. If two players have the same age, rank them by their weight.

SELECT *, RANK() OVER(PARTITION BY Age ORDER BY Wt)
FROM [dbo].[01-Football Players Data]

--Question 13: Write a query to calculate the average height (in inches) for all players older than 25 years

SELECT AVG(Inches) AS [Average height of 25+ year olds]
FROM [dbo].[01-Football Players Data]
WHERE Age > 25

--Question 14: Write a query to find all players whose height is greater than the average height of their respective team

WITH Team_average_height AS(
SELECT * ,AVG(Inches) OVER(PARTITION BY Team) AS ath
FROM [dbo].[01-Football Players Data])

SELECT *
FROM Team_average_height
WHERE Inches> ath

--Question 15: Write a query to find all players who share the same last name

SELECT *, RANK() OVER(PARTITION BY LastName ORDER BY NAME)
FROM [dbo].[01-Football Players Data]

--Question 16: Write a query to find the players with the minimum height for each position

SELECT *, MIN(Inches) OVER(PARTITION BY Pos) AS [Minimum height per position]
FROM [dbo].[01-Football Players Data]

--Question 17: Write a query to get the number of players for each team grouped by their experience level

SELECT *, COUNT(NAME) OVER(PARTITION BY TEAM,Exp ORDER BY Exp) AS [Number of players in each team by experience group]
FROM [dbo].[01-Football Players Data]

select Team,Exp,count(NAME) AS [Number of players in each team by experience group]                       --This is to get the number of players in each group of exp level
from [dbo].[01-Football Players Data]
group by Team, Exp
order by Exp


--Question 18: Write a query to find the tallest and shortest players from each college

With CTE AS (
SELECT *, RANK() OVER(PARTITION BY College ORDER BY Inches ) AS [Shortest players per college],RANK() OVER(PARTITION BY College ORDER BY Inches DESC) AS [Tallest players per college]
FROM [dbo].[01-Football Players Data])

SELECT *
FROM CTE
WHERE [Shortest players per college] = 1 OR [Tallest players per college] = 1

--Question 19: Write a query to find all players whose weight is above the average weight for their respective position

WITH Overlimit AS(
SELECT *,AVG(Wt) OVER(PARTITION BY Pos) AS [Average wieght per position]
FROM [dbo].[01-Football Players Data])

SELECT *
FROM Overlimit
WHERE Wt > [Average wieght per position]

--Question 20: Write a query to calculate the percentage of players in each position for every team

WITH CTE AS (
SELECT *,COUNT(NAME) OVER(PARTITION BY Team,Pos ORDER BY Pos ) AS [Count per position in teams] 
        ,COUNT(NAME) OVER(PARTITION BY Team) AS [Team player count] 
FROM [dbo].[01-Football Players Data])

SELECT [Team],[Pos], [Count per position in teams], [Team player count], ([Count per position in teams]*100)/[Team player count] AS [percentile per position per team]
FROM CTE
