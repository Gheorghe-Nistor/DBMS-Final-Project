CREATE TABLE people(
    person_id NUMBER(5) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(1) NOT NULL,
    birth_date DATE NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);
CREATE TABLE members(
    member_id NUMBER(5) PRIMARY KEY,
    person_id NUMBER(5),
    student NUMBER(1) DEFAULT(0),
    starting_weight NUMBER(5,2),
    height NUMBER(5,2),
    FOREIGN KEY (person_id) REFERENCES people (person_id)
);
CREATE TABLE trainers(
    trainer_id NUMBER(5) PRIMARY KEY,
    person_id NUMBER(5),
    nutritionist NUMBER(1) DEFAULT(0),
    hire_date DATE NOT NULL, 
    salary NUMBER(6,2) NOT NULL,
    FOREIGN KEY (person_id) REFERENCES people (person_id)
);
CREATE TABLE attendance_logs (
    attendance_id NUMBER(5) PRIMARY KEY,
    member_id NUMBER(5),
    attendance_date DATE DEFAULT(sysdate),
    FOREIGN KEY (member_id) REFERENCES members (member_id)
);
CREATE TABLE memberships (
    membership_id NUMBER(5) PRIMARY KEY,
    member_id NUMBER(5), 
    membership_type_id NUMBER(5),
    payment_id NUMBER(5),
    start_date DATE DEFAULT(sysdate),
    end_date DATE NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members (member_id),
    FOREIGN KEY (membership_type_id) REFERENCES membership_types (membership_type_id),
    FOREIGN KEY (payment_id) REFERENCES payments (payment_id)
);
CREATE TABLE membership_types (
    membership_type_id NUMBER(5)PRIMARY KEY,
    membership_name VARCHAR(50) NOT NULL,
    student NUMBER(1) DEFAULT(0)
);
CREATE TABLE payments (
    payment_id NUMBER(5) PRIMARY KEY,
    payment_date DATE,
    amount NUMBER(6,2) NOT NULL,
    payment_type VARCHAR2(10)
);
CREATE TABLE training_sessions (
    training_session_id NUMBER(5) PRIMARY KEY,
    member_id NUMBER(5),
    trainer_id NUMBER(5),
    payment_id NUMBER(5),
    training_session_date DATE NOT NULL,
    weight NUMBER(5, 2),
    FOREIGN KEY (member_id) REFERENCES members (member_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers (trainer_id),
    FOREIGN KEY (payment_id) REFERENCES payments (payment_id)
); 
CREATE TABLE training_session_details (
    training_session_detail_id NUMBER(5) PRIMARY KEY,
    training_session_id NUMBER(5),
    exercise_id NUMBER(5),
    equipment_id NUMBER(5),
    FOREIGN KEY (training_session_id) REFERENCES training_sessions (training_session_id),
    FOREIGN KEY (exercise_id) REFERENCES exercises (exercise_id),
    FOREIGN KEY (equipment_id) REFERENCES equipments (equipment_id)
);
CREATE TABLE equipments (
    equipment_id NUMBER(5) PRIMARY KEY,
    equipment_name VARCHAR(50) NOT NULL
);
CREATE TABLE sets_reps_weights (
    sets_reps_weights_id NUMBER(5)PRIMARY KEY,
    training_session_detail_id NUMBER(5),
    current_set NUMBER(1),
    reps NUMBER(2),
    weight NUMBER(3),
    FOREIGN KEY (training_session_detail_id) REFERENCES training_session_details (training_session_detail_id)
);
CREATE TABLE exercises (
    exercise_id NUMBER(5) PRIMARY KEY,
    muscle_group_id NUMBER(5),
    exercise_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (muscle_group_id) REFERENCES muscle_groups (muscle_group_id)
);
CREATE TABLE muscle_groups (
    muscle_group_id INTEGER PRIMARY KEY,
    muscle_group_name VARCHAR(50) NOT NULL
);
CREATE TABLE announcements(
    announcement_id NUMBER(5) PRIMARY KEY,
    title VARCHAR(25),
    message VARCHAR(1000),
    category VARCHAR2(30),
    send_date DATE,
    sent NUMBER(1) DEFAULT(0)
);
CREATE TABLE error_logs (
    id INTEGER UNIQUE NOT NULL,
    code   INTEGER,
    message   VARCHAR2 (305),
    backtrace       CLOB,
    callstack       CLOB,
    created_on      DATE,
    created_by      VARCHAR2 (30)
);
