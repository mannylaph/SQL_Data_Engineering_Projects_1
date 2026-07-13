select  
    count(*)
from
    job_postings_fact;



select  
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    jpf.job_location
From 
    job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id
limit 30;


select  
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
From 
    job_postings_fact as jpf
inner join company_dim as cd
    on jpf.company_id = cd.company_id;


Select *
from skills_job_dim
limit 10;

select *
from skills_dim
limit 10;


Select
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
from
    job_postings_fact as jpf
inner join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
inner join skills_dim as sd 
    on sjd.skill_id = sd.skill_id;
limit 20;
