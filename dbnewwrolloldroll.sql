-- practical 6

CREATE TABLE IF NOT EXISTS N_RollCall ( 
roll_no INT PRIMARY KEY, 
student_name VARCHAR(100), 
attendance_date DATE 
); 
CREATE TABLE IF NOT EXISTS O_RollCall ( 
roll_no INT PRIMARY KEY, 
student_name VARCHAR(100), 
attendance_date DATE 
); 
DELIMITER // 
CREATE PROCEDURE  merge_rollcalls() 
BEGIN 
DECLARE done INT DEFAULT FALSE; 
DECLARE v_roll_no INT; 
DECLARE v_student_name VARCHAR(100); 
DECLARE v_attendance_date DATE; -- Declare a cursor to iterate through the N_RollCall table 
DECLARE cur_rollcall CURSOR FOR  
SELECT roll_no, student_name, attendance_date FROM N_RollCall; -- Declare a handler for when the cursor reaches the end 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 
OPEN cur_rollcall; 
read_loop: LOOP 
FETCH cur_rollcall INTO v_roll_no, v_student_name, v_attendance_date; 
IF done THEN 
LEAVE read_loop; 
END IF; -- Check if the record exists in O_RollCall 
IF NOT EXISTS (SELECT 1 FROM O_RollCall WHERE roll_no = v_roll_no) THEN 
INSERT INTO O_RollCall (roll_no, student_name, attendance_date) 
VALUES (v_roll_no, v_student_name, v_attendance_date); 
END IF; 
END LOOP; 
CLOSE cur_rollcall; 
END // 
DELIMITER ; 
INSERT INTO O_RollCall (roll_no, student_name, attendance_date)  
VALUES  
(101, 'John Doe', '2024-08-25'), -- Same roll_no as in N_RollCall 
(106, 'David Green', '2024-08-30'), -- New roll_no 
(107, 'Eve Blue', '2024-09-01'); 
INSERT INTO N_RollCall (roll_no, student_name, attendance_date)  
VALUES  
(111, 'John Doe', '2024-09-01'), 
(112, 'Jane Smith', '2024-09-02'), 
(113, 'Alice Brown', '2024-09-01'), 
(114, 'Bob White', '2024-09-03'), 
(115, 'Charlie Black', '2024-09-04'); 
DELIMITER  // 
CALL merge_rollcalls(); 
DELIMITER ; 
select * from O_RollCall;
select * from N_RollCall;