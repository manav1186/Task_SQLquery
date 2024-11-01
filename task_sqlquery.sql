use employee;
show tables;

CREATE TABLE EMPLOYEE (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    manager_id INT,  -- This will link to the emp_id of the manager
    FOREIGN KEY (manager_id) REFERENCES EMPLOYEE(emp_id) -- Self-reference for manager_id
);

CREATE TABLE MANAGER (
    emp_id INT PRIMARY KEY,    -- Unique ID for each manager (also an employee)
    manager_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES EMPLOYEE(emp_id) -- Ensuring managers are also in the EMPLOYEE table
);

INSERT INTO EMPLOYEE (emp_id, first_name, last_name, manager_id) VALUES 
(1, 'Eve', 'Smith', NULL),    -- Eve is a manager
(2, 'Frank', 'Thomas', NULL),  -- Frank is also a manager
(3, 'Alice', 'Johnson', 1),    -- Alice reports to Eve
(4, 'Bob', 'Lee', 1),          -- Bob reports to Eve
(5, 'Charlie', 'Brown', 2),    -- Charlie reports to Frank
(6, 'Diana', 'Prince', 2);     -- Diana reports to Frank

INSERT INTO MANAGER (emp_id, manager_name) VALUES 
(1, 'Eve Smith'),         -- Manager with emp_id 1
(2, 'Frank Thomas');      -- Manager with emp_id 2

select * from employee;
select * from manager; --

#Question1 - get all employees under each manager

SELECT 
    m.first_name AS Manager_First_Name,
    m.last_name AS Manager_Last_Name,
    e.emp_id AS Employee_ID,
    e.first_name AS Employee_First_Name,
    e.last_name AS Employee_Last_Name
FROM 
    EMPLOYEE e
JOIN 
    EMPLOYEE m ON e.manager_id = m.emp_id
WHERE 
    e.manager_id IS NOT NULL -- Ensure we only select employees that have a manager
ORDER BY 
    m.first_name, e.first_name; -- Order by manager name and then by employee name
    
#Question 2 - how many employees are there in under manager Eve Smith

SELECT 
    COUNT(*) AS Employee_Count
FROM 
    EMPLOYEE
WHERE 
    manager_id = (SELECT emp_id FROM EMPLOYEE WHERE first_name = 'Eve' AND last_name = 'Smith');
    
#Question 3 - get all manager details

SELECT 
    m.emp_id AS Manager_ID,
    m.manager_name AS Manager_Name,
    GROUP_CONCAT(CONCAT(e.first_name, ' ', e.last_name) ORDER BY e.first_name SEPARATOR ', ') AS Employees_managed
FROM 
    MANAGER m
LEFT JOIN 
    EMPLOYEE e ON m.emp_id = e.manager_id
GROUP BY 
    m.emp_id, m.manager_name;
    
#Question 4 - find any employee is there till not assigned by manager

SELECT 
    emp_id AS Employee_ID,
    first_name AS Employee_First_Name,
    last_name AS Employee_Last_Name
FROM 
    EMPLOYEE
WHERE 
    manager_id IS NULL AND emp_id NOT IN (SELECT emp_id FROM MANAGER);
    
#Question 5 - Write a function to get full name (firstname + lastname)

DELIMITER $$

CREATE FUNCTION get_full_names(emp_id INT) 
RETURNS VARCHAR(100)
deterministic
BEGIN
    DECLARE full_name VARCHAR(100);
    
    SELECT CONCAT(first_name, ' ', last_name) INTO full_name
    FROM EMPLOYEE
    WHERE emp_id = emp_id
    LIMIT 1; 
    
    RETURN full_name;
END$$

DELIMITER ;

SELECT get_full_names(2) as full_name;







