select unnest([1,1,1,2])

union all

select unnest([1,3,1,2]);


create Temp table jobs_2023 as
--describe
select * exclude(job_id, job_posted_date)
from 
    job_postings_fact
where extract(year from job_posted_date) = 2023;


select 
    *
from jobs_2023;


create Temp table jobs_2024 as
--describe
select * exclude(job_id, job_posted_date)
from 
    job_postings_fact
where extract(year from job_posted_date) = 2024;


select * from jobs_2024;


--- Which unique job postings appeared in either 2023 or 2024?
select * from jobs_2023
union
select * from jobs_2024;

select 
'table_2023' as table_name,
count(*)  job_count from jobs_2023
union
select
'table_2024' as table_name,
count(*)  from jobs_2024;


-- Which job postings appeared in both tables counting the duplicates
select * from jobs_2023
union all
select * from jobs_2024;

select 
'table_2023' as table_name,
count(*)  job_count from jobs_2023
union
select
'table_2024' as table_name,
count(*)  from jobs_2024;


--- Which job postings appeared in 2023 and not in 2024?
select * from jobs_2023
except
select * from jobs_2024;


--- Which job postings from 2023 remain after subtracting mactching 2024 postings, one-for-one
select * from jobs_2023
except all
select * from jobs_2024;
 


-- Which job postings appeared in both 2023 and 2024?
select * from jobs_2023
intersect 
select * from jobs_2024;


select * from jobs_2023
intersect all
select * from jobs_2024;

