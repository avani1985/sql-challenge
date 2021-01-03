-----first, we need to create all the tables and import all data from csv files
--create first table
drop table departments;
CREATE TABLE departments(
	dept_no VARCHAR,
	dept_name VARCHAR
);
select * from departments;

--create 2nd table
drop table dept_emp;
create TABLE dept_emp(
	emp_no primary key,
	dept_no VARCHAR
);
select * from dept_emp;

--create 3rd table
drop table dept_manager;
create table dept_manager(
	dept_no VARCHAR,
	emp_no INT primary key
);
select * from dept_manager;

--create 4th table
drop table employees;
create table employees(
	emp_no INT primary key,
	emp_title_id VARCHAR,
	birth_date DATE,
	first_name VARCHAR,
	last_name VARCHAR,
	sex VARCHAR,
	hire_date Date
);
select * from employees;

--create 5th table
drop table salaries;
create table salaries(
	emp_no INT primary key,
	salary INT
);
select * from salaries;

--create 6th table
drop table titles;
create table titles(
	title_id VARCHAR,
	title VARCHAR
);
select * from titles;

-------data upload complete----------

---create the first table TABLE1 view---this can be done by LEFT JOIN on employees table and salaries table---
CREATE VIEW TABLE1 AS
select employees.emp_no,employees.first_name, employees.last_name, employees.sex, salaries.salary
from salaries
left JOIN employees ON
employees.emp_no = salaries.emp_no;

select * from TABLE1;

----create the second TABLE2 view-- add data filter in the employees table----
CREATE VIEW TABLE2 AS
Select *
from employees
where hire_date >='01-01-1986'
AND hire_date<'01-01-1987';	

SELECT * from TABLE2;

---create the third TABLE3 view--
---need to do two separate JOINS(departments with dept managers and then with employees)---

CREATE VIEW TABLE3 AS
select dept_manager.dept_no, dept_manager.emp_no,departments.dept_name
from departments
left JOIN dept_manager ON
dept_manager.dept_no = departments.dept_no;
SELECT * from TABLE3;

CREATE VIEW TABLE3new AS
select TABLE3.dept_no,TABLE3.emp_no,TABLE3.dept_name,employees.first_name,employees.last_name
from employees
INNER JOIN TABLE3 ON
TABLE3.emp_no= employees.emp_no;
select * from TABLE3new;

---create the fourth TABLE4 view---
---need to do two separate JOINS(employee ID with department names and then with employees)---
CREATE VIEW TABLE4 AS
select dept_emp.emp_no,dept_emp.dept_no, departments.dept_name
from departments
left join dept_emp ON
departments.dept_no = dept_emp.dept_no;
select* from TABLE4;

CREATE VIEW TABLE4new AS
select TABLE4.emp_no, TABLE4.dept_name, employees.first_name, employees.last_name
from employees
left join TABLE4 ON
TABLE4.emp_no = employees.emp_no;
select * from TABLE4new;

---create the fifth TABLE5 view---
---this is done by adding filters to the employees table---
CREATE VIEW TABLE5 AS
Select *
from employees
where first_name= 'Hercules'
AND last_name like 'B%';
select* from TABLE5;

---create the sixth TABLE6 view---
-- the Table4new created above has all the components; need to ONLY add a 'SALES' filter---
CREATE VIEW TABLE6 AS
SELEct * 
from TABLE4new
where dept_name='Sales';
select * from TABLE6;

---CReate the seventh TABLE7 view---
---use table4new and filter by sales OR development---
CREATE VIEW TABLE7 AS
SELEct * 
from TABLE4new
where dept_name='Sales'
OR dept_name='Development';
select * from TABLE7;

----CREATE the eight TABLE8 view---
---use a groupby on the last_name in the employees table----
CREATE table TABLE8 AS
SELECT last_name, COUNT(emp_no) as "CommonLastName"
from employees
Group by last_name;
select* from TABLE8;
---sort the table
SELECT * from TABLE8
ORDER by "CommonLastName";

---BONUS challenge--- do JOINS for TABLE1,employees, and titles---
CREATE VIEW BONUS1 AS
select TABLE1.emp_no,TABLE1.salary, employees.emp_title_id
from employees
left JOIN TABLE1 ON
employees.emp_no = TABLE1.emp_no;
select * from BONUS1;

CREATE VIEW BONUS2 AS
select BONUS1.emp_no, BONUS1.salary, BONUS1.emp_title_id, titles.title
from titles
left join BONUS1 ON
BONUS1.emp_title_id=titles.title_id;
select * from BONUS2;
