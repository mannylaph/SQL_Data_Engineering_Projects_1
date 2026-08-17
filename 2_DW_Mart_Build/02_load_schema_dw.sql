-- Step 2: Load data from CSV files into tables

select '=== Loading company_dim Table ===' as info;
insert into company_dim(company_id,name)
Select company_id,name
from read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
Auto_detect=true,parallel=false);
 

select '=== Loading skills_dim Table ===' as info;

insert into skills_dim(skill_id, skills, type)
Select skill_id, skills, type
from read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv',
Auto_detect=true, parallel=false,  ignore_errors = true,
    store_rejects = true);




select '=== Loading job_postings_fact Table ===' as info;

insert into job_postings_fact(
      job_id, company_id,job_title_short,job_title,job_location,
      job_via,  job_work_from_home, search_location,
      job_posted_date, job_no_degree_mention, job_health_insurance,
      job_country, salary_rate, salary_year_avg,salary_hour_avg
)

Select 
      job_id, company_id,job_title_short,job_title,job_location,
      job_via,  job_work_from_home, search_location,
      job_posted_date, job_no_degree_mention, job_health_insurance,
      job_country, salary_rate, salary_year_avg,salary_hour_avg

from read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv',
Auto_detect=true, parallel=false);



select '=== Loading skills_job Table ===' as info;
insert into skills_job_dim(skill_id, job_id)
Select skill_id, job_id
from read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv',
Auto_detect=true, parallel=false,  ignore_errors = true,
    store_rejects = true);

-- Validate data
Select 'company dim' as table_name, count(*) as entry_rows from company_dim
union all
select 'skills dim', count(*) from skills_dim
union all
select 'Jobs Dim', count(*) from job_postings_fact
union all
select 'skills job dim', count(*) from skills_job_dim;


select '=== Company Dimensions Sample ==' as info;
select * from company_dim limit 5;

select '=== Skills Dimension Sample ==' as info;
select * from skills_dim limit 5;

select '=== Job Postings Facat Sample ==' as info;
select * from job_postings_fact limit 5;

select '=== Skills job Dimension Sample ==' as info;
select * from skills_job_dim limit 5;