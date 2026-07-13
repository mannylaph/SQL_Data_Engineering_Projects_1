/*
Question: What are the top paying skills for data engineers?

- Calculate the median salary for each skill required in data engineering positions

- Focus on remote positions with specified salaried

- Include skill frequency to identify both salary and demand

- Why?
    - Helps identify which sills command the highest compensation while also showing how common those sills are, provideing a a more complete picture for skill development priorities.

    - The median is used instead of the average to reduce impact of outlier salaries.




*/


select
    sd.skills,
    round(MEDIAN(jpf.salary_year_avg),0) as median_salary,
    count(jpf.*) as demand_count
from job_postings_fact as jpf
inner join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
inner join skills_dim sd
    on sjd.skill_id = sd.skill_id
    where job_title_short = 'Data Engineer' and job_work_from_home = True
    group by sd.skills
    having count(jpf.*)>100
    order by median_salary desc
limit 25;

/*


┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ golang     │      184000.0 │          912 │
│ terraform  │      184000.0 │         3248 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ django     │      155000.0 │          265 │
│ bitbucket  │      155000.0 │          478 │
│ crystal    │      154224.0 │          129 │
│ c          │      151500.0 │          444 │
│ atlassian  │      151500.0 │          249 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ ruby       │      150000.0 │          736 │
│ airflow    │      150000.0 │         9996 │
│ node       │      150000.0 │          179 │
│ css        │      150000.0 │          262 │
│ redis      │      149000.0 │          605 │
│ vmware     │      148798.0 │          136 │
│ ansible    │      148798.0 │          475 │
│ jupyter    │      147500.0 │          400 │
└────────────┴───────────────┴──────────────┘
  25 rows                         3 columns




## Key Takeaways: Top-Paying Skills for Data Engineers

- **Niche skills pay the highest premium** — Rust ($210K) and Golang/Terraform (~$184K) top the list despite low demand, suggesting specialization pays off.

- **Cloud/DevOps expertise commands top dollar** — Terraform stands out with both high salary ($184K) *and* strong demand (3,248 postings), making it the best ROI skill on this list.

- **Big data tools remain valuable** — Snowflake, Spark, and Kafka consistently appear in the top-paying tier, reinforcing their importance in modern data infrastructure.

- **Programming versatility matters** — Knowledge of Python, Java, and Scala continues to correlate with higher-paying opportunities.

*/