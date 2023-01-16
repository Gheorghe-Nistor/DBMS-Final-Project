INSERT INTO people
VALUES(1, 'Gheorghe', 'Nistor', 'M', TO_DATE('23-04-2002', 'DD-MM-YYYY'), 'nistorgeorge404+member@gmail.com');

INSERT INTO people
VALUES (2, 'Maria', 'Ionescu', 'F', TO_DATE('14-02-2004', 'DD-MM-YYYY'), 'maria.ionescu@example.com');

INSERT INTO people
VALUES (3, 'Dumitru', 'Matei', 'M', TO_DATE('27-03-2010', 'DD-MM-YYYY'), 'dumitru.matei@example.com');

INSERT INTO people
VALUES (4, 'Mihai', 'Ionescu', 'M', TO_DATE('04-05-1995', 'DD-MM-YYYY'), 'mihai.ciocan@example.com');

INSERT INTO people
VALUES (5, 'Elena', 'Dumitru', 'F', TO_DATE('16-08-2002', 'DD-MM-YYYY'), 'elena.dumitru@example.com');

INSERT INTO people
VALUES (6, 'Ioan', 'Petrescu', 'M', TO_DATE('22-06-2000', 'DD-MM-YYYY'), 'nistorgeorge404+trainer@gmail.com');

INSERT INTO people
VALUES (7, 'Mihai', 'Petrescu', 'M', TO_DATE('13-07-1996', 'DD-MM-YYYY'), 'mihai.stoian@example.com');

INSERT INTO people
VALUES (8, 'Andreea', 'Istrate', 'F', TO_DATE('08-09-1991', 'DD-MM-YYYY'), 'andreea.istrate@example.com');

INSERT INTO people
VALUES (9, 'Radu', 'Mihailescu', 'M', TO_DATE('24-09-2010', 'DD-MM-YYYY'), 'radu.mihailescu@example.com');

INSERT INTO people
VALUES (10, 'Diana', 'Petrache', 'F', TO_DATE('29-10-2008', 'DD-MM-YYYY'), 'diana.petrache@example.com');

INSERT INTO members
VALUES(1, 1, 1, 57.5, 176);

INSERT INTO members
VALUES (2, 2, 0, 55.3, 165);

INSERT INTO members
VALUES (3, 3, 0, 92.3, 180);

INSERT INTO members
VALUES (4, 4, 0, 84.3, 182);

INSERT INTO members
VALUES (5, 5, 1, 61.2, 171);

INSERT INTO trainers
VALUES(1, 6, 1,  TO_DATE('01-08-2020', 'DD-MM-YYYY'), 3000);

INSERT INTO trainers
VALUES (2, 7, 0, TO_DATE('10-10-2020', 'DD-MM-YYYY'), 2500);

INSERT INTO trainers
VALUES (3, 8, 1, TO_DATE('23-04-2018', 'DD-MM-YYYY'), 4000);

INSERT INTO trainers
VALUES (4, 9, 0, TO_DATE('15-11-2022', 'DD-MM-YYYY'), 2250);

INSERT INTO trainers
VALUES (5, 10, 0, TO_DATE('05-01-2023', 'DD-MM-YYYY'), 2000);

INSERT INTO memberships
VALUES(1, 1, 3, 1, TO_DATE('03-01-2020', 'DD-MM-YYYY'), TO_DATE('03-02-2020', 'DD-MM-YYYY'));

INSERT INTO memberships
VALUES(2, 2, 1, 2, TO_DATE('03-01-2020', 'DD-MM-YYYY'), TO_DATE('03-02-2020', 'DD-MM-YYYY'));

INSERT INTO memberships
VALUES(3, 1, 3, 3, TO_DATE('03-01-2021', 'DD-MM-YYYY'), TO_DATE('03-02-2021', 'DD-MM-YYYY'));

INSERT INTO memberships
VALUES(4, 2, 1, 4, TO_DATE('03-01-2021', 'DD-MM-YYYY'), TO_DATE('03-02-2021', 'DD-MM-YYYY'));

INSERT INTO memberships
VALUES(5, 1, 3, 5, TO_DATE('03-01-2022', 'DD-MM-YYYY'), TO_DATE('03-02-2022', 'DD-MM-YYYY'));

INSERT INTO memberships
VALUES(6, 2, 1, 6, TO_DATE('03-01-2022', 'DD-MM-YYYY'), TO_DATE('03-02-2022', 'DD-MM-YYYY'));

INSERT INTO memberships
VALUES(7, 1, 3, 7, TO_DATE('03-01-2023', 'DD-MM-YYYY'), TO_DATE('03-02-2023', 'DD-MM-YYYY'));

INSERT INTO memberships
VALUES(8, 2, 1, 8, TO_DATE('03-01-2023', 'DD-MM-YYYY'), TO_DATE('03-02-2023', 'DD-MM-YYYY'));

INSERT INTO memberships
VALUES(9, 3, 2, 10, TO_DATE('03-01-2023', 'DD-MM-YYYY'), TO_DATE('03-02-2023', 'DD-MM-YYYY'));

INSERT INTO memberships
VALUES(10, 4, 5, 11, TO_DATE('15-01-2023', 'DD-MM-YYYY'), TO_DATE('15-01-2024', 'DD-MM-YYYY'));

INSERT INTO memberships
VALUES(11, 4, 1, 12, TO_DATE('20-01-2023', 'DD-MM-YYYY'), TO_DATE('20-02-2024', 'DD-MM-YYYY'));

INSERT INTO membership_types
VALUES (1, 'full-time', 0);

INSERT INTO membership_types
VALUES (2, 'day-time', 0);

INSERT INTO membership_types
VALUES (3, 'full-time', 1);

INSERT INTO membership_types
VALUES (4, 'day-time', 1);

INSERT INTO membership_types
VALUES (5, '12 months', 0);

INSERT INTO attendance_logs
VALUES (1, 1, TO_DATE('03-01-2020', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (2, 1, TO_DATE('3-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (3, 2, TO_DATE('3-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (4, 1, TO_DATE('4-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (5, 3, TO_DATE('4-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (6, 2, TO_DATE('4-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (7, 1, TO_DATE('10-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (8, 2, TO_DATE('10-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (9, 1, TO_DATE('11-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (10, 2, TO_DATE('11-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (11, 3, TO_DATE('11-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (12, 1, TO_DATE('15-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (13, 1, TO_DATE('20-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (14, 3, TO_DATE('22-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (15, 1, TO_DATE('25-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (16, 2, TO_DATE('25-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (17, 4, TO_DATE('25-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (18, 3, TO_DATE('26-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (19, 4, TO_DATE('27-01-2023', 'DD-MM-YYYY'));

INSERT INTO attendance_logs
VALUES (20, 4, TO_DATE('28-01-2023', 'DD-MM-YYYY'));

INSERT INTO payments
VALUES (1, TO_DATE('03-01-2020', 'DD-MM-YYYY'), 120, 'card');

INSERT INTO payments
VALUES (2, TO_DATE('03-01-2020', 'DD-MM-YYYY'), 150, 'cash');

INSERT INTO payments
VALUES (3, TO_DATE('03-01-2021', 'DD-MM-YYYY'), 120, 'card');

INSERT INTO payments
VALUES (4, TO_DATE('03-01-2021', 'DD-MM-YYYY'), 150, 'cash');

INSERT INTO payments
VALUES (5, TO_DATE('03-01-2022', 'DD-MM-YYYY'), 120, 'card');

INSERT INTO payments
VALUES (6, TO_DATE('03-01-2022', 'DD-MM-YYYY'), 150, 'card');

INSERT INTO payments
VALUES (7, TO_DATE('03-01-2023', 'DD-MM-YYYY'), 120, 'cash');

INSERT INTO payments
VALUES (8, TO_DATE('03-01-2023', 'DD-MM-YYYY'), 150, 'cash');

INSERT INTO payments
VALUES (9, TO_DATE('03-01-2023', 'DD-MM-YYYY'), 100, 'card');

INSERT INTO payments
VALUES (10, TO_DATE('03-01-2023', 'DD-MM-YYYY'), 115, 'cash');

INSERT INTO payments
VALUES (11, TO_DATE('15-01-2023', 'DD-MM-YYYY'), 1500, 'card');

INSERT INTO payments
VALUES (12, TO_DATE('20-01-2023', 'DD-MM-YYYY'), 150, 'card');

INSERT INTO training_sessionsS
VALUES (1, 1, 1, 9, TO_DATE('20-01-2023', 'DD-MM-YYYY'), 78);

INSERT INTO training_session_details
VALUES(1, 1, 14, 4); 

INSERT INTO training_session_details
VALUES(2, 1, 15, 4);

INSERT INTO training_session_details
VALUES(3, 1, 16, 1); 

INSERT INTO training_session_details
VALUES(4, 1, 17, 6);

INSERT INTO training_session_details
VALUES(5, 1, 1, null);

INSERT INTO equipments
VALUES (1, 'dumbbell');

INSERT INTO equipments
VALUES (2, 'barbell');

INSERT INTO equipments
VALUES (3, 'shoulder press machine');

INSERT INTO equipments
VALUES (4, 'squat rack');

INSERT INTO equipments
VALUES (5, 'biceps curl machine');

INSERT INTO equipments
VALUES (6, 'cable crossover machine');

INSERT INTO exercises
VALUES (1, 1, 'bench press');

INSERT INTO exercises
VALUES (2, 1, 'incline bench press');

INSERT INTO exercises
VALUES (3, 1, 'standing cable fly');

INSERT INTO exercises
VALUES (4, 2, 'shoulder press');

INSERT INTO exercises
VALUES (5, 2, 'lateral raises');

INSERT INTO exercises
VALUES (6, 2, 'face pulls');

INSERT INTO exercises
VALUES (7, 3, 'triceps pushdown');

INSERT INTO exercises
VALUES (8, 3, 'overhead triceps extension');

INSERT INTO exercises
VALUES (9, 4, 'deadlifts');

INSERT INTO exercises
VALUES (10, 4, 'bent over row');

INSERT INTO exercises
VALUES (11, 4, 'standing lat pulldown');

INSERT INTO exercises
VALUES (12, 5, 'biceps curl');

INSERT INTO exercises
VALUES (13, 5, 'hammer curl');

INSERT INTO exercises
VALUES (14, 6, 'squats');

INSERT INTO exercises
VALUES (15, 6, 'bulgarian split squat');

INSERT INTO exercises
VALUES (16, 7, 'cable crunches');

INSERT INTO exercises
VALUES (17, 7, 'leg raises');

INSERT INTO sets_reps_weights
VALUES(1, 1, 1, 10, 100);

INSERT INTO sets_reps_weights
VALUES(2, 1, 2, 8, 110);

INSERT INTO sets_reps_weights
VALUES(3, 1, 3, 6, 115);

INSERT INTO sets_reps_weights
VALUES(4, 1, 4, 5, 120);

INSERT INTO sets_reps_weights
VALUES(5, 2, 4, 5, 100);

INSERT INTO muscle_groups
VALUES (1, 'chest');

INSERT INTO muscle_groups
VALUES (2, 'shoulders');

INSERT INTO muscle_groups
VALUES (3, 'triceps');

INSERT INTO muscle_groups
VALUES (4, 'back');

INSERT INTO muscle_groups
VALUES (5, 'biceps');

INSERT INTO muscle_groups
VALUES (6, 'legs');

INSERT INTO muscle_groups
VALUES (7, 'abs');