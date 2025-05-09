if not exists(select*from sys.databases where name ='moze2')
    create database mose2
    GO
use moze2
GO
--down
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_jobs_job_contracted')
alter table jobs drop constraint fk_jobs_job_contracted
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_jobs_job_submitted_by')
alter table jobs drop constraint fk_jobs_job_submitted_by
drop table if exists jobs
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME= 'fk_contractors_contractor_state')
alter table contractors drop constraint fk_contractors_contractor_state 
drop table if exists contractors
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_customers_customer_state'
    )
alter table customers drop constraint fk_customers_customer_state
drop table if exists customers
drop table if exists state_lookup
GO
-- UP Metadata
create table state_lookup (
    state_code char(2) not NULL,
    constraint pk_state_lookup_state_code primary key (state_code)
)
CREATE TABLE customers ( 
    customer_id int identity NOT NULL, --surrogate key
    customer_email varchar(50) NOT NULL,
    customer_min_price money NOT NULL,
    customer_max_price money NOT NULL,
    customer_city varchar(50) NOT NULL,
    customer_state char(2) NOT NULL,
    constraint u_customers_customer_email UNIQUE(customer_email),
    constraint pk_customers_customer_id PRIMARY KEY (customer_id),
    constraint ck_customers_customer_valid_price check (customer_min_price<=customer_max_price)
)
alter table customers
    add constraint fk_customers_customer_state foreign key (customer_state)
    references state_lookup (state_code)
    GO
CREATE TABLE contractors (
     contractor_id int identity NOT NULL, --surrogate
    contractor_email varchar(50) NOT NULL,
    contractor_rate money NOT NULL,
    contractor_city varchar(50) NOT NULL,
    contractor_state char(2) NOT NULL,
    constraint pk_contractors_contractor_id PRIMARY KEY(contractor_id),
    constraint u_contractors_contractor_email UNIQUE (contractor_email)
)
GO
alter table contractors
    add constraint fk_contractors_contractor_state FOREIGN KEY (contractor_state)
    references state_lookup (state_code)
    GO
CREATE TABLE jobs(
    job_id int identity NOT NULL, --surrogate
    job_submitted_by int NOT NULL,
    job_requested_date date NOT NULL,
    job_contracted_by int NULL, 
    job_service_rate money NULL,
    job_estimated_date date NULL, 
    job_completed_date date NULL,
    job_customer_rating int NULL,
    constraint pk_jobs_job_id PRIMARY KEY (job_id),
    constraint ck_valid_job_dates check (job_estimated_date>=job_requested_date),
    constraint ck_valid_job_dates check (job_estimated_date<=job_completed_date)
)
alter table jobs ADD
    constraint fk_jobs_job_submitted_by FOREIGN KEY (job_submitted_by)
    references customers (customer_id)
    GO
alter table jobs ADD
    constraint fk_jobs_job_contracted_by FOREIGN KEY (job_contracted_by)
    references contractors (contractor_id)
    GO
--Up Data
insert into state_lookup (state_code)
values ('NY'),('NJ'),('CT')
insert into customers
(customer_email, customer_min_price, customer_max_price, customer_city, customer_state)
VALUES
('1karforless@superrito.com', 50, 100, 'Syracuse', 'NY'),
('bdehatchett@dayrep.com', 25, 50, 'Syracuse', 'NY'),
('pmeaup@dayrep.com', 100,150, 'Syracuse', 'NY'),
('tanott@gustr.com', 25,75,'Rochester', 'NY'),
('sboate@gustr.com', 50, 100, 'New Haven', 'CT')
GO
insert into contractors
(contractor_email, contractor_rate, contractor_city, contractor_state)
VALUES
('otme@dayrep.com', 50, 'Syracuse', 'NY'),
('meyezing@dayrep.com', 75, 'Syracuse', 'NY'),
('bitall@dayrep', 35, 'Rochester', 'NY'),
('sbeeches@dayrep.com', 85, 'Hartford', 'NY')
GO
insert into jobs
(job_submitted_by, job_requested_date, job_contracted_by, job_service_rate, job_estimated_date, job_completed_date)
VALUES
(1, 2020-05-01, NULL, NULL, NULL, NULL),
(2, 2020-05-01, 1, 50.0000, 2020-05-02, NULL),
(5, 2020-05-01, 4, 85.0000, 2020-05-03, 2020-05-03)
GO
--Verify
select * from state_lookup
select * from customers
select * from contractors
select * from jobs
GO