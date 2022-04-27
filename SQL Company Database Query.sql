use newtest;
drop table students;

-- Company Database Intro
-- Create employee table with 1 pri key and 2 foreign keys
CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);
-- Create branch table with 1 pri key and 1 foreign keys
CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);
-- Add the foreign keys to the employee tables
ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

-- Inserting values into the tables
-- branch_id and super_id are Null b'cos the branch table and the employee table have foreign keys that point to each other.
-- It's like a call and response thing. Like a circular relationship
-- Also b'cos the branch is yet to be created
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);
-- Adding the branch name
INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');
-- Modifying the employee table and setting the foreign key  (branch_id) 
UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;
-- Inserting another row in the employee table with the same branch_id or branch name
INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);
-- Introducing another branch and branch_id 
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);
--  Adding the branch name
INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');
-- Modifying the employee table and setting the foreign key  (branch_id) 
UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;
-- Inserting the rows in the employee table with the same branch_id or branch name
INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);
-- Introducing another branch and branch_id
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);
--  Adding the branch name
INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');
-- Modifying the employee table and setting the foreign key  (branch_id) 
UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;
-- Inserting the rows in the employee table with the same branch_id or branch name
INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- Inserting values into the BRANCH SUPPLIER table
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- Inserting values into the CLIENT table
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- Inserting values into the WORKS_WITH table
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

-- Finding all employees
SELECT *
FROM employee;

-- Finding all clients
SELECT *
FROM client;

-- Finding all employees salary from largest to smallest
SELECT *
from employee
ORDER BY salary DESC;

-- Finding all employees by their gender and name
SELECT *
from employee
ORDER BY sex, first_name;

-- Finding the first 5 employees in the table
SELECT *
from employee
LIMIT 5;

-- Finding the first and last names of all employees
SELECT first_name, last_name
FROM employee;

-- Finding the forename and surnames names of all employees
SELECT first_name forename, last_name surname
FROM employee;

-- Finding out all the different genders
SELECT DISTINCT sex
FROM employee;

-- Finding all male employees
SELECT *
FROM employee
WHERE sex = 'M';

-- Finding all female employees
SELECT *
FROM employee
WHERE sex = 'F';

-- Finding all employees at branch 2
SELECT *
FROM employee
WHERE branch_id = 2;

-- Finding all employee's id's and names who were born after 1969
SELECT emp_id, first_name, last_name
FROM employee
WHERE birth_day >= 1970-01-01;

-- Finding all female employees at branch 2
SELECT *
FROM employee
WHERE branch_id = 2 AND sex = 'F';

-- Finding all employees who are female & born after 1969 or who make over 80000
SELECT *
FROM employee
WHERE (birth_day >= '1970-01-01' AND sex = 'F') OR salary > 80000;

-- Finding all employees born between 1970 and 1975
SELECT *
FROM employee
WHERE birth_day BETWEEN '1970-01-01' AND '1975-01-01';

-- Finding all employees named Jim, Michael, Johnny or David
SELECT *
FROM employee
WHERE first_name IN ('Jim', 'Michael', 'Johnny', 'David');

-- SOME FUNCTIONS

-- Finding the number of employees
SELECT count(super_id)
FROM employee;

-- Finding the average of all employee's salaries
SELECT avg(salary)
FROM employee;

-- Finding the sum of all employee's salaries
SELECT SUM(salary)
FROM employee;

-- Finding out how many males and females there are
SELECT COUNT(sex), sex
FROM employee
Group by 2;

-- Finding the total sales of each salesman
SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY client_id;

-- Finding the total amount of money spent by each client
SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id;