-- Count Rows - Aggregation only

select
    count(*)
from
    job_postings_fact;



-- Count Rows - Window Function
select
    job_id,
    count(*) over()
from
    job_postings_fact;


-- Partition by - Find hourly salary
select  
    job_id,
    job_title_short,
    salary_hour_avg,
    company_id,
    avg(salary_hour_avg) over(Partition by job_title_short, company_id)
from
    job_postings_fact
where salary_hour_avg is not null
order by random()
limit 20;


-- Order by : Rank Hourly salary



-- Partition by and order by : Running average hourly salary
select  
    job_posted_date,
    job_title_short,
    salary_hour_avg,
   sum(salary_hour_avg) over(Partition by job_title_short
                              order by job_posted_date
                              ) running_hr_avg
from
    job_postings_fact
where salary_hour_avg is not null and job_title_short = 'Data Engineer'
order by 2,1
limit 10;

select 
    job_id,
    job_title_short,
    salary_hour_avg,
    rank() over(Partition by job_title_short order by salary_hour_avg desc) rank_hr_salary
from
    job_postings_fact
where salary_hour_avg is not null
order by salary_hour_avg desc,job_title_short
limit 10;


-- Ranking Functions - RANK() vs DENSE_RANK()
select 
    job_id,
    job_title_short,
    salary_hour_avg,
    dense_rank() over(order by salary_hour_avg desc) rank_hr_salary
from
    job_postings_fact
where salary_hour_avg is not null
order by salary_hour_avg desc
limit 140;

--- Row Number : Generate Surrogate IDs
select
    row_number() over(order by job_posted_date) SID,
    *
from
    job_postings_fact
order by job_posted_date
limit 10;


-- LAG
select
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    lag(salary_year_avg) over(
                        Partition by company_id
                        order by job_posted_date
    ) previous_posting_salary,
    salary_year_avg - lag(salary_year_avg) over(
                        Partition by company_id
                        order by job_posted_date
    ) salary_change
from
    job_postings_fact
where salary_year_avg is not null
order by company_id, job_posted_date
limit 60;


-- LEAD
select
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg) over(
                        Partition by company_id
                        order by job_posted_date
    ) next_posting_salary,
    salary_year_avg - LEAD(salary_year_avg) over(
                        Partition by company_id
                        order by job_posted_date
    ) salary_change
from
    job_postings_fact
where salary_year_avg is not null
order by company_id, job_posted_date
limit 60;