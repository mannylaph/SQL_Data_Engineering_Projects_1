
drop database if exists jobs_mart;

create database if not exists jobs_mart;

show databases;



Select *
from information_schema.schemata;

use jobs_mart;

create schema if not exists staging;

-- drop schema staging;

create table if not exists staging.preferred_roles(
    role_id integer primary key,
    role_name varchar
);

select *
from information_schema.tables
where table_catalog = 'jobs_mart';

-- drop table if exists main.preferred_roles;

select * from staging.preferred_roles;

insert into staging.preferred_roles(role_id,role_name)
values(1, 'Data Engineer'),
        (2,'Senior Data Engineer'),
        (3, 'Software Engineer'),
        (4,'Senior Senior Software Engineer'); ; 

select * from staging.preferred_roles;

alter table staging.preferred_roles
add column preferred_role Boolean

update staging.preferred_roles
set preferred_role = true
where role_id = 1 or role_id =2;

select * from staging.preferred_roles;

update staging.preferred_roles
set preferred_role = true
where role_id = 4;


alter table staging.preferred_roles
rename to priority_roles;

alter table staging.priority_roles
rename column preferred_role to priority_lvl;

alter table staging.priority_roles
alter column priority_lvl type integer;

update staging.priority_roles
set priority_lvl = 1
where priority_lvl is null;

update staging.priority_roles
set priority_lvl = 3
where role_id = 3 or role_id = 4;

select * from staging.priority_roles;