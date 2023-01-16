CREATE OR REPLACE FUNCTION Exercise_8(t_last_name IN people.last_name%type, t_first_name IN people.first_name%type DEFAULT NULL)
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
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(Exercise8('Petrescu'));
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(Exercise8('Oprea'));
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(Exercise8('Petrescu', 'Ioan'));
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(Exercise8('Mihailescu'));
END;
/
