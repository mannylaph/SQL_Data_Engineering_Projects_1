/*

Question: What are the most optimal skills for data engineers - balancing both demand and salary?

> Create a ranking column that combines demand count and median salary to identify the most valuable skills

> Focus on only remote Data Engineer postitions with specified annual salaries.

> Why?
    -> This approach highlights skills that balance market demand and financial reward. It weighs core skills appropriately, rather than letting rare, outlier sills distort the results.
*/

select
    sd.skills,
    round(MEDIAN(jpf.salary_year_avg),0) as median_salary,
    -- count(jpf.*) as demand_count,
    count(jpf.*) as demaand_count,
    round(ln(count(jpf.*)),2) as ln_demand_count,
   round((round(MEDIAN(jpf.salary_year_avg),0) * ln_demand_count)/1_000_000,2) as optimal_score
from job_postings_fact as jpf
inner join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
inner join skills_dim sd
    on sjd.skill_id = sd.skill_id
    where job_title_short = 'Data Engineer' and job_work_from_home = True and salary_year_avg is not null
    group by sd.skills
    having count(jpf.*)>100
    order by optimal_score desc
limit 25;

/*

┌────────────┬───────────────┬───────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demaand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │     int64     │     double      │    double     │
├────────────┼───────────────┼───────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │           193 │            5.26 │          0.97 │
│ python     │      135000.0 │          1133 │            7.03 │          0.95 │
│ aws        │      137320.0 │           783 │            6.66 │          0.91 │
│ sql        │      130000.0 │          1128 │            7.03 │          0.91 │
│ airflow    │      150000.0 │           386 │            5.96 │          0.89 │
│ spark      │      140000.0 │           503 │            6.22 │          0.87 │
│ snowflake  │      135500.0 │           438 │            6.08 │          0.82 │
│ kafka      │      145000.0 │           292 │            5.68 │          0.82 │
│ azure      │      128000.0 │           475 │            6.16 │          0.79 │
│ java       │      135000.0 │           303 │            5.71 │          0.77 │
│ scala      │      137290.0 │           247 │            5.51 │          0.76 │
│ git        │      140000.0 │           208 │            5.34 │          0.75 │
│ kubernetes │      150500.0 │           147 │            4.99 │          0.75 │
│ databricks │      132750.0 │           266 │            5.58 │          0.74 │
│ redshift   │      130000.0 │           274 │            5.61 │          0.73 │
│ gcp        │      136000.0 │           196 │            5.28 │          0.72 │
│ nosql      │      134415.0 │           193 │            5.26 │          0.71 │
│ hadoop     │      135000.0 │           198 │            5.29 │          0.71 │
│ pyspark    │      140000.0 │           152 │            5.02 │           0.7 │
│ docker     │      135000.0 │           144 │            4.97 │          0.67 │
│ mongodb    │      135750.0 │           136 │            4.91 │          0.67 │
│ go         │      140000.0 │           113 │            4.73 │          0.66 │
│ r          │      134775.0 │           133 │            4.89 │          0.66 │
│ github     │      135000.0 │           127 │            4.84 │          0.65 │
│ bigquery   │      135000.0 │           123 │            4.81 │          0.65 │
└────────────┴───────────────┴───────────────┴─────────────────┴───────────────┘
  25 rows


  ## Key Takeaways: Weighted Optimal Score (Salary x Log-Demand)

- **Terraform ranks #1 overall (0.97)** — the log-demand transform confirms it's not a fluke; high salary *and* demand hold up even after discounting for scale.

- **Python and SQL remain top-tier (0.95, 0.91)** despite having ~6x Terraform's demand, proving their value isn't just volume — they still command strong salaries at scale.

- **AWS holds steady in the top 4 (0.91)** — the best-balanced cloud skill once demand is normalized.

- **Score decay is gradual, not cliff-like** — from Airflow (0.89) down to BigQuery (0.65), the drop-off is smooth, meaning most of these 25 skills are reasonably safe bets, not just the top 3.


*/