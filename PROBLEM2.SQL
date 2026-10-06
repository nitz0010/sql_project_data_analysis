SELECT
    skill_id,
    skills AS skill_name
FROM skills_dim
where skill_id IN(
    SELECT
        skill_id
    FROM 
        skills_job_dim
ORDER BY 
    skill_id
);
WITH skills_job_dim AS(
SELECT
    skill_id,
    COUNT(*) AS total_skills
FROM 
    skills_job_dim
GROUP BY
    skill_id
)
SELECT 
    skills_dim.skills AS skill_name,
    skills_job_dim.total_skills
FROM 
    skills_dim
LEFT JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY 
    total_skills DESC;


WITH company_job_counts AS(
SELECT
    company_id,
    COUNT(*) AS total_job_postings
FROM 
    company_dim
GROUP BY
    company_id
)
SELECT
    name AS company_name,
    CASE
        WHEN company_job_counts.total_job_postings < 10 THEN 'small'
        WHEN company_job_counts.total_job_postings BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size
FROM 
    company_dim
    LEFT JOIN company_job_counts ON company_dim.company_id = company_job_counts.company_id
ORDER BY 
    company_job_counts.total_job_postings DESC;

WITH company_job_counts AS (
    SELECT
        company_id,
        COUNT(*) AS total_job_postings
    FROM 
        job_postings_fact -- Fixed: Changed from company_di to the job postings table
    GROUP BY
        company_id
)
SELECT
    company_dim.name AS company_name,
    company_dim.company_id AS ID,

    CASE
        WHEN total_job_postings < 10 THEN 'Small' -- Fixed: Matched alias from CTE
        WHEN total_job_postings BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size
FROM 
    company_dim
LEFT JOIN company_job_counts 
    ON company_dim.company_id = company_job_counts.company_id
ORDER BY 
    total_job_postings DESC;

/*
find the count of number of remote jobs posting per skill
-display the top 5 skills by their demand in remote jobs
-include the skill id,name and the count of postings requiring the skill
*/


WITH remote_job_skills AS (SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM 
    skills_job_dim AS skills_to_job
INNER JOIN JOB_postings_fact AS job_postings
    ON job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = TRUE AND
    job_postings.job_title_short = 'Data Analyst'
GROUP BY
    skill_id
)
SELECT 
    skills.skill_id,
    skills.skills AS skill_name,
    remote_job_skills.skill_count
FROM 
    remote_job_skills
INNER JOIN skills_dim AS skills
    ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    remote_job_skills.skill_count DESC
LIMIT 5;