-- USING WILDCARDS, UNIONS, JOINS, Nested Queries
use newtest;
-- Finding all employees
SELECT *
FROM employee;

-- Finding all clients
SELECT *
FROM client;

-- Finding all data in works_with table
SELECT *
FROM works_with;


-- Finding all clients 
SELECT *
FROM client;

-- finding all data in the BRANCH SUPPLIER table
SELECT *
FROM branch_supplier;

-- % = any # characters
-- _ = one character

-- Finding client's who are an LLC
SELECT *
FROM client
WHERE client_name LIKE '%LLC';

-- Finding branch suppliers who are in the label business
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '% Label%';

-- Finding employee born on the 10th day of the month
SELECT *
FROM employee
WHERE birth_day LIKE '_____10%';

-- Finding clients who are schools
SELECT *
FROM client
WHERE client_name LIKE '%school%';

-- USING UNION
-- The SELECT statements must have the same number of column
-- The SELECT staements must also be of the same data type

-- Finding a list of employee and branch names
SELECT e.first_name AS Employee_Branch_Names
FROM employee e
UNION
SELECT b.branch_name
FROM branch b;

-- Finding a list of all clients & branch suppliers' names
SELECT c.client_name AS NonEmployee_Entities, c.branch_id AS Branch_ID
FROM client c
UNION
SELECT b.supplier_name, b.branch_id
FROM branch_supplier b;

-- A list of all the money an employee earns or spends
SELECT e.salary
FROM employee e
UNION
SELECT w.total_sales
FROM works_with w;
-- USING JOINS

-- Add the extra branch
INSERT INTO branch VALUES(4, "Buffalo", NULL, NULL);

SELECT e.emp_id, e.first_name, b.branch_name
FROM employee e
JOIN branch b   -- LEFT JOIN, RIGHT JOIN
ON e.emp_id = b.mgr_id;
-- LEFT JOIN
SELECT e.emp_id, e.first_name, b.branch_name
FROM employee e
LEFT JOIN branch b  
ON e.emp_id = b.mgr_id;
-- RIGHT JOIN
SELECT e.emp_id, e.first_name, b.branch_name
FROM employee e
RIGHT JOIN branch b   
ON e.emp_id = b.mgr_id;

-- Nested Queries

-- Find names of all employees who have sold over 50,000
SELECT e.first_name, e.last_name
FROM employee e
WHERE e.emp_id IN (SELECT w.emp_id
                          FROM works_with w
                          WHERE w.total_sales > 50000);

-- Find all clients who are handled by the branch that Michael Scott manages
-- Assume you know Michael's ID
SELECT c.client_id, c.client_name
FROM client c
WHERE c.branch_id = (SELECT b.branch_id
                          FROM branch b
                          WHERE b.mgr_id = 102)
Limit 1;

 -- Find all clients who are handled by the branch that Michael Scott manages
 -- Assume you DONT'T know Michael's ID
 SELECT c.client_id, c.client_name
 FROM client c
 WHERE c.branch_id = (SELECT b.branch_id
                           FROM branch b
                           WHERE b.mgr_id = (SELECT e.emp_id
                                                  FROM employee e
                                                  WHERE e.first_name = 'Michael' AND e.last_name ='Scott'
                                                  LIMIT 1));


-- Find the names of employees who work with clients handled by the scranton branch
SELECT e.first_name, e.last_name
FROM employee e
WHERE e.emp_id IN (
                         SELECT w.emp_id
                         FROM works_with w
                         )
AND e.branch_id = 2;

-- Find the names of all clients who have spent more than 100,000 dollars
select c.client_name
from client c
where c.client_id in (select client_id
						from ( select sum(w.total_sales) totals, client_id
                        from works_with w
                        Group by 2) TCS
                        where totals > 100000
                        );
