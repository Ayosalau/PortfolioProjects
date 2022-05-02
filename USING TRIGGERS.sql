-- Deleting entries in the DB when they have Foreign Keys linked to them
-- Testing the 'On Delete Set Null' and 'On Delete Cascade' funtion
-- For the 'On Delete Set Null', if an entry is deleted, the row will return 'null'
--  For the 'On Delete Cascade', if an entry is deleted, the entire row will be deleted

use newtest;
-- testing from employee and branch tables
DELETE FROM employee
WHERE emp_id = 102;

SELECT *
FROM branch;

-- testing from branch and branch_suppler
DELETE FROM branch
WHERE branch_id = 2;

SELECT *
FROM branch_supplier;

-- TRIGGERS
-- Triggers are used to define a certain action if any activity happens on a database

-- CREATE
--     TRIGGER `event_name` BEFORE/AFTER INSERT/UPDATE/DELETE
--     ON `database`.`table`
--     FOR EACH ROW BEGIN
-- 		-- trigger body
-- 		-- this code is applied to every
-- 		-- inserted/updated/deleted row
--     END;

CREATE TABLE trigger_test (
     message VARCHAR(100)
);
-- Defining a trigger to insert a value into the trigger_test table before a value gets to be inserted in the employee table.
DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES('added new employee');
    END$$
DELIMITER ;
INSERT INTO employee
VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

SELECT * FROM trigger_test;

-- Trigger to show if a new firstname
DELIMITER $$
CREATE
    TRIGGER my_trigger1 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES(NEW.first_name);
    END$$
DELIMITER ;
INSERT INTO employee
VALUES(110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);

SELECT * FROM trigger_test;

-- Trigger to show if a new gender was added to the table
DELIMITER $$
CREATE
    TRIGGER my_trigger2 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
         IF NEW.sex = 'M' THEN
               INSERT INTO trigger_test VALUES('added male employee');
         ELSEIF NEW.sex = 'F' THEN
               INSERT INTO trigger_test VALUES('added female');
         ELSE
               INSERT INTO trigger_test VALUES('added other employee');
         END IF;
    END$$
DELIMITER ;
INSERT INTO employee
VALUES(111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);

SELECT * FROM trigger_test;

DROP TRIGGER my_trigger;
