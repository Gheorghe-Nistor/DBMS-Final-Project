CREATE OR REPLACE PACKAGE Exercise_13 
AS 
    TYPE vector IS VARRAY(100) OF NUMBER(5);
    PROCEDURE get_active_members_procedure(active_members IN OUT vector);
    PROCEDURE macronutrients_message(weight IN NUMBER, kcal IN NUMBER, email_message IN OUT VARCHAR2);
    PROCEDURE Exercise_6;
    PROCEDURE Exercise_7;
    FUNCTION Exercise_8(t_last_name IN people.last_name%type, t_first_name IN people.first_name%type DEFAULT NULL) RETURN trainers.trainer_id%type;
    PROCEDURE Exercise_9(m_last_name IN people.last_name%type, m_first_name IN people.first_name%type DEFAULT NULL);
    PROCEDURE record_error;
END Exercise_13;
/

CREATE OR REPLACE PACKAGE BODY Exercise_13 AS
    PROCEDURE get_active_members_procedure(active_members IN OUT vector)
    IS
        -- un membru este considerat activ dacã are un abonament valabil, sau dacã ultimul sãu abonament a expirat acum maxim o lunã
        CURSOR c IS 
            SELECT m.member_id
            FROM members m
            INNER JOIN memberships ms
            ON m.member_id = ms.member_id
            WHERE ADD_MONTHS(ms.END_DATE, 1) >= SYSDATE;
    BEGIN
        OPEN c;
        FETCH c BULK COLLECT INTO active_members;
        CLOSE c;
    END get_active_members_procedure;
    PROCEDURE macronutrients_message(weight IN NUMBER, kcal IN NUMBER, email_message IN OUT VARCHAR2)
    IS
        proteins NUMBER(5);
        carbohydrates NUMBER(5);
        fat NUMBER(5);
    BEGIN
        proteins := 2*weight;
        fat := 0.3*2.2*weight;
        carbohydrates := (kcal-(proteins*4+fat*9))/4;
        email_message := email_message || 
            '<td>'||kcal||'g</td>
            <td>'||proteins||'g</td>
            <td>'||carbohydrates ||'g</td>
            <td>'||fat||'g</td></tr>';
    END macronutrients_message;
    PROCEDURE Exercise_6
    IS
        TYPE nested_table IS TABLE OF members%ROWTYPE;
        active_members vector := vector();
        trained_by_a_nutritionist nested_table := nested_table();
        status NUMBER(1);
        j      NUMBER(5);
        current_weight training_sessions.weight%type;
        first_name people.first_name%type;
        last_name people.last_name%type;
        email people.email%type;
        email_message VARCHAR(1000) := '';
        kcal   NUMBER(5);
    BEGIN
        get_active_members_procedure(active_members);
        -- adãgãm în tabelul trained_by_a_nutritionist toti membrii activi 
        -- care sunt antrenati de cãtre un instructor specializat în nutritie
        j := 1;
        FOR i IN active_members.FIRST..active_members.LAST LOOP
            SELECT COUNT(*) 
            INTO status
            FROM training_sessions ts
            INNER JOIN members m
            ON ts.member_id = m.member_id
            INNER JOIN trainers t
            ON ts.trainer_id = t.trainer_id
            WHERE m.member_id = active_members(i) AND t.nutritionist = 1 AND rownum = 1;
            IF status = 1 THEN
                trained_by_a_nutritionist.extend;
                SELECT * 
                INTO trained_by_a_nutritionist(j)
                FROM members
                WHERE member_id = active_members(i);
                j := j+1;
            END IF;
        END LOOP;
        
        WHILE j > 1 LOOP
            j := j-1;
            SELECT weight 
            INTO current_weight
                FROM (
                    SELECT *
                    FROM training_sessions
                    WHERE member_id = trained_by_a_nutritionist(j).member_id
                    ORDER BY training_session_date DESC)
            WHERE rownum = 1;
            
            SELECT p.first_name, p.last_name, p.email
            INTO first_name, last_name, email
            FROM members m
            INNER JOIN people p
            ON m.person_id = p.person_id
            WHERE m.member_id = trained_by_a_nutritionist(j).member_id;
            
            email_message :=  '<p>Salutare, '|| first_name || '</p>
            <p>Pentru greutatea ta actuala de <strong>'||current_weight||' kg</strong> iti recomand sã iti consumi macronutrientii in felul urmator: </p>
            <table>
            <tr>
                <th>Scop</th>
                <th>Kcal</th>
                <th>Proteine</th>
                <th>Carbohidrati</th>
                <th>Grasime</th>
            </tr>';
            -- deficit caloric, kcal de mentinere - 500
            kcal := current_weight*2.2*15;
            kcal := kcal-500;
            email_message := email_message || '<tr><td>Deficit</td>';
            macronutrients_message(current_weight, kcal, email_message);
            -- mentinere
            kcal := kcal+500;
            email_message := email_message || '<tr><td>Mentinere</td>';
            macronutrients_message(current_weight, kcal, email_message);
            -- surplus caloric, kcal de mentinere + 300
            kcal := kcal+300;
            email_message := email_message || '<tr><td>Surplus</td>';
            macronutrients_message(current_weight, kcal, email_message);
            email_message := email_message || '</table><p>O zi bunã cu împliniri!</p>';
            ----trimitere mail
            apex_mail.send('nistorgeorge666@gmail.com', email, 'Tabel macronutrienti', email_message);
            DBMS_OUTPUT.PUT_LINE(first_name || ' ' || last_name || ' a primit mail cu succes!');
        END LOOP;
    END Exercise_6;
    PROCEDURE Exercise_7
    IS
        CURSOR active_members_over_16 IS 
            SELECT m.member_id, p.first_name, p.last_name
            FROM members m
            INNER JOIN memberships ms
            ON m.member_id = ms.member_id
            INNER JOIN people p
            ON p.person_id = m.person_id
            WHERE ADD_MONTHS(ms.END_DATE, 1) > SYSDATE AND (months_between(TRUNC(sysdate), p.birth_date)/12) >= 16;
            
        CURSOR number_of_entrances(id members.member_id%type) IS
            SELECT COUNT(*)
            FROM attendance_logs
            WHERE member_id = id AND EXTRACT(YEAR FROM attendance_date) = EXTRACT(YEAR FROM SYSDATE);
            
        TYPE m_record IS RECORD (
            member_id members.member_id%type,
            first_name people.first_name%type,
            last_name people.last_name%type,
            nr INTEGER := 0
        );
        current members.member_id%type;
        first m_record;
        second m_record;
        third m_record;
    BEGIN
        FOR m in active_members_over_16 LOOP
            OPEN number_of_entrances(m.member_id);
            FETCH number_of_entrances INTO current;
            CLOSE number_of_entrances;
            IF current > first.nr THEN
                third := second;
                second := first;
                
                first.nr := current;
                first.member_id := m.member_id;
                first.first_name := m.first_name;
                first.last_name := m.last_name;
                
            ELSIF current > second.nr THEN 
                third := second;
                
                second.nr := current;
                second.member_id := m.member_id;
                second.first_name := m.first_name;
                second.last_name := m.last_name;
                
            ELSIF current > third.nr THEN 
                third.nr := current;
                third.member_id := m.member_id;
                third.first_name := m.first_name;
                third.last_name := m.last_name;
            END IF;
        END LOOP;
        
        IF first.nr > 0 THEN
            DBMS_OUTPUT.PUT_LINE(first.first_name || ' ' || first.last_name || ' are ' || first.nr || ' intrari la sala in anul ' || EXTRACT(YEAR FROM SYSDATE));
        END IF;
        IF second.nr > 0 THEN
            DBMS_OUTPUT.PUT_LINE(second.first_name || ' ' || second.last_name || ' are ' || second.nr || ' intrari la sala in anul ' || EXTRACT(YEAR FROM SYSDATE));
        END IF;
        IF third.nr > 0 THEN
            DBMS_OUTPUT.PUT_LINE(third.first_name || ' ' || third.last_name || ' are ' || third.nr || ' intrari la sala in anul ' || EXTRACT(YEAR FROM SYSDATE));
        END IF;
    END Exercise_7;
    FUNCTION Exercise_8(t_last_name IN people.last_name%type, t_first_name IN people.first_name%type DEFAULT NULL)
    RETURN trainers.trainer_id%type
    IS
        number_of_rows NUMBER;
        t_id trainers.trainer_id%type;
        salary trainers.salary%type;
        bonus payments.amount%type;
        no_trainer_found EXCEPTION;
        too_many_trainers_found EXCEPTION;
        CURSOR get_trainer_first_name_cursor(t_last_name people.last_name%type) IS
            SELECT p.first_name, p.last_name
            FROM people p
            INNER JOIN trainers t
            ON p.person_id = t.person_id
            WHERE p.last_name = t_last_name;
            
    BEGIN
        -- mã folosesc de acest query pentru a arunca exceptiile de cãtre mine, manual
        SELECT COUNT(*) as number_of_rows
        INTO number_of_rows
        FROM trainers t
        INNER JOIN people p
        ON t.person_id = p.person_id
        WHERE  p.last_name = t_last_name AND p.first_name =
            (CASE 
                WHEN t_first_name IS NOT NULL THEN  
                     t_first_name
                ELSE 
                    p.first_name
            END);
        
        IF number_of_rows= 0 THEN
            RAISE no_trainer_found;
        ELSIF number_of_rows > 1 THEN
            RAISE too_many_trainers_found;
        END IF;
        
        SELECT t.trainer_id 
        INTO t_id
        FROM trainers t
        INNER JOIN people p
        ON t.person_id = p.person_id
        WHERE  p.last_name = t_last_name AND p.first_name =
            (CASE 
                WHEN t_first_name IS NOT NULL THEN  
                     t_first_name
                ELSE 
                    p.first_name
            END);
        
        SELECT salary
        INTO salary
        FROM trainers t
        WHERE t.trainer_id = t_id;
        
        SELECT NVL(SUM(p.amount), 0)
        INTO bonus
        FROM trainers t
        JOIN training_sessions ts
        ON t.trainer_id = ts.trainer_id
        JOIN payments p
        ON p.payment_id = ts.payment_id
        WHERE t.trainer_id = t_id AND ts.training_session_date >= TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') AND ts.training_session_date <= trunc(sysdate, 'MM');
        
        IF bonus <> 0 THEN
            salary := salary + 0.1*bonus;
        END IF;
        RETURN salary;
        
        EXCEPTION 
            WHEN no_trainer_found THEN
                DBMS_OUTPUT.PUT_LINE('Nu exista niciun antrenor cu numele de familie ' || t_last_name);
            WHEN too_many_trainers_found THEN
                DBMS_OUTPUT.PUT_LINE('Exista mai multi antrenor cu numele de familie ' || t_last_name);
                DBMS_OUTPUT.PUT_LINE('In acest caz functia trebuie apelata imrepuna cu prenume instructorului');
                FOR i IN get_trainer_first_name_cursor(t_last_name) LOOP
                    DBMS_OUTPUT.PUT_LINE(i.last_name || ' ' || i.first_name);
                END LOOP; 
    END Exercise_8;
    PROCEDURE Exercise_9(m_last_name IN people.last_name%type, m_first_name IN people.first_name%type DEFAULT NULL)
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
    END Exercise_9;
    PROCEDURE record_error
    IS
       PRAGMA AUTONOMOUS_TRANSACTION; 
       id INTEGER;
       code INTEGER := SQLCODE;
    BEGIN
        SELECT MAX(id)
                INTO id 
                FROM error_logs; 
                IF id IS NULL THEN
                    id := 0;
                END IF;
       INSERT INTO error_logs 
       VALUES (id+1, CODE, DBMS_UTILITY.FORMAT_ERROR_STACK, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, DBMS_UTILITY.FORMAT_CALL_STACK, SYSDATE, USER);
       COMMIT;
    END record_error; 
END Exercise_13;
/
