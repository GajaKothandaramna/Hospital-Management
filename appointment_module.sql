use hospitalmanagement;

-- Scheldule the appoinment
delimiter //
	create procedure scheldule_appointment(IN p_id INT, IN d_id INT,IN app_date DATETIME,
					app_status ENUM('Schelduled','Completed','Cancelled'))
    begin
   		if exists (select * from patient where patient_id = p_id) then
			if (select  status from doctor where doctor_id = d_id) = 'available' then
				insert into appoinment (patient_id, doctor_id, appoinment_date,status)  -- appoinment_id,
				values (p_id,d_id,app_date,app_status);  
				select 'Appointment Schelduled';
			else 
              select "doctor is not avaialble";
			end if;
        else
			select 'Patient ID does not exist';
        end if;
    end //
delimiter ;

call scheldule_appointment(3,5,now(),'Schelduled'); 

-- create a appoinment log using trigger
create table appointment_log(log_id INT PRIMARY KEY AUTO_INCREMENT,
			appointment_id INT, patient_id INT, doctor_id INT, appoinmnet_date DATETIME,
            status VARCHAR(30),created_at TIMESTAMP default current_timestamp);

delimiter //
	create trigger after_appoinment_insert 
    after insert on appoinment
	for each row
	begin
	insert into appointment_log (appointment_id,patient_id,doctor_id,appoinment_date, status)
	values(New.appoinment_id,New.patient_id,New.doctor_id,New.appoinment_date,New.status);
	end //
delimiter ;
 
select * from appointment_log;

-- update doctor availability status when appointment booked  or cancelled
delimiter //
	create trigger after_appointment_booked_update
    after insert on appoinment
	for each row
	begin
		update doctor set status = 'unavailable' where doctor_id=new.doctor_id;
	end //
delimiter ;

-- update doctor availability status when appointment booked  or cancelled
delimiter //
	create trigger after_appointment_cancelled
    after update on appoinment
	for each row
	begin
		if new.status = 'unavailable' then
		update doctor set status = 'available' where doctor_id=new.doctor_id;
	end if;
	end //
delimiter ;

drop trigger after_appointment_booked;
call hospital_table;

drop procedure scheldule_appointment;
-- Recorded the treatment
delimiter //
	create procedure record_treatment(IN treat_id INT,IN app_id INT, IN pt_id INT,
					IN t_descrp TEXT, tt_date DATE,tt_docid INT)
    begin
		insert into treatment (treatment_id,appoinment_id, patient_id, description,treatment_date,doctor_id)  -- appoinment_id,
        values (treat_id, app_id, pt_id, t_descrp, tt_date,tt_docid);  
    end //
delimiter ;
call record_treatment(3,4,1,"Blood Pressure",curdate(),3);    

    
-- Prescribe Medication
delimiter //
	create procedure prescribe_medicine(IN medi_id INT,IN pat_id INT, IN medi_name VARCHAR(30),
					IN medi_dosage VARCHAR(100), IN medi_startdate DATE,IN medi_enddate DATE)
	begin
		insert into medication (medication_id,patient_id, medication_name, dosage,start_date,end_date)  -- appoinment_id,
        values (medi_id, pat_id, medi_name, medi_dosage, medi_startdate,medi_enddate);  
	end //
delimiter ;

call prescribe_medicine(3,1,"Telma","10mg once a day",curdate(),date_add(curdate(), interval 5 day));  

 
 -- add treatment and medication automatically
 delimiter //
 create  procedure add_treatment_medication(IN app_id INT, IN p_id INT, IN tdesc text, IN t_date DATE,
					IN medname VARCHAR(100), IN mdosage VARCHAR(50), IN s_date DATE, IN e_date DATE)
	begin
    declare last_treatment_id INT;
    START TRANSACTION;
    insert into treatment (appoinment_id, patient_id, description, treatment_date)
    values (app_id, p_id, tdesc, t_date);
    SET last_treatment_id = last_insert_id();
    insert into medication (patient_id, medication_name, dosage, start_date, end_date)
    values (p_id, medname, mdosage, s_date, e_date);
    COMMIT;
    end //
    Delimiter ;
    
    call add_treatment_medication(3,2,'Antibiotic treatment for infection',curdate(),
								'Amoxicillin','500mg',curdate(),date_add(curdate(), interval 5 day));
                                
  drop procedure add_treatment_medication;
  call hospital_table();

show procedure status where db="hospitalmanagement";
drop procedure prescribe_medicine;
  