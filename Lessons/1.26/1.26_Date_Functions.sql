select
    job_posted_date,
    job_posted_date ::Date as date,
    job_posted_date ::time as time,
    job_posted_date ::timestamp as timestamp,
    job_posted_date ::timestamptz as timestampz
     
from 
    job_postings_fact
limit 10;

-- Extract
select 
    Extract(year from job_posted_date) job_posted_year,
    Extract(month from job_posted_date) job_posted_month,
    count(job_id)
from
    job_postings_fact
group by 1,2
order by 1,2;


-- Date_trunc
select  
    job_posted_date,
    Date_trunc('month',job_posted_date) as month
from
    job_postings_fact
    order by random()
limit 10;



-- At time zone
Select '2026-01-01 00:00:00+00'::timestamptz at time zone 'est';


--- Extract Date trunc

select 
    Date_trunc('month',job_posted_date)::date job_posted_month,
   count(job_id) job_count
from
    job_postings_fact
where job_title_short = 'Data Engineer' and 
      extract(year from job_posted_date) = 2024
group by 1
order by 1;


select 
    job_posted_date at time zone 'cst',
    job_posted_date 
from
    job_postings_fact
limit 10;

select Extract(hour from current_timestamp at time zone 'cst') as US,
extract(hour from current_timestamp )as Nigeria;


select 
    job_title_short,
    job_location,
    job_posted_date at time zone 'utc'
from 
    job_postings_fact
where
    job_location like 'Nigeria';



select 
    extract(hour from job_posted_date at time zone 'utc'),
    count(job_id) job_count
from 
    job_postings_fact
where
    job_location like 'Nigeria'
group by 1;