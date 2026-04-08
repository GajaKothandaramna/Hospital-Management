use hospitalmanagement;
-- doctor view upcoming appoinment
create view upcoming_appointment as SELECT appoinment.appoinment_id, appoinment.appoinment_date, 
			patient.patient_name,doctor.doctor_name, appoinment.status FROM appoinment 
			join patient on appoinment.patient_id = patient.patient_id
            join doctor on appoinment.doctor_id = doctor.doctor_id
            where appoinment.appoinment_date >= DATE(now());
	
-- doctor view patient report
select * from upcoming_appointment;
delimiter //
create procedure  patient_report (IN doc_id INT)
begin
	declare treatment_exists INT;
    declare medication_exists INT;
		select count(*) into treatment_exists from treatment where doctor_id = doc_id;
			if treatment_exists = 0 then
				Select "No treatment found";
			else
				SELECT count(*) into medication_exists from treatment
				join medication ON treatment.patient_id = medication.patient_id
				where treatment.doctor_id = doc_id;
			if medication_exists = 0 then
				Select "No medication found";
			else
				SELECT patient.patient_id, patient.patient_name,treatment.treatment_id,treatment.description, 
                treatment.treatment_date,medication.medication_name,medication.dosage,medication.start_date,medication.end_date FROM patient 
				join treatment on patient.patient_id = treatment.patient_id
				join medication on patient.patient_id = medication.patient_id
				where treatment.doctor_id =doc_id;
		  end if;
          end if;
end //
delimiter ;
call patient_report(5);

call hospital_table();
select * from upcoming_appointment;
select * from patient_report;

drop procedure patient_report;

call hospital_table();

drop procedure patient_report;
