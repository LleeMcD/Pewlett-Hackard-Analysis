-- Deliverable 1 
-- 1. Create Retriement Titles table and export it to a csv file titled retirement_titles.
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	t.title,
	t.from_date,
t.to_date 
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

--2. -- Use Dictinct on with Orderby to remove duplicate rows. Export the table into a csv file labeled unique_titles

SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC, to_date DESC;

--3. Create a query to retrieve the number retirees by title. Export the table into a csv file titled retiring_titles

SELECT COUNT(title) as "count",
title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

--Deliverable 2. 
--Create a query of employees eligible for mentorship. Export the table into a csv file titled mentorship_eligibility.

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

-- Additional queries for challenge
-- Create table query to retrieve all current employees who were born in 1961 or after. Supports information in the Pewlett-Hackard Analysis Summary.

SELECT DISTINCT ON (e.emp_no) e.emp_no, 
	e.first_name, 
	e.last_name, 	
	e.birth_date,
	de.from_date,
	de.to_date,
t.title
INTO current_emp_bd_1961_or_aft
FROM employees AS e
JOIN dept_emp AS de
ON e.emp_no = de.emp_no
JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE (e.birth_date >'1960-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY emp_no;

-- Create table query to return the number of current employees who were born in 1961 of after by title. Supports information in the Pewlett-Hackard Analysis Summary. 

SELECT COUNT(title) as "count",
title
INTO current_emp_not_retiring
FROM current_emp_bd_1961_or_aft
GROUP BY title
ORDER BY count DESC;

--Create table query to retrieve retiring employees specific to the sales and development areas of Pewlett-Hackard.

SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
		de.dept_no,
d.dept_name
INTO sales_dev_retiring
FROM retirement_info as ri
JOIN dept_emp as de
ON ri.emp_no = de.emp_no
JOIN departments as d
ON d.dept_no = de.dept_no
WHERE de.dept_no IN ('d005', 'd007');

--Create table query to retrieve retiring employees specific to the sales and development areas of Pewlett-Hackard by department employee count.

SELECT COUNT(dept_no) as "Count",
dept_name AS "Department"
INTO retiring_salesdev_count
FROM sales_dev_retiring
GROUP BY dept_name
ORDER BY "Count" DESC;

--Create table query to retrieve employees from the sales and development areas of Pewlett-Hackard who are not retiring.

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.dept_no,
de.to_date
INTO sales_dev_not_retiring
FROM employees as e
JOIN dept_emp as de
ON e.emp_no = de.emp_no
JOIN departments as d
ON d.dept_no = de.dept_no
WHERE (e.birth_date >'1960-12-31')
	AND (de.to_date = '9999-01-01')
		AND de.dept_no IN ('d005', 'd007');
	
--Create query to retrive the count of Pewlett-Hackard sales and develpment employees who are not retiring.

SELECT COUNT(dept_no) as "Count S/D Not Retiring"
FROM sales_dev_not_retiring
ORDER BY "Count S/D Not Retiring" DESC;	


