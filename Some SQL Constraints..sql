show databases;
use newtest;
-- Inserting data into a database table

Create table students (student_id int primary key, name varchar(15), major varchar (30));
describe students;

-- To insert information into the students table using the 'inser into' function

Insert Into students 
values (2, 'Kate', 'Sociology'); 

-- Insert without including a 'Major'

Insert Into students (student_id, name)
values (3, 'Femi'); 

-- Making it easier to insert data into the table

Drop Table students;

-- Setting a NOT Null and Unique rule into a row 
Create table students (student_id int primary key, name varchar(20) Not Null, major varchar (30) unique);
describe students;

Insert Into students 
values (1, 'Kate', 'Sociology'),
		(2, 'Jack', 'biology'),
        (3, 'null', 'chemistry'),
        (4, 'mike', 'Sociology'),
        (5, 'femi', 'computer'); 
-- The above name and major field did not allow the insert function to run b'cos of the added constraints
Select * From students;
Drop Table students;
-- Setting a 'Default' constraint in the row
Create table students (student_id int primary key, name varchar(20) , major varchar (30) default 'undecided');
describe students;

Insert Into students values (1, 'Kate', 'Sociology');
Insert Into students values (2, 'Jack', 'biology');
Insert Into students values  (3, 'null', 'chemistry');
       Insert Into students (student_id, name) values (4, 'mike');
Insert Into students values (5, 'femi', 'computer'); 
-- The above insert value function will show 'undecided' under the major column of row 4
Select * From students;

Drop Table students;
-- Have the database increase the primary keys for you by using the 'auto increment' function 
Create table students (student_id int primary key auto_increment, name varchar(20) , major varchar (30) default 'undecided');
describe students;

Insert Into students (name, major) values ('Kate', 'Sociology');
Insert Into students (name, major) values ('Jack', 'biology');
Insert Into students (name, major) values ('mike', 'chemistry');
Insert Into students (name, major) values ('paul', 'physics');
Insert Into students (name, major) values ('femi', 'computer'); 
-- The above assigns and increase the student_id value automatically for the database
Select * From students;

-- Update the database using the where statement
update students 
SET major = 'bio'
Where major = 'biology';

Select * From students;

-- delete rows from the database using the 'delete from' statement

delete from students
where name = 'femi';

Select * From students;