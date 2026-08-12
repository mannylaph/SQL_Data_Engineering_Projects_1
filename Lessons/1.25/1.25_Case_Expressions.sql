-- Bucket Salaries
select
    job_title_short,
    salary_hour_avg,
case when salary_hour_avg <25 then 'Low'
     when salary_hour_avg< 50 then 'medium'
     else 'high'
end as salary_category
from
    job_postings_fact
where salary_hour_avg is not null
    limit 20;


--- handling nulls
select
    job_title_short,
    salary_hour_avg,
case 
    when salary_hour_avg is null then 'missing'
    when salary_hour_avg <25 then 'Low'
     when salary_hour_avg< 50 then 'medium'
     else 'high'
end as salary_category
from
    job_postings_fact
--where salary_hour_avg is not null
    limit 20;




--- Categorizing Categorical Values
--- Classify the  'jobtitle' column values as"
    ---Data Analyst
    ---Data Engineer
    ---Data Scientist

select  
    job_title_short,
case when job_title like '%Data%' and job_title like '%Analyst%' then 'Data Analyst'
     when job_title like '%Data%' and job_title like '%Engineer%' then 'Data Engineer'
     when job_title like '%Data%' and job_title like '%Scientist%' then 'Data Scientist'
     else 'Others'
end as job_category,
    job_title,
from 
    job_postings_fact
order by random()
limit 20;


-- Conditional Aggregation
-- Calculate Median Salaries for Different Buckets
    --  < $100k
    --  >= 100k
select  
      job_title_short,
      count(*) total_posting,
      Median
      (
        case when salary_year_avg < 100_000 then salary_year_avg
        end
      ) as median_low_salary,
        Median
      (
        case when salary_year_avg > 100_000 then salary_year_avg
        end
      ) as median_high_salary
from    
    job_postings_fact
where salary_year_avg is not null
group by job_title_short;


/*
Final Example: Conditonal Calculations
Compute a standardized_salary using yearly salary and adjusted hourly salary (e.g. 2080 hours/year)
Categorize salaries into tiers of:
    -- 75k 'Low'
    -- 75k - 150 'Medium'
    -- >= 150k 'High'
*/

with salaries as (

select
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
case
    when salary_year_avg is not null then salary_year_avg
    when salary_hour_avg is not null then salary_hour_avg *2080
end as standardized_salary
from    
    job_postings_fact
-- where salary_hour_avg is not null or salary_hour_avg is not null
)

select
    *,
case
    when standardized_salary < 75_000 then 'Low'
    when standardized_salary < 150_000 then 'medium'
    when standardized_salary  is null then 'missing'
    else 'high'
end as salary_bucket
from
    salaries
--order by standardized_salary 
limit 20;