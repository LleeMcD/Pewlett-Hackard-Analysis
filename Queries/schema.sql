
-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
dept_no VARCHAR (4) NOT NULL,
dept_name VARCHAR (40) NOT NULL,
PRIMARY KEY (dept_no),
UNIQUE (dept_name)
);

CREATE TABLE employees (
emp_no INT NOT NULL,
birth_date DATE NOT NULL,
first_name VARCHAR NOT NULL,
last_name VARCHAR NOT NULL,
gender VARCHAR NOT NULL,
hire_date DATE NOT NULL,
PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
emp_no INT NOT NULL,
salary INT NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY(emp_no) REFERENCES employees (emp_no),
PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp(
emp_no INT NOT NULL,
dept_no VARCHAR (4) NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
emp_no INT NOT NULL,
title VARCHAR (50) NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

Select * FROM departments;

SELECT first_name, last_name, 
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT COUNT (emp_no) AS "Retriree Count"
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-21'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create an output table named retirment_info
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

Select *
FROM retirement_info;


-- Drop retirment info table
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

--add aliases 
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date 
	FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- add aliases
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--Use Left Join for retirement_info and dept_emp tables then create new table current_emp

SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number with GROUP BY and ORDER BY 7.3.4

SELECT COUNT(ce.emp_no), de.dept_no
INTO employee_count_by_dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;


SELECT *
FROM salaries
ORDER BY to_date DESC;

--create temporary emp_info table
SELECT emp_no,
    first_name,
last_name,
    gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Drop the temporary table
DROP TABLE IF EXISTS emp_info;

-modify tenporary emp_info table
SELECT e.emp_no,
    e.first_name,
e.last_name,
    e.gender,
    s.salary,
de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	  AND (de.to_date = '9999-01-01');

-- List of managers per department 7.3.5
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

-- List 3 Dept Retirees 7.3.5
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--verify dept number and corresponding name
SELECT DISTINCT *
FROM departments;

--sales team retirement info 7.3.6
SELECT DISTINCT *
FROM dept_emp;
-- INTO sales_and_dev_teams_retirement_info
SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
de.dept_no
-- INTO sales_dev_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.dept_no IN ('d007');

--sales and development teams employee retirment info 7.3.6
SELECT DISTINCT *
FROM dept_emp;
-- INTO sales_and_dev_teams_retirement_info
SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
de.dept_no
-- INTO sales_dev_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.dept_no IN ('d005', 'd007');


----practice
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	t.title,
	t.from_date,
t.to_date 
-- INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;


----practice
----practice
DROP TABLE IF EXISTS titles;

CREATE TABLE titles (
emp_no INT NOT NULL,
title VARCHAR,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no))
;

SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	t.title,
	t.from_date,
t.to_date 
-- INTO retirement_titles
FROM employees as e
LEFT JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;


SELECT DISTINCT ON (e.emp_no) e.emp_no, 
	e.first_name, 
	e.last_name, 	
	e.birth_date,
	de.from_date,
	de.to_date,
t.title
INTO mentorship_eligibilty
FROM employees AS e
JOIN dept_emp AS de
ON e.emp_no = de.emp_no
JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
     AND (de.to_date = '9999-01-01');



ORDER BY emp_no;