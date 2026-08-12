-- Step 1: DW - Create star schema tables
drop table if exists skills_job_dim;
drop table if exists job_postings_fact;
drop table if exists company_dim;
drop table if exists skills_dim;




CREATE TABLE company_dim(
    company_id      integer    primary key,
    name            varchar

);



CREATE TABLE skills_dim(
    skill_id        integer    primary key,
    skill           varchar,
    type            varchar

);


CREATE TABLE job_postings_fact(
    job_id                  integer     primary key,
    company_id              integer,
    job_title_short         varchar,
    job_title               varchar,
    job_location            varchar,
    job_via                 varchar,
    job_schedule            varchar,
    job_work_from_home      varchar,
    search_location         varchar,
    job_poste_date          varchar,
    job_no_degree_mention   varchar,
    job_health_insurance    varchar,
    job_country             varchar,
    salary_rate             varchar,
    salary_year_avg         double,
    salary_hour_avg         double,
    FOREIGN KEY(company_id) REFERENCES company_dim(company_id)
);



CREATE TABLE skills_job_dim(
    skill_id        integer,
    job_id          integer,
    PRIMARY KEY(skill_id, job_id),
    FOREIGN KEY(skill_id) REFERENCES skills_dim(skill_id),
    FOREIGN KEY(job_id) REFERENCES job_postings_fact(job_id)

);

select table_name
from information_schema.tables
where table_schema ='main';