SELECT
    job_posted_date,
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= '50000' THEN 'High Salary'
        WHEN salary_year_avg >= '30000' THEN 'Standard Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM job_postings_fact
WHERE
    job_title_short LIKE '%Data Analyst%'
    AND salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC;
