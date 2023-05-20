-- Link to excercise https://techtfq.com/blog/practice-writing-sql-queries-using-real-dataset
-- I just used the link as inspiration for an excersice and to check my answers, my coding is selfwrote and different.

use olimpiadas;

-- How many olympics games have been held?
select count(distinct Games) as Games_Held from olim_events;

-- List down all Olympics games held so far.
SELECT Year, Season, City  FROM olim_events
group by Games;

-- Mention the total no of nations who participated in each olympics game?
select count(distinct NOC) as No_Countries, Games from olim_events 
group by Games 
order by Games;

-- Which year saw the highest and lowest no of countries participating in olympics?
(SELECT * FROM 
	(SELECT Year, COUNT(Year) AS Cantidad FROM 
		(SELECT DISTINCT NOC, Year FROM olim_events) a
  GROUP BY Year
  ORDER BY Cantidad DESC) b
LIMIT 1)
union
(SELECT * FROM
	(SELECT Year, COUNT(Year) AS Cantidad FROM
		(SELECT DISTINCT NOC, Year FROM olim_events) a
  GROUP BY Year
  ORDER BY Cantidad asc) b
LIMIT 1);


-- Which nation has participated in all of the olympic games?
select * from ( 
	select count(Games) as olim_participation, NOC from (
		select distinct NOC, Games from olim_events order by NOC ) a
	group by NOC ) b
where olim_participation = (
	select count(distinct Games) as Games_Held from olim_events);


-- Identify the sport which was played in all summer olympics.
select * from (
	select count(Year) as Times_Played_Summer, Sport from (
		select distinct Sport, Year from olim_events where Season like "Summer") a	
	group by Sport
	order by Sport desc) a
where Times_Played_Summer = (
	select count(distinct Games) from olim_events where Season like "Summer") ;

-- Which Sports were just played only once in the olympics?
select Sport, Games from (
	select count(Sport) as Times_Played, Sport, Games from (
		select distinct Sport, Year, Games from olim_events)a
	group by Sport) a
where Times_Played = 1;

-- Fetch the total no of sports played in each olympic games.
select count(sport) as Sports_Played, Games from (
	Select Distinct Sport, Games from olim_events) a
group by Games;

-- Fetch details of the oldest athletes to win a gold medal.
select * from (
	select Name, Age, Sex, Games, Sport, Event, Medal from olim_events
	where Medal like "%Gold%" and Age <> "NA"
	order by Age desc) a
where Age = 
	(select max(Age) from olim_events where Medal like "%Gold%" and Age <> "NA");

-- Find the Ratio of male and female athletes participated in all olympic games.
select m.Males + f.Females as Total_Participants, m.Males / (m.Males + f.Females) as Males_Perc, m.males / f.females as Ratio from
(select count(sex) as Males from olim_events where sex like "M") m ,
(select count(sex) as Females from olim_events where sex like "F") f;

-- Fetch the top 5 athletes who have won the most gold medals.
SELECT COUNT(Medal) AS Medals_Won, Name FROM 
	(SELECT Medal, Name from olim_events
    WHERE Medal like "%Gold%") a
GROUP BY Name
order by Medals_Won desc
limit 5;

-- Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
Select b.Medal_Count, c.region as Country from
	(select NOC, count(Medal) as Medal_Count from
		(select NOC, Medal from olim_events where not Medal like "%NA%") a
	group by NOC
	order by Medal_Count desc) b
right join 
	(Select NOC, Region from regions) c
on b.NOC = c.NOC
limit 5;

-- List down total gold, silver and broze medals won by each country.
SELECT b.region as Country, a.Gold_Medals, a.Silver_Medals, a.Bronze_Medals from
	(SELECT NOC, 
		   SUM(CASE WHEN Medal LIKE '%Gold%' THEN 1 ELSE 0 END) AS Gold_Medals,
		   SUM(CASE WHEN Medal LIKE '%Silver%' THEN 1 ELSE 0 END) AS Silver_Medals,
		   SUM(CASE WHEN Medal LIKE '%Bronze%' THEN 1 ELSE 0 END) AS Bronze_Medals
	FROM olim_events
	GROUP BY NOC
	ORDER BY Gold_Medals DESC, Silver_Medals DESC, Bronze_Medals DESC) a
right join 
	(select * from regions) b
on a.NOC = b.NOC;

-- List down total gold, silver and broze medals won by each country corresponding to each olympic games.
select a.Games, b.Country, a.Gold_Medals, a.Silver_Medals, a.Bronze_Medals from
	(select NOC, Games,
		sum(case when Medal like "%Gold%" then 1 else 0 end) as Gold_Medals,
		sum(case when Medal like "%Silver%" then 1 else 0 end) as Silver_Medals,
		sum(case when Medal like "%Bronze%" then 1 else 0 end) as Bronze_Medals
		from olim_events
		group by NOC, Games
		order by games asc) a
right join
	(select NOC, region as Country from regions) b
on a.NOC = b.NOC
order by a.Games asc, b.country;

-- Identify which country won the most gold, most silver and most bronze medals in each olympic games.

select a.Games, a.NOC, a.Gold_Medals from
	(select NOC, Games, sum(case when Medal like "%Gold%" then 1 else 0 end) as Gold_Medals
	from olim_events
	group by Games, NOC) a 
left join
	(select max(Gold_Medals) as Max_Gold_Medals, Games from
		(select Games, sum(case when Medal like "%Gold%" then 1 else 0 end) as Gold_Medals from olim_events
	group by Games, NOC) b
	) c 
on a.Games = c.Games AND a.Gold_Medals = c.Max_Gold_Medals
group by Games
order by a.Games asc
 


-- Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
-- Which countries have never won gold medal but have won silver/bronze medals?
-- In which Sport/event, India has won highest medals.
-- Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.