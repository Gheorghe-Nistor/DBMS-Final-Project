CREATE OR REPLACE PROCEDURE Exercise7
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
END;
/

BEGIN
    Exercise7();
END;