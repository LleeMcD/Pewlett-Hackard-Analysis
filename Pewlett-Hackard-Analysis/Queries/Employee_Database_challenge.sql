-- Deliverable 1 
-- 1. Create Retriement Titles table and export it to a csv file titled retirement_titles
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
     AND (de.to_date = '9999-01-01')
ORDER BY emp_no;