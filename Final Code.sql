
-- Create Table named titles
----------------------------

CREATE TABLE "titles" (
    "title_id" varchar(10)   NOT NULL,
    "title" varchar(30)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);


-- Create Table named departments
---------------------------------

CREATE TABLE "departments" (
    "dept_no" varchar(10)   NOT NULL,
    "dept_name" varchar(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);


-- Create Table named dept_manager
---------------------------------

CREATE TABLE "dept_manager" (
    "dept_no" varchar(10)   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "emp_no"
     )
);


-- Create Table named dept_emp
---------------------------------

CREATE TABLE "dept_emp" (
    "emp_no_dept" int   NOT NULL,
    "dept_no" varchar(10)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no_dept","dept_no"
     )
);


-- Create Table named employees
---------------------------------

CREATE TABLE "employees" (
    "id" serial   NOT NULL,
    "emp_no" int   NOT NULL,
    "emp_title_id" varchar(10)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(30)   NOT NULL,
    "last_name" varchar(30)   NOT NULL,
    "sex" varchar(30)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);


-- Create Table named salaries
---------------------------------

CREATE TABLE "salaries" (
    "emp_no_salary" int   NOT NULL,
    "salary" int   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no_salary"
     )
);


-- Referencing related tables i.e. Adding Foreign keys
----------------------------------------------------


ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no_dept" FOREIGN KEY("emp_no_dept")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no_salary" FOREIGN KEY("emp_no_salary")
REFERENCES "employees" ("emp_no");



-- 1. List the employee number, last name, first name, sex, and salary of each employee.
-- ------------------------------------------------------------------------------------

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries
ON employees.emp_no = salaries.emp_no_salary;



-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
-- -----------------------------------------------------------------------------------------

SELECT employees.first_name, employees.last_name,  employees.hire_date
FROM employees
where extract (year FROM hire_date) = 1986



-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
-- --------------------------------------------------------------------------------------------------------------------------------------

SELECT employees.first_name, employees.last_name, dept_manager.emp_no, dept_manager.dept_no, departments.dept_name
FROM 
dept_manager 
INNER JOIN employees ON dept_manager.emp_no = employees.emp_no
INNER JOIN departments ON dept_manager.dept_no = departments.dept_no;



-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
-- --------------------------------------------------------------------------------------------------------------------------------------
SELECT dept_emp.dept_no, dept_emp.emp_no_dept, employees.first_name, employees.last_name,  departments.dept_name
FROM 
dept_emp 
INNER JOIN employees ON dept_emp.emp_no_dept = employees.emp_no
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no;


-- 5. List the first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
--  ------------------------------------------------------------------------------------------------------------------------------------

SELECT employees.first_name, employees.last_name, employees.sex
FROM employees
WHERE employees.first_name = 'Hercules' AND LEFT(employees.last_name, 1) = 'B'


-- 6. List each employee in the Sales department, including their employee number, last name, and first name.

SELECT employees.emp_no, employees.last_name, employees.first_name
FROM employees
INNER JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no_dept AND dept_emp.dept_no = 'd007'



-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
-- -------------------------------------------------------------------------------------------------------------------------------------------

SELECT employees.emp_no, employees.last_name, employees.first_name, dept_emp.dept_no, departments.dept_name
FROM employees
INNER JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no_dept AND (dept_emp.dept_no = 'd005' OR dept_emp.dept_no = 'd007')
INNER JOIN departments
ON departments.dept_no = dept_emp.dept_no


-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT employees.last_name, COUNT(*) AS "Frequency count of Last Names"
FROM employees
GROUP BY last_name;

