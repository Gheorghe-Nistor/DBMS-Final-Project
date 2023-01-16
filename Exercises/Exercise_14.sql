CREATE TABLE announcements(
    announcement_id NUMBER(5) PRIMARY KEY,
    title VARCHAR(25),
    message VARCHAR(1000),
    category VARCHAR2(30),
    send_date DATE,
    sent NUMBER(1) DEFAULT(0)
);

CREATE OR REPLACE PACKAGE Exercise_14 
    AS 
    TYPE t_announcements IS TABLE OF announcements%rowtype INDEX BY PLS_INTEGER;
    valid_announcements t_announcements;
    TYPE vector IS VARRAY(100) OF NUMBER(5);
    active_members vector; 
    
    PROCEDURE add_message(title announcements.title%type, message announcements.message%type, category announcements.category%type, send_date announcements.send_date%type);
    FUNCTION get_active_members return vector;
    FUNCTION get_valid_announcements return t_announcements;
    PROCEDURE send_messages;
END Exercise_14;
/

CREATE OR REPLACE PACKAGE BODY Exercise_14 
    AS   
    PROCEDURE add_message(title announcements.title%type, message announcements.message%type, category announcements.category%type, send_date announcements.send_date%type)
    AS
    a_id announcements.announcement_id%type;
    BEGIN    
        IF LENGTH(title) < 5 OR LENGTH(title) > 20 THEN
                RAISE_APPLICATION_ERROR(-20004, 'Titlul trebuie sã aiba o lungime cuprinsa intr 5 si 20 caractere');
        ELSIF LENGTH(message) <= 30 THEN
            RAISE_APPLICATION_ERROR(-20005, 'Continutul mesajului trebuie sã aibã minim 30 caractere');
        ELSIF category <> 'members' AND category <> 'trainers' AND category <> 'all' THEN
            RAISE_APPLICATION_ERROR(-20005, 'Categoria data este incorecta. Alege o categorie dintre: members, trainers sau all');
        ELSIF send_date < sysdate THEN
            RAISE_APPLICATION_ERROR(-20007, 'Nu poti programa un anunt pentru o data din trecut');
        END IF;
        
        SELECT NVL(MAX(announcement_id), 0)
        INTO a_id
        FROM announcements;
        
        INSERT INTO announcements
        VALUES(a_id+1, title, message, category, send_date, 0);
        DBMS_OUTPUT.PUT_LINE('Anuntul a fost adaugat cu succes');
    END add_message;
    
    FUNCTION get_active_members 
    RETURN vector
    AS
        -- un membru este considerat activ dacã are un abonament valabil, sau dacã ultimul sãu abonament a expirat acum maxim o lunã
        CURSOR c IS 
            SELECT ms.member_id
            FROM members m
            INNER JOIN memberships ms
            ON m.member_id = ms.member_id
            WHERE ADD_MONTHS(ms.END_DATE, 1) >= SYSDATE
            GROUP BY ms.member_id; -- fac group by pentru cazul in care are mai multe abonamente active
    BEGIN
        OPEN c;
        FETCH c BULK COLLECT INTO active_members;
        CLOSE c;
        return active_members;
    END get_active_members;
    
    FUNCTION get_valid_announcements 
    RETURN t_announcements
    AS 
    BEGIN
        SELECT *
        BULK COLLECT INTO valid_announcements
        FROM announcements
        WHERE TRUNC(send_date) = TRUNC(sysdate) AND sent = 0;
        
        return valid_announcements;
    END get_valid_announcements;
    
    PROCEDURE send_messages
    AS
    t_id trainers.trainer_id%type;
    email people.email%type;
    first_name people.first_name%type;
    last_name people.last_name%type;
    CURSOR trainers_cursor IS
        SELECT *
        FROM trainers t
        INNER JOIN people p
        ON p.person_id = t.person_id;
    BEGIN
        active_members := get_active_members();
        valid_announcements := get_valid_announcements();
        FOR i IN valid_announcements.FIRST..valid_announcements.LAST LOOP
            IF valid_announcements(i).category = 'trainers' OR valid_announcements(i).category = 'all' THEN
                DBMS_OUTPUT.PUT_LINE('Urmatoarele persoane vor primii anuntul cu id-ul ' || valid_announcements(i).announcement_id);
                FOR trainer IN trainers_cursor LOOP
                    apex_mail.send('nistorgeorge666@gmail.com', trainer.email, valid_announcements(i).title, valid_announcements(i).message);
                    DBMS_OUTPUT.PUT_LINE(trainer.first_name || ' ' || trainer.last_name || ': ' || trainer.email);
                END LOOP;
            ELSIF valid_announcements(i).category = 'members' OR valid_announcements(i).category = 'all' THEN 
                FOR j IN active_members.FIRST..active_members.LAST LOOP
                    SELECT p.first_name, p.last_name, p.email
                    INTO first_name, last_name, email
                    FROM members m
                    INNER JOIN people p
                    ON p.person_id = m.person_id
                    WHERE m.member_id = active_members(j);          
                    apex_mail.send('nistorgeorge666@gmail.com', email, valid_announcements(i).title, valid_announcements(i).message);
                    DBMS_OUTPUT.PUT_LINE(first_name || ' ' || last_name || ': ' || email);
                END LOOP;
            END IF;
            UPDATE announcements
            SET sent = 1
            WHERE announcement_id = valid_announcements(i).announcement_id;
        END LOOP;
    END;
END Exercise_14;
/

BEGIN
    exercise14.add_message('La multi ani', 'Anul Nou este o ocazie perfecta pentru a ne propune noi obiective si a ne seta noi metode de a ne indeplini visele. Sper ca in acest an sa ne incurajam unii pe altii sa fim mai buni si sa ne atingem potentialul maxim. La Columbia Fitness, ne dorim sa fim partenerii dvs. in atingerea obiectivelor de fitness si sanatate si sa va oferim sprijinul necesar pentru a va mentine motivatia pe parcursul anului. Haideti sa incepem Anul Nou cu determinare si sa ne bucuram de beneficiile exercitiilor fizice impreuna! Va asteptam sa ne faceti o vizita si sa incepem acest an cu pasi mai energici si mai sanatosi!', 'all', sysdate);
END;
/

SELECT * FROM announcements;

BEGIN
    exercise14.send_messages();
END;
/

