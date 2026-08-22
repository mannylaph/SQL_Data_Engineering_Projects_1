-- Step 6: Mart - Update priority roles mart

-- Update Data Engineer to Priority 1 
Update priority_mart.priority_roles
set priority_lvl = 1
where role_name = 'Data Engineer';


-- Add Data Scientis as Level 3
insert into priority_mart.priority_roles(role_id, role_name, priority_lvl)
values(4,'Data Scientist',2);

-- Validate priority_roles
select * from priority_mart.priority_roles;


select '=== Creating Temp Source Table for Priority Mart ===' as info;
--- Create a TEMP table
create or replace temp table src_priority_jobs as(
  
select  
    jpf.job_id,
    jpf.job_title_short,
   cd.name as company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    current_timestamp as updated_at 
    from job_postings_fact jpf
    left join 
    company_dim as cd
    on jpf.company_id = cd.company_id
    inner join priority_mart.priority_roles r
    on jpf.job_title_short = r.role_name 
);
 


select '== Batch updating priority_jobs_snapshot for Priority Mart ==' as info;
-- Merge into
Merge into priority_mart.priority_jobs_snapshot as tgt
    using src_priority_jobs as src
        on tgt.job_id = src.job_id

when matched  and tgt.priority_lvl is distinct from src.priority_lvl then
    update set
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at

when not matched then
        insert  (
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    )
    values(  
        src.job_id,
        src.job_title_short, 
        src.company_name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        src.updated_at
    )

when not matched by source then delete;
     



-- Run a check
  Select 
        job_title_short,
        count(*) as job_count,
        min(priority_lvl) as priority_lvl,
        min(updated_at) as updated_at
    from
        priority_mart.priority_jobs_snapshot
        group by 1
        order by job_count desc;