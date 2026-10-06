SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN(
    SELECT
        company_id
    FROM 
        job_postings_fact
    WHERE
        job_no_degree_mention = true
ORDER BY 
    company_id
);


/*
Find the companies that have the most job openings.
-Get the total number of job postings per company id(job_postings_fact)
-Return the total number of jobs with the company name (company_dim)
*/

WITH company_job_counts AS(
SELECT
    company_id,
    COUNT(*) AS total_job_postings
FROM 
    job_postings_fact
GROUP BY
    company_id
)
SELECT 
    company_dim.name AS company_name,
    company_job_counts.total_job_postings
FROM 
    company_dim
LEFT JOIN company_job_counts ON company_dim.company_id = company_job_counts.company_id
ORDER BY 
    total_job_postings DESC;