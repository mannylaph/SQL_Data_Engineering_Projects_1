select
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
from
    job_postings_fact
where salary_year_avg is not null
limit 40;


select
*
from
    company_dim
    order by name
    limit 10;

select
*
from
    company_dim
    where name in ('Facebook','Meta');



DESCRIBE job_postings_fact;
PRAGMA show_tables_expanded;
DESCRIBE company_dim;