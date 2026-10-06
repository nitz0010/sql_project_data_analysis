/*
Question: What skills are required for the top paying data analyst jobs?
-Use the top 10 highest paying data analyst jobs from the first query
-Add the specific skills required for these roles
-why? It provides a detailed look at which high-paying jobs demand certain skills,
helping job seekers understand which skills to develop that align with top salaries 
*/

WITH top_paying_jobs AS(
    SELECT
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM
    job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    top_paying_jobs DESC;


/*
job_id                                        job_title  salary_year_avg
28   552322                Associate Director- Data Insights         255829.5
61    99305                          Data Analyst, Marketing         232423.0
9   1021647                     Data Analyst (Hybrid/Remote)         217000.0
52   168310                  Principal Data Analyst (Remote)         205000.0
14   731368                  Director, Data Analyst - HYBRID         189309.0
44   310660  Principal Data Analyst, AV Performance Analysis         189000.0
0   1749593                           Principal Data Analyst         186000.0
41   387860                                 ERM Data Analyst         184000.0
*/
