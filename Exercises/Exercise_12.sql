DROP TABLE ddl_logs;
CREATE TABLE ddl_logs (
    id NUMBER(5) UNIQUE NOT NULL,
    system_event VARCHAR2(50),
    object_name VARCHAR2(50),
    object_type VARCHAR2(50),
    created_on  DATE,
    created_by  VARCHAR2 (30)
);

CREATE OR REPLACE TRIGGER Exercise_12
AFTER CREATE OR ALTER OR DROP ON SCHEMA
DECLARE
    id NUMBER;
BEGIN 
    SELECT MAX(id)
    INTO id 
    FROM ddl_logs; 
    IF id IS NULL THEN
       id := 0;
    END IF;
    INSERT INTO ddl_logs
    VALUES(id+1, SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYS.DICTIONARY_OBJ_TYPE, SYSDATE, SYS.LOGIN_USER);
END;
/
 
CREATE TABLE test (
    id INTEGER
);

DROP TABLE test;

SELECT * FROM ddl_logs;
