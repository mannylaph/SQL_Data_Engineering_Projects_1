--- Categorizing Categorical Values
--- Classify the  'jobtitle' column values as"
    ---Data Analyst
    ---Data Engineer
    ---Data Scientist

with job_title_clean as(
    select
        job_title,
        Lower(trim(job_title)) as job_title_lower
    from job_postings_fact
   
)

select  
    job_title,
case when job_title_lower like '%data%' and job_title_lower like '%analyst%' then 'Data Analyst'
     when job_title_lower like '%data%' and job_title_lower like '%engineer%' then 'Data Engineer'
     when job_title_lower like '%data%' and job_title_lower like '%scientist%' then 'Data Scientist'
     else 'Others'
end as job_category
from 
    job_title_clean
order by random()
limit 20;


--- NULLIF
select
    median(nullif(salary_year_avg,0)) year_avg,
    median(nullif(salary_hour_avg,0)) hour_avg
from
    job_postings_fact
where 
    salary_hour_avg is not null or salary_year_avg is not null
limit 10;

-- Coalesce
select  
    salary_hour_avg,
    salary_year_avg,
    round(Coalesce(salary_year_avg,salary_hour_avg*2080),0) computed_year_avg,
    round(Coalesce(salary_hour_avg,salary_year_avg/2080),0) computed_hour_avg
from
    job_postings_fact
where salary_hour_avg is not null or salary_year_avg is not null
limit 10;


--- Simplified with Coalesce
select
    job_title_short,
    round(Coalesce(salary_year_avg,salary_hour_avg*2080),0) standardized_salary,
    round(Coalesce(salary_hour_avg,salary_year_avg/2080),0) computed_hour_avg,
    salary_hour_avg,
case
    when standardized_salary < 75_000 then 'Low'
    when standardized_salary < 150_000 then 'medium'
    when standardized_salary  is null then 'missing'
    else 'high'
end as salary_bucket
from
    job_postings_fact
order by standardized_salary desc 
limit 20;