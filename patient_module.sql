use hospitalmanagement;

select doctor_name  , status from  doctor where specification ="Dentist";
select count(doctor_id),specification from doctor group by specification,status,specification;

SELECT 
    d.department_name,
    COUNT(doc.doctor_id) AS total_doctors,
    SUM(CASE WHEN doc.status = 1 THEN 1 ELSE 0 END) AS available_doctors,
    SUM(CASE WHEN doc.status = 0 THEN 1 ELSE 0 END) AS unavailable_doctors
FROM 
    department d
JOIN 
    doctor doc ON d.department_id = doc.department_id
GROUP BY 
    d.department_name;
call hospital_table;