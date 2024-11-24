-- practical 7

CREATE TABLE IF NOT EXISTS Stud_Marks ( 
name VARCHAR(50), 
total_marks INT 
); 
INSERT INTO Stud_Marks (name, total_marks) VALUES 
('John', 1000), 
('Alice', 950), 
('Bob', 870), 
('Carol', 820), 
('David', 1500); 
CREATE TABLE IF NOT EXISTS Result ( 
Roll INT AUTO_INCREMENT PRIMARY KEY, 
Name VARCHAR(50), 
Class VARCHAR(50) 
); 

Delimiter $$ 
CREATE PROCEDURE  proc_Grade ( 
IN student_name VARCHAR(50),  
IN total_marks INT 
) 
BEGIN 
DECLARE grade VARCHAR(50); -- Categorize students based on their total marks 
IF total_marks >= 990 AND total_marks <= 1500 THEN 
SET grade = 'Distinction'; 
ELSEIF total_marks >= 900 AND total_marks <= 989 THEN 
SET grade = 'First Class'; 
ELSEIF total_marks >= 825 AND total_marks <= 899 THEN 
SET grade = 'Higher Second Class'; 
ELSE 
SET grade = 'Other'; 
END IF;
INSERT INTO Result (Name, Class) VALUES (student_name, grade); 
END $$ 


CREATE PROCEDURE proc_CategorizeStudents() 
BEGIN -- Declare variables 
DECLARE done INT DEFAULT 0; 
DECLARE student_name VARCHAR(50); 
DECLARE marks INT; -- Cursor to iterate over all students in Stud_Marks 
DECLARE cur CURSOR FOR 
SELECT name, total_marks FROM Stud_Marks; -- Declare a handler for the end of the cursor 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
OPEN cur; 
read_loop: LOOP -- Fetch student name and marks 
FETCH cur INTO student_name, marks; 
IF done = 1 THEN 
LEAVE read_loop; 
END IF; 
CALL proc_Grade(student_name, marks); 
END LOOP; 
CLOSE cur; 
END $$ 

DELIMITER ; 
call proc_CategorizeStudents(); 
select * from result;