# Exploratory Data Analysis with SQL: Job Market Analysis

![Project 1 Overview](../images\1_1_Project1_EDA.png)

## 🧾 Executive Summary (For Hiring Managers)

* ✅ **Project scope:** Three analytical SQL queries answering the questions any data engineer job-seeker actually cares about
* ✅ **Data modeling:** Multi-table joins across fact and dimension tables to connect postings, skills, and salaries
* ✅ **Analytics:** Aggregations, filtering, and ranking to surface top skills by demand, salary, and overall value
* ✅ **Outcomes:** Clear evidence that SQL/Python are non-negotiable, cloud demand is split across three platforms, and a custom scoring model to separate hype from actual value

If you only have a minute, these three files tell the whole story:

1. `1_top_on_demand_skills.sql` – which skills show up most in remote postings
2. `2_top_paying_skills.sql` – which skills pay the most
3. `3_optimal_skills.sql` – a weighted score that balances both, so demand doesn't drown out pay

## 🧩 Problem & Context

Most "top skills" lists just count mentions — which means the loudest skill wins, not the most valuable one. This project was built to answer three questions properly:

* 🎯 **Most in-demand:** Which skills actually show up most in remote data engineer postings?
* 💰 **Highest paid:** Which skills command the biggest salaries, even if they're rare?
* ⚖️ **Best trade-off:** If you could only learn a handful of skills, which ones give you the best combination of pay and job availability?

To answer these, I built the analysis on top of a data warehouse using a star schema design. The warehouse is structured as:

![Data Warehouse](../images/1_2_Data_Warehouse.png)

* **Fact table:** `job_postings_fact` — the core table holding job posting details (titles, locations, salaries, post dates, remote status)
* **Dimension tables:**
   * `company_dim` — company details tied to each posting
   * `skills_dim` — the catalog of skills, with names and types
* **Bridge table:** `skills_job_dim` — handles the many-to-many relationship between postings and skills (since one job can require many skills, and one skill spans many jobs)

By joining across these tables, I was able to go beyond simple counts and actually connect skill demand to salary data — surfacing which skills are worth learning, not just which ones show up the most.

## 🛠️ Tech Stack

* 🦆 **Query engine:** DuckDB, chosen for fast, OLAP-style analytical queries without the overhead of a full database server
* 🧮 **Language:** SQL (ANSI-style, leaning on window and aggregate functions for the heavier analysis)
* 📊 **Data model:** Star schema — fact table + dimension tables + a bridge table to handle the many-to-many skill relationship
* 🛠️ **Development:** VS Code for writing and organizing SQL, Terminal for running the DuckDB CLI
* 📦 **Version control:** Git/GitHub, so every query is tracked and the analysis is reproducible

Nothing exotic — a lean stack picked for speed and clarity, and one that mirrors how a lot of real-world analytics teams actually work.

## 📁 Repository Structure

1_EDA/
├── 01_top_demanded_skills.sql    # Demand analysis query
├── 02_top_paying_skills.sql      # Salary analysis query
├── 03_optimal_skills.sql         # Combined demand/salary optimization
└── README.md                     # You are here

Three queries, each building on the last — starting with raw demand, layering in salary, then combining both into a single optimal score.


## 🏗️ Analysis Overview

### Query Structure

1. [Top Demanded Skills](../1_EDA/1_top_on_demand_skills.sql) – Identifies the top 10 most in-demand skills for remote data engineer positions
2. [Top Paying Skills](../1_EDA/2_top_paying_skills.sql) – Analyzes the 25 highest-paying skills alongside their demand metrics
3. [Optimal Skills](../1_EDA/3_optimal_skills.sql) – Combines log-scaled demand with median salary into a single score to surface the most valuable skills to learn

### Key Insights

* 🧠 **Core languages:** SQL and Python each appear in ~29,000 postings — the clear baseline for any remote data engineer role
* ☁️ **Cloud platforms:** AWS leads, but Azure and GCP both show real demand — no single cloud dominates
* 🧱 **Infra & tooling:** Terraform, Kubernetes, and Airflow are tied to premium salaries, even where raw demand is lower
* 🔥 **Big data tools:** Spark and Snowflake show strong demand *and* competitive pay, making them a safe next-tier bet
* 🏆 **Best overall value:** Terraform ranks highest once demand is normalized — proof that the highest-paying skill isn't always the rarest one


## 💻 SQL Skills Demonstrated

### Query Design & Optimization

* **Complex joins:** Multi-table `INNER JOIN` operations across `job_postings_fact`, `skills_job_dim`, and `skills_dim`
* **Aggregations:** `COUNT()`, `MEDIAN()`, `ROUND()` for statistical analysis
* **Filtering:** Boolean logic with `WHERE` clauses and multiple conditions (`job_title_short`, `job_work_from_home`, `salary_year_avg IS NOT NULL`)
* **Sorting & limiting:** `ORDER BY` with `DESC` and `LIMIT` for top-N analysis

### Data Analysis Techniques

* **Grouping:** `GROUP BY` for categorical analysis by skill
* **Mathematical functions:** `LN()` for natural logarithm transformation to normalize demand metrics
* **Calculated metrics:** A derived optimal score combining log-transformed demand with median salary
* **HAVING clause:** Filtering aggregated results down to skills with meaningful sample size (100+ postings)
* **NULL handling:** Proper filtering of incomplete records (`salary_year_avg IS NOT NULL`) to avoid skewed averages