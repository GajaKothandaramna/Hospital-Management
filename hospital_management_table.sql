create database hospitalmanagement;
use hospitalmanagement;
-- SQL script to create the Online Hospital appoinment Platform database schema

-- Create department table
CREATE TABLE department(department_id INT PRIMARY  KEY AUTO_INCREMENT, 
						department_name VARCHAR(50) NOT NULL);
-- Create doctor table                    
CREATE TABLE doctor(doctor_id INT PRIMARY KEY AUTO_INCREMENT, doctor_name VARCHAR(30), department_id INT,
					phone VARCHAR(20),email VARCHAR(30),
                    FOREIGN KEY (department_id) REFERENCES department(department_id));
                    
-- Create patient table                        
CREATE TABLE patient(patient_id INT PRIMARY KEY AUTO_INCREMENT, patient_name VARCHAR(30), date_of_birth DATE,
					 gender ENUM('MALE','FEMALE','OTHERS'), phone VARCHAR(20),address TEXT,email VARCHAR(30));
-- Create appoinment table                         
CREATE TABLE appoinment(appoinment_id INT PRIMARY KEY AUTO_INCREMENT, patient_id INT, doctor_id INT,
						appoinment_date DATETIME,status ENUM('Schelduled','Completed','Cancelled'),
						FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
						FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id));
-- Create treatment table
CREATE TABLE treatment(treatment_id INT PRIMARY KEY AUTO_INCREMENT, appoinment_id INT, patient_id INT,
						description TEXT, treatment_date DATE,
						FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
						FOREIGN KEY (appoinment_id) REFERENCES appoinment(appoinment_id));
			
-- Create medication table
CREATE TABLE medication(medication_id INT PRIMARY KEY AUTO_INCREMENT, patient_id INT,
						medication_name VARCHAR(50), dosage VARCHAR(100),
                        start_date DATE, end_date DATE,
						FOREIGN KEY (patient_id) REFERENCES patient(patient_id));
                        
                       
-- Insert data into department table
insert into department (department_name)  values ("Pediatrics"),("Dentist"),("Cardiology"),("Neurology"),
("orthology"),("gerneral_physican"),("dermatology"),("Radiology"),("Surgical");

-- Insert data into doctor table
insert into doctor (doctor_id, department_id, doctor_name, phone, email,specification)  values
			(1, 1, "Ankur", 9632587415, "ankur123@gmail.com","pediatrics"),
            (2, 2, "perina", 7418529636, "perina4123@gmail.com","Dentist"),
            (3, 3, "shwetha", 7587419632, "shwetha987@gmail.com","Cardiology"),
            (4, 4, "rahul", 8321456987, "rahul852@gmail.com","Neurology"),
            (5, 5, "thomas", 9517864123, "rahul_123@gmail.com","orthology"),
            (6, 6, "sheethal", 8963254179, "sheethal_87@gmail.com","general_physican"),
            (7, 7, "sakshi", 9632587411, "sakshi852@gmail.com","dermatology"),
            (8, 8, "rajagopal", 9632587415, "raja@gmail.com","Radiology"),
            (9, 9, "john", 9632587415, "john456@gmail.com","Surgical");
           
-- insert data into patient table
delimiter //
	create procedure add_patient(IN p_id INT, IN p_name VARCHAR(30), IN dob DATE,IN 
					p_gender ENUM('MALE','FEMALE','OTHERS'),IN p_phone VARCHAR(30),
                    IN p_address TEXT, IN p_email VARCHAR(30))
	begin
    declare exit handler for sqlexception
	begin
	select 'error has occured';
	end;
		insert into patient (patient_id, patient_name, date_of_birth, gender,phone, address,email) 
        values (p_id,p_name,dob,p_gender,p_phone,p_address,p_email); 
        select ' patient inserted';
	end //
delimiter ;
call add_patient(3,"thomas","1985-7-09","male",8521479635,"Bangalore","thomas123@gmail.com");

alter table doctor add specification VARCHAR(50); 
alter table treatment add column doctor_id INT;
alter table doctor add column status ENUM('available','unavailable');
update doctor set status ='available' where doctor_id=12;
insert into doctor (department_id, doctor_name, phone, email,specification)  values
			( 1, "harpeet", 8521479634, "harpeet123@gmail.com","pediatrics"),
            ( 2, "sheethal", 9631478526, "sheethal123@gmail.com","Dentist"),
			( 6, "gaurav", 9871236547, "gaurav@gmail.com","general_physican");
select * from doctor;
show procedure status where db="hospitalmanagement";
drop procedure add_patient;		  
                        
                    
                    

					
                         
