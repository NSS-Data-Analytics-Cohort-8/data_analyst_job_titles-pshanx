--1.	How many rows are in the data_analyst_jobs table?

SELECT COUNT (*)
FROM data_analyst_jobs;

	--ANSWER: 1793



--2.	Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?

SELECT *
FROM data_analyst_jobs
LIMIT 10;
	
	--ANSWER: ExxonMobil



--3.	How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?

SELECT COUNT (location)
FROM data_analyst_jobs
WHERE location = 'TN';

SELECT COUNT (location)
FROM data_analyst_jobs
WHERE location = 'KY' OR location ='TN';

	--ANSWER: 21 in TN, 27 in TN or KY.



--4.	How many postings in Tennessee have a star rating above 4?

SELECT COUNT (star_rating)
FROM data_analyst_jobs
WHERE location = 'TN'
AND star_rating > 4;

	--ANSWER: 3

	--Tinker break
		SELECT star_rating
		FROM data_analyst_jobs;
		
		SELECT COUNT (star_rating)
		FROM data_analyst_jobs
		WHERE star_rating ISNULL;
			--this returns 0. 
		
		SELECT COUNT (*)
		FROM data_analyst_jobs
		WHERE star_rating ISNULL;
			--I understand that these two queries are not equivalent, but I don't know why.
			--END OF TINKER



--5.	How many postings in the dataset have a review count between 500 and 1000?

SELECT COUNT (*)
FROM data_analyst_jobs
WHERE review_count BETWEEN 500 AND 1000;

	--ANSWER: 151



--6.	Show the average star rating for companies in each state. The output should show the state as `state` and the average rating for the state as `avg_rating`. Which state shows the highest average rating?

SELECT location AS state, AVG(star_rating) AS avg_rating
FROM data_analyst_jobs
GROUP BY location
ORDER BY avg_rating DESC;

	--ANSWER: Nebraska with an average rating of 4.19. 
	--FUN FACT: I had to look up which state is NE.



--7.	Select unique job titles from the data_analyst_jobs table. How many are there?

SELECT DISTINCT (title)
FROM data_analyst_jobs;

SELECT COUNT (DISTINCT (title))
FROM data_analyst_jobs;

	--ANSWER: 881 unique job titles.



--8.	How many unique job titles are there for California companies?

SELECT COUNT(DISTINCT (title))
FROM data_analyst_jobs
WHERE location = 'CA';

	--ANSWER: 230



--9.	Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations?

SELECT DISTINCT (company), ROUND(AVG(star_rating), 2) as companywide_avg_rating
FROM data_analyst_jobs
WHERE review_count >5000
GROUP BY company
ORDER BY companywide_avg_rating desc;

	--ANSWER: 41
	
	
	
			--Tinker Break
			
			SELECT DISTINCT(company), COUNT(location) AS number_of_locations
			FROM data_analyst_jobs
			GROUP BY company
			ORDER BY number_of_locations DESC;
			
			SELECT company, location
			FROM data_analyst_jobs
			WHERE company = 'Capgemini';
			
			SELECT company, location AS by_state, COUNT(location) AS per_state
			FROM data_analyst_jobs
			WHERE company = 'Capgemini'
			GROUP BY by_state, company
			ORDER BY by_state ASC, per_state DESC;
			
				--This last query was the end result of 5 minutes of tinkering. Documentation is proving to be difficult. Life moves fast in SQL.
				--the clause (ORDER BY by_state ASC, per_state DESC;) doesn't have much meaning when hunting down a single company, but keeps things nice and clean when we're zoomed out.

			SELECT company, location AS by_state, COUNT(location) AS per_state
			FROM data_analyst_jobs
			GROUP BY by_state, company
			ORDER BY by_state ASC, per_state DESC;
			
			--END of TINKER



--10.	Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating?

SELECT DISTINCT (company), ROUND(AVG(star_rating), 2) as companywide_avg_rating
FROM data_analyst_jobs
WHERE review_count >5000
GROUP BY company
ORDER BY companywide_avg_rating desc;

	--ANSWER: American Express with 4.199, rounded to 4.20



--11.	Find all the job titles that contain the word ‘Analyst’. How many different job titles are there? 

--YES DUPES
SELECT title
FROM data_analyst_jobs
WHERE title LIKE '%Analyst%';

SELECT COUNT(title)
FROM data_analyst_jobs
WHERE title LIKE '%Analyst%';

--NO DUPES
SELECT DISTINCT(title)
FROM data_analyst_jobs
WHERE title LIKE '%Analyst%';

SELECT COUNT(DISTINCT(title))
FROM data_analyst_jobs
WHERE title LIKE '%Analyst%';
	
	--ANSWER: 1636(YES DUPES) of 754 (NO DUPES)

--12.	How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?

SELECT title
FROM data_analyst_jobs
WHERE title NOT LIKE '%Analyst%' 
AND title NOT LIKE '%Analytics%';

	--ANSWER: 39, and they all lack proper capitalization.



--**BONUS:**
--You want to understand which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks. 

SELECT domain
FROM data_analyst_jobs
WHERE skill = 'SQL' 
AND days_since_posting >21;

	--CORRECTION

SELECT domain, COUNT(domain) AS count_domain
FROM data_analyst_jobs
WHERE skill = 'SQL' 
AND days_since_posting >21
GROUP by domain;



-- - Disregard any postings where the domain is NULL. 

SELECT domain
FROM data_analyst_jobs
WHERE skill = 'SQL' 
AND days_since_posting >21
AND domain NOTNULL;

	--CORRECTION
	
SELECT domain, COUNT(domain) AS count_domain
FROM data_analyst_jobs
WHERE skill = 'SQL' 
AND days_since_posting >21
AND domain NOTNULL
GROUP by domain;



-- - Order your results so that the domain with the greatest number of `hard to fill` jobs is at the top. 

SELECT domain
FROM data_analyst_jobs
WHERE skill = 'SQL' 
AND days_since_posting >21
AND domain NOTNULL
GROUP by domain
ORDER by COUNT(domain) DESC;

	--CORRECTION

SELECT domain, COUNT(domain) AS count_domain
FROM data_analyst_jobs
WHERE skill = 'SQL' 
AND days_since_posting >21
AND domain NOTNULL
GROUP by domain
ORDER by COUNT(domain) DESC;

	--CHECKING THE WORK
	
SELECT domain, COUNT(domain) AS count_domain, days_since_posting
FROM data_analyst_jobs
WHERE skill = 'SQL' 
AND days_since_posting >21
AND domain NOTNULL
GROUP by domain, days_since_posting
ORDER by COUNT(domain) DESC;



--  - Which three industries are in the top 4 on this list? How many jobs have been listed for more than 3 weeks for each of the top 4?

	--ANSWER: 
		--Consulting and Business Services - 5 jobs
		--Consumer Goods and Services - 2 jobs
		--Computers and Electronics - 1 job
		--Internet and Software - 1 job