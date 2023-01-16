CREATE OR REPLACE TRIGGER Exercise_11
BEFORE INSERT OR UPDATE ON attendance_logs
FOR EACH ROW
DECLARE
    membership_name membership_types.membership_name%type;
BEGIN 
    IF UPDATING AND (:OLD.member_id) <> (:NEW.member_id) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Este strict interzisa schimbarea id-ului unui membru');
    END IF;
        
    SELECT mt.membership_name
    INTO membership_name
    FROM members m
    INNER JOIN memberships ms
    ON m.member_id = ms.member_id
    INNER JOIN membership_types mt
    ON ms.membership_type_id = mt.membership_type_id
    WHERE m.member_id = (:NEW.member_id) AND ms.end_date >= (:NEW.attendance_date);
 
    DBMS_OUTPUT.PUT_LINE(membership_name);   
    IF membership_name LIKE '%day%' AND extract(hour from cast(sysdate as timestamp)) > 16 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Accesul �n sala de fitness pe baza unui abonament de tipul day-time se face p�n� la ora 16');
    END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            record_error();
            DBMS_OUTPUT.PUT_LINE('Accesul �n sala de fitness este permis numai pe baza unui abonament activ');
        WHEN TOO_MANY_ROWS THEN
            record_error();
            DBMS_OUTPUT.PUT_LINE('Clientul introdus mai multe abonamente active');
END;
/

-- un client fara un abonament activ intra la sala
INSERT INTO attendance_logs
VALUES (21, 5, TO_DATE('29-01-2023', 'DD-MM-YYYY'));

-- un client cu un abonament de tip day-time intra in sala dupa ora 16
INSERT INTO attendance_logs
VALUES (21, 3, TO_DATE('29-01-2023', 'DD-MM-YYYY'));

-- un client are mai multe abonamente active
INSERT INTO attendance_logs
VALUES (21, 4, TO_DATE('25-01-2023', 'DD-MM-YYYY'));

-- schimbarea id-ului unui membru
UPDATE attendance_logs
SET member_id = 1
WHERE attendance_id = 20;


