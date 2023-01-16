CREATE OR REPLACE PROCEDURE Exercise_9(m_last_name IN people.last_name%type, m_first_name IN people.first_name%type DEFAULT NULL)
IS
    m_id members.member_id%type;
    status NUMBER(1) := 0;
    CURSOR get_member_first_name_cursor(t_last_name people.last_name%type) IS
        SELECT p.first_name, p.last_name
        FROM people p
        INNER JOIN members m
        ON p.person_id = m.person_id
        WHERE p.last_name = m_last_name;
    -- am folosit 9 tabele
    CURSOR all_eligible_members_cursor IS 
        SELECT m.member_id as member_id, MAX(p.first_name) as first_name, MAX(p.last_name) as last_name
        FROM members m
        INNER JOIN attendance_logs al
        ON m.member_id = al.member_id
        INNER JOIN people p
        ON m.person_id = p.person_id
        WHERE attendance_date <= add_months(trunc(sysdate,'year'), -24) and m.member_id IN (
            SELECT active_members.member_id  
            FROM training_session_details tsd
            JOIN training_sessions ts
            ON tsd.training_session_id = ts.training_session_id
            JOIN exercises ex
            ON tsd.exercise_id = ex.exercise_id
            JOIN equipments eq
            ON tsd.equipment_id = eq.equipment_id
            JOIN sets_reps_weights srw
            ON tsd.training_session_detail_id = srw.training_session_detail_id
            JOIN (
                SELECT m.member_id
                FROM members m
                INNER JOIN memberships ms
                ON m.member_id = ms.member_id
                WHERE ADD_MONTHS(ms.END_DATE, 1) >= SYSDATE
            ) active_members
            ON ts.member_id = active_members.member_id
            WHERE ex.exercise_name = 'squats' and eq.equipment_name = 'squat rack' and srw.reps >= 5 and srw.weight >= 120)
        Group BY m.member_id;
BEGIN
    IF m_first_name IS NULL THEN 
        SELECT m.member_id
        INTO m_id
        FROM people p
        INNER JOIN members m
        ON p.person_id = m.person_id
        WHERE p.last_name = m_last_name;    
    ELSE 
       SELECT m.member_id
        INTO m_id
        FROM people p
        INNER JOIN members m
        ON p.person_id = m.person_id
        WHERE p.last_name = m_last_name AND p.first_name = m_first_name;
    END IF;
    -- in cursorul all_eligible_members_cursor sunt salvati toti membrii care sunt eligili pentru un interviu
    -- cautam daca membrul dat ca parametru se afla in aceasta lista
    FOR i IN all_eligible_members_cursor LOOP
        IF i.member_id = m_id THEN
           status := 1;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT(m_last_name || ' ');
    IF m_first_name IS NOT NULL THEN
        DBMS_OUTPUT.PUT(m_first_name || ' ');
    END IF;
    IF status = 0 THEN
        DBMS_OUTPUT.PUT('NU ');
    END IF;
    DBMS_OUTPUT.PUT('indeplineste toate criteriile pentru interview');
    DBMS_OUTPUT.NEW_LINE;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            record_error();
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun client cu numele de familie ' || m_last_name);
        WHEN TOO_MANY_ROWS THEN
            record_error();
            DBMS_OUTPUT.PUT_LINE('Exista mai multi clienti cu numele de familie ' || m_last_name);
            DBMS_OUTPUT.PUT_LINE('In acest caz functia trebuie apelata imrepuna cu prenume clientului');
            FOR i IN get_member_first_name_cursor(m_last_name) LOOP
                DBMS_OUTPUT.PUT_LINE(i.last_name || ' ' || i.first_name);
            END LOOP; 
END;
/

BEGIN
    Exercise_9('Nistor');
END;
/

BEGIN
    Exercise_9('Mihailescu');
END;
/

BEGIN
    Exercise_9('Ionescu');
END;
/

BEGIN
    Exercise_9('Ionescu', 'Maria');
END;
/

Select * 
FROM error_logs;