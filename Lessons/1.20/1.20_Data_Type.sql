Select 
    table_name,
    column_name,
    data_type
from information_schema.columns
where table_name = 'job_postings_fact';

describe 
Select
job_title_short,
salary_year_avg
from
job_postings_fact;

Select
    cast('123' as int);





Select  
    job_id::varchar || '-'||company_id::varchar unique_id,
    job_work_from_home::int work_from_home,
    job_posted_date::date,
    salary_year_avg::decimal(10,2)annual_salary
from  
    job_postings_fact
where 
    salary_year_avg is not null
limit 10;    


