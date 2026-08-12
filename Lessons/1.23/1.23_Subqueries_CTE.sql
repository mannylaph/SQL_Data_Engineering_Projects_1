Select *
from(
    select *
    from job_postings_fact
    where salary_year_avg is not null
    or salary_hour_avg is not null
)
limit 10;


-- CTE

with valid_salaries as
(
    select *
    from job_postings_fact
    where salary_year_avg is not null
    or salary_hour_avg is not null

)

select * from valid_salaries
limit 100;

-- Scenario 1 - Subquery in 'SELECT'
-- Show each job's salary next to the overall market median:

select 
    job_title_short,
    salary_year_avg,
    (
        select
            median(salary_year_avg)
        from    
            job_postings_fact
    )market_median_salary
from    
    job_postings_fact
where salary_year_avg is not null
order by salary_year_avg desc
limit 10;


-- Scenario 2 - Subquery in FROM
-- Stage only jobs that are remote before aggregating:
select 
    job_title_short,
    median(salary_year_avg) median_salary,
    (
        select
            median(salary_year_avg)
        from    
            job_postings_fact
        where job_work_from_home = True
    )market_remote_median_salary
from    
    (select
        job_title_short,
        salary_year_avg
    from job_postings_fact
    where job_work_from_home = True)
--where salary_year_avg is not null
group by job_title_short
--order by salary_year_avg desc
limit 10;



--- Scenario 3 - Subquery in 'Having'
--- Keep only job titles whose median salary is above the overall median:
select 
    job_title_short,
    median(salary_year_avg) median_salary,
    (
        select
            median(salary_year_avg)
        from    
            job_postings_fact
        where job_work_from_home = True
    )market_remote_median_salary
from    
    (select
        job_title_short,
        salary_year_avg
    from job_postings_fact
    where job_work_from_home = True)
--where salary_year_avg is not null
group by job_title_short
--order by salary_year_avg desc
having median(salary_year_avg)>(
    select
    median(salary_year_avg)
    from job_postings_fact
    where job_work_from_home = true
)
limit 10;


-- CTE example
--- Compare how much more (or less) remote roles pay compared to onsite role for each job title.
--- Use a CTE to calculate the median salary by title and work arrangement, then compare those medians.


with title_median as(
    select  
        job_title_short,
        job_work_from_home,
        median(salary_year_avg) ::int as median_salary,
    from 
        job_postings_fact
    where   
        job_country = 'United States'
    group by 
        job_title_short,
        job_work_from_home
)

select 
    r.job_title_short,
    r.median_salary as remote_median_salary,
    o.median_salary as onsite_median_salary,
    (r.median_salary - o.median_salary) as remote_premium
from
    title_median as r
    inner join title_median as o
    on r.job_title_short = o.job_title_short
    where r.job_work_from_home = true and o.job_work_from_home = false
    order by remote_premium desc;





select
    *
from range(3) src(key);


select
    *
from range(2) tgt(key);

select
    *
from range(3) src(key)
where exists(
    select 1
    from range(2) tgt(key)
where src.key = tgt.key
);

select
    *
from range(3) src(key)
where not exists(
    select 1
    from range(2) tgt(key)
where src.key = tgt.key
);


-- Final Example
-- Identify job postings that have no associated skills before loading them into a data mart

select *
from
    job_postings_fact
order by job_id
limit 10;


select *
from
    skills_job_dim
order by job_id
limit 10;
