-- Array Intro

select  ['sql','python','r'] skills_array;

with skills as(
    select 'python' as skill
    union all
    select 'sql' as skill
    union all
    select 'r' as skill
),skills_array
as(
    select array_agg(skill order by skill) as skills from skills
)


select  
    skills[1] as first_skill,
    skills[2] as second_skill,
    skills[3] as third_skill
 from skills_array;


-- STRUCT
Select {skill:'C#', type:'programming'} as skill_struct;


with skill_struct as(
select struct_pack(
    skill :='Python',
    type :='Programming'
)s
)

select
    s.skill,
    s.type
from skill_struct;


with skill_table as(
    select 'python' as skills, 'programming' as types
    union all
    select 'sql' as skills, 'query language'
    union all
    select 'r' as skills, 'programming'
)

select  
    struct_pack(
        skill := skills,
        type:= types
    )
from skill_table;



--- Array of structs
select
    [
        {skill:'python', type:'programming'},
    {skill:'sql',type:'query_languate'},
    {skill:'C#', type:'programming'}
    ];



with skill_table as(
    select 'python' as skills, 'programming' as types
    union all
    select 'sql' as skills, 'query language'
    union all
    select 'r' as skills, 'programming'
), 
skills_array_of_struct as(

    select  
        array_agg(
            struct_pack(
                skill := skills,
                type:= types
            )
        ) array_of_struct
from skill_table
)

select 
    array_of_struct[1].skill,
    array_of_struct[2].type,
    array_of_struct[3]


from skills_array_of_struct;


-- Map/Object/Dictionary

-- Select {'skill':'python'};

with skill_map as(
Select Map{'skill':'python','type':'programming'} skill_type
)

select 
    skill_type['skill'],
    skill_type['type']
from skill_map;



-- JSON
with raw_skill_json as (
    select
        '{"skill":"python", "type":"Programming"}'::JSON as skill_json
        )
select 
    struct_pack(
        skill := json_extract_string(skill_json,'$.skill'),
        type := json_extract_string(skill_json,'$.type')
    )
from
    raw_skill_json;



--- JSON to array of structs
with raw_skill_json as(
    select  
        '[ {"skills":"Python","type":"Programming"},{"skills":"C#","type":"Programming"},{"skills":"SQL","type":"Query Language"}]':: JSON as skills_json
)
select 
ARRAY_AGG(
    struct_pack(
        skill := json_extract_string(e.value,'$.skills'),
        type := json_extract_string(e.value,'$.type')
    ))
from
    raw_skill_json,json_each(skills_json) as e;

--- Final Example
-- Arrays : Build a flat skill table for co-workers to access job titles, salary info, and skills in one table


create or replace temp table job_skills_array as
select
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) skill

from 
    job_postings_fact as jpf
left join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
left join skills_dim sd
    on sjd.skill_id = sd.skill_id
group by all;


-- From the perspective of a Data Analyst, analyze the median salary per skill

with flat_skills as(
select
    job_id,
    job_title_short,
    salary_year_avg,
    unnest(skill) skill
from job_skills_array

)

select
    job_title_short,
    skill,
    median(salary_year_avg)
from flat_skills
group by all
having job_title_short = 'Data Engineer'
order by median(salary_year_avg) desc
limit 50;



--- Aray of structs : Final Example
 -- Build a flat skill & table for co-workers to access job titles, salary info, skills, and type in one table
create or replace temp table  job_skills_array_struct as
select
    jpf.job_id job_id,
    jpf.job_title_short job_title_short,
    jpf.salary_year_avg salary_year_avg,
    ARRAY_AGG(
        struct_pack(
            skills := sd.skills,
            skill_type:= sd.type
        )
    ) skill

from 
    job_postings_fact as jpf
left join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
left join skills_dim sd
    on sjd.skill_id = sd.skill_id
group by all;

-- From the perspective of a Data Analyst, analyze the median salary per type of skill

select
    job_id,
    job_title_short,
    salary_year_avg,
    unnest(skill).skills skill_name,
    unnest(skill).skill_type skill_type
from    
    job_skills_array_struct;

--  analyze the median salary per type of skill

with flat_skills2 as(
select
    job_id,
    job_title_short,
    salary_year_avg,
    unnest(skill).skills skill_name,
    unnest(skill).skill_type skill_type
from    
    job_skills_array_struct
)

select
    skill_type,
    median(salary_year_avg)
from flat_skills2
group by skill_type
order by median(salary_year_avg) desc;