/*
Question: What are the most in-demand skills for data engineer?
- Identify the top 10 skills data engineers
- Focus on the remote job postings
- Why? Retrieves the top 10 sills with the highest demand in the remote jobs providing insights into the most valuable skills for data engineer jobs.

*/

select
    sd.skills,
    count(jpf.*) as demand_count
from job_postings_fact as jpf
inner join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
inner join skills_dim sd
    on sjd.skill_id = sd.skill_id
    where job_title_short = 'Data Engineer' and job_work_from_home = True
    group by sd.skills
    order by demand_count desc
limit 10;


/*
┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘
  10 rows         2 columns




Takeaway:

1. SQL and Python are non-negotiable, each nearly 2x the demand of AWS, the next closest skill.

2. Cloud demand splits across AWS, Azure, and GCP, so single-platform specialization limits your job pool.

3. Spark, Airflow, Snowflake, and Databricks make up the expected "modern stack" of processing, orchestration, and warehousing.

4. Java's strong showing (7,267) signals some DE roles skew backend/platform, not just analytics.



*/