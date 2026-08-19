

Drop schema if exists skills_mart cascade;

Create schema skills_mart;

create or replace table skills_mart.dim_skills(
    skill_id       integer primary key,
    skills          varchar,
    type            varchar
);

select '====== Loading Skills Dimension Table ====' as info;
insert into skills_mart.dim_skills(
    skill_id,
    skills,
    type
)

Select
    skill_id,
    skills,
    type
from 
    skills_dim;




Create or replace table skills_mart.dim_date_month(
    month_start_date            date PRIMARY KEY,
    year                        integer,
    month                       integer,
    quarter                     integer,
    quarter_name                varchar,
    year_quarter                varchar                

);


select '====== Loading Monthly Dimension Table ====' as info;
insert into skills_mart.dim_date_month(
    month_start_date ,
    year,
    month,
    quarter,
    quarter_name,
    year_quarter
)
select DISTINCT
    date_trunc('month',job_posted_date ) as month_start_date,
    extract(year from  job_posted_date  ) as year,
    extract(month from job_posted_date ) as month,
    extract(quarter from job_posted_date  )as quarter,
    'Q-' || extract(quarter from job_posted_date  ):: varchar as quarter_name,
    extract(year from  job_posted_date  ) :: varchar || '-Q' || extract(quarter from job_posted_date  ):: varchar as year_quarter
from job_postings_fact
order by month_start_date;


select * from skills_mart.dim_date_month;


create or replace table skills_mart.fact_skill_demand_monthly(
    skill_id                            integer,
    month_start_date                    date,
    job_title                           varchar,
    postings_count                      integer,
    remote_postings                     integer,
    health_insurance_postings           integer,
    no_degree_mention_postings_count    integer,
    PRIMARY KEY(skill_id, month_start_date, job_title),
    FOREIGN KEY(skill_id) REFERENCES skills_mart.dim_skills(skill_id),
    FOREIGN KEY (month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date)
);



select '====== Loading Fact Monthly Demand Table ====' as info;
insert into skills_mart.fact_skill_demand_monthly(
    skill_id,
    month_start_date,
    job_title,
    postings_count,
    remote_postings,
    health_insurance_postings,
    no_degree_mention_postings_count
)



with job_postings_prep as (
select
    sjd.skill_id as skill_id,
    date_trunc('month', jpf.job_posted_date):: date month_start_date,
    jpf.job_title_short as job_title,
    --Convert boolean flags
    CASE WHEN jpf.job_work_from_home = True then 1 else 0 end as is_remote,
    CASE WHEN jpf.job_health_insurance = True then 1 else 0 end as has_health_insurance,
    CASE WHEN jpf.job_no_degree_mention = True then 1 else 0 end as no_degree_mentioned
from job_postings_fact as jpf
    inner join skills_job_dim sjd
    on sjd.job_id = jpf.job_id
)

select
    skill_id,
    month_start_date,
    job_title,
    count(*) Total_jobs,
    sum(is_remote) is_remote,
    sum(has_health_insurance) has_health_insurance,
    sum(no_degree_mentioned) no_degree_mentioned
from
    job_postings_prep
group by all
order by skill_id,month_start_date,job_title;



-- Validation
select 'Validating tables' as info;

Select 'Skills Dimension',count(*) as record_count from skills_mart.dim_skills
union all
select 'Date month Dimension', count(*) from skills_mart.dim_date_month
union all
select 'Skill Demand fact', count(*) from skills_mart.fact_skill_demand_monthly;


select '====== Skills Dimension Sample ====' as info;
select * from skills_mart.dim_skills limit 5;

select '====== Date Month Dimension Sample ====' as info;
select * from skills_mart.dim_date_month limit 5;

select '====== Skill Demand Fact Sample ====' as info;
select * from skills_mart.fact_skill_demand_monthly limit 5;