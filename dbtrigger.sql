-- practical 8-- Step 1: Create Library table

drop table Library;
drop table Library_Audit;
CREATE TABLE IF NOT EXISTS Library ( 
    book_id INT PRIMARY KEY, 
    title VARCHAR(100), 
    author VARCHAR(100), 
    published_year INT, 
    quantity INT 
);

-- Step 2: Create Library_Audit table

CREATE TABLE IF NOT EXISTS Library_Audit ( 
    audit_id INT AUTO_INCREMENT PRIMARY KEY, 
    action_type VARCHAR(10), 
    book_id INT, 
    title VARCHAR(100), 
    author VARCHAR(100), 
    published_year INT, 
    quantity INT, 
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

-- Step 3: Create Trigger for updates
DELIMITER $$

CREATE TRIGGER after_library_update 
AFTER UPDATE ON Library 
FOR EACH ROW 
BEGIN 
    INSERT INTO Library_Audit (action_type, book_id, title, author, published_year, quantity) 
    VALUES ('UPDATE', OLD.book_id, OLD.title, OLD.author, OLD.published_year, OLD.quantity); 
END $$

-- Step 4: Create Trigger for deletes
CREATE TRIGGER after_library_delete 
AFTER DELETE ON Library 
FOR EACH ROW 
BEGIN 
    INSERT INTO Library_Audit (action_type, book_id, title, author, published_year, quantity) 
    VALUES ('DELETE', OLD.book_id, OLD.title, OLD.author, OLD.published_year, OLD.quantity); 
END $$

DELIMITER ;

-- Step 5: Insert initial data into Library table
INSERT INTO Library (book_id, title, author, published_year, quantity)  
VALUES (1, 'Book Title 1', 'Author 1', 2020, 10),
       (2, 'Book Title 2', 'Author 2', 2021, 15);

-- Step 6: Perform an UPDATE operation
UPDATE Library 
SET title = 'Updated Book Title 1' 
WHERE book_id = 1;

-- Step 7: Perform a DELETE operation
DELETE FROM Library 
WHERE book_id = 1;

-- Step 8: Query the Library_Audit table to verify audit records
SELECT * FROM Library_Audit;