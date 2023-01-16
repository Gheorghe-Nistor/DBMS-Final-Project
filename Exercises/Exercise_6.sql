CREATE OR REPLACE TYPE vector AS VARRAY(100) OF NUMBER(5);
/

CREATE OR REPLACE PROCEDURE get_active_members_procedure(active_members IN OUT vector)
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
END;
/

CREATE OR REPLACE PROCEDURE macronutrients_message(weight IN NUMBER, kcal IN NUMBER, email_message IN OUT VARCHAR2)
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
END;
/

CREATE OR REPLACE PROCEDURE Exercise_6
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
END;
/

BEGIN
    Exercise_6();
END;
/
