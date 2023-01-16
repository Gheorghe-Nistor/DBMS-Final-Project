CREATE OR REPLACE TRIGGER Exercise_10
BEFORE INSERT OR UPDATE OR DELETE 
ON attendance_logs
-- attendance_logs, training_sessions
DECLARE
    current_hour NUMBER(2);
BEGIN 
    SELECT extract(hour from cast(sysdate as timestamp))
    INTO current_hour
    FROM DUAL;
    IF ((TO_CHAR(SYSDATE,'D') = 6) OR (TO_CHAR(SYSDATE,'D') = 1)) THEN
        IF current_hour < 8  THEN 
        RAISE_APPLICATION_ERROR(-20001, 'In weekend, sala este deschisa doar in intervalul 08.00-24:00');
        END IF;
    ELSIF current_hour > 1 AND current_hour < 6 THEN 
        RAISE_APPLICATION_ERROR(-20002, 'In cursul saptamanii, sala este deschisa doar in intervalul 06.00-01:00');
    END IF;
END;
/