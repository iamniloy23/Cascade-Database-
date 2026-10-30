CREATE DATABASE niloy_2414032042;
GO

USE niloy_2414032042;
GO

CREATE TABLE department(
    dept_name VARCHAR(50) PRIMARY KEY,
    building VARCHAR(50) NOT NULL,
    budget DECIMAL(10,2) CHECK (budget > 0)
);
GO

CREATE TABLE classroom(
    building VARCHAR(50),
    room_number VARCHAR(20),
    capacity INT CHECK (capacity > 0),
    PRIMARY KEY(building, room_number)
);
GO

CREATE TABLE time_slot(
    time_slot_id VARCHAR(20),
    day VARCHAR(15),
    start_time TIME,
    end_time TIME,
    PRIMARY KEY(time_slot_id, day, start_time),
    CHECK (end_time > start_time)
);
GO

CREATE TABLE student(
    ID INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_name VARCHAR(50),
    tot_cred INT DEFAULT 0 CHECK (tot_cred >= 0),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);
GO

CREATE TABLE instructor(
    ID INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_name VARCHAR(50),
    salary DECIMAL(10,2) CHECK (salary > 0),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);
GO

CREATE TABLE course(
    course_id VARCHAR(20) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    dept_name VARCHAR(50),
    credits INT CHECK (credits BETWEEN 1 AND 5),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);
GO

CREATE TABLE section(
    course_id VARCHAR(20),
    sec_id VARCHAR(10),
    semester VARCHAR(20) 
        CHECK (semester IN ('Spring','Summer','Fall','Winter')),
    year INT CHECK (year >= 2000),
    building VARCHAR(50),
    room_number VARCHAR(20),
    time_slot_id VARCHAR(20),
    day VARCHAR(15),
    start_time TIME,
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (building, room_number) 
        REFERENCES classroom(building, room_number),
    FOREIGN KEY (time_slot_id, day, start_time)
        REFERENCES time_slot(time_slot_id, day, start_time)
);
GO

CREATE TABLE takes(
    ID INT,
    course_id VARCHAR(20),
    sec_id VARCHAR(10),
    semester VARCHAR(20),
    year INT,
    grade VARCHAR(2),
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    CHECK (grade IN ('A','A-','B+','B','B-','C+','C','D','F')),
    FOREIGN KEY (ID) REFERENCES student(ID),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)
);
GO

CREATE TABLE teaches(
    ID INT,
    course_id VARCHAR(20),
    sec_id VARCHAR(10),
    semester VARCHAR(20),
    year INT,
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    FOREIGN KEY (ID) REFERENCES instructor(ID),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)
);
GO

CREATE TABLE advisor(
    s_id INT PRIMARY KEY,
    i_id INT,
    UNIQUE(s_id),
    FOREIGN KEY(s_id) REFERENCES student(ID),
    FOREIGN KEY(i_id) REFERENCES instructor(ID)
);
GO

CREATE TABLE prereq(
    course_id VARCHAR(20),
    prereq_id VARCHAR(20),
    PRIMARY KEY(course_id, prereq_id),
    CHECK (course_id <> prereq_id),
    FOREIGN KEY(course_id) REFERENCES course(course_id),
    FOREIGN KEY(prereq_id) REFERENCES course(course_id)
);
GO

INSERT INTO department VALUES
('Biology','Watson',90000),
('Comp. Sci.','Taylor',100000),
('Elec. Eng.','Taylor',85000),
('Finance','Painter',120000),
('History','Painter',50000),
('Music','Packard',80000),
('Physics','Watson',70000);
GO

INSERT INTO classroom VALUES
('Packard','101',500),
('Painter','514',10),
('Taylor','3128',70),
('Watson','100',30),
('Watson','120',50);
GO

INSERT INTO course VALUES
('BIO-101','Intro. to Biology','Biology',4),
('BIO-301','Genetics','Biology',4),
('BIO-399','Computational Biology','Biology',3),
('CS-101','Intro. to Computer Science','Comp. Sci.',4),
('CS-190','Game Design','Comp. Sci.',4),
('CS-315','Robotics','Comp. Sci.',3),
('CS-319','Image Processing','Comp. Sci.',3),
('CS-347','Database System Concepts','Comp. Sci.',3),
('EE-181','Intro. to Digital Systems','Elec. Eng.',3),
('FIN-201','Investment Banking','Finance',3),
('HIS-351','World History','History',3),
('MU-199','Music Video Production','Music',3),
('PHY-101','Physical Principles','Physics',4);
GO

INSERT INTO instructor VALUES
(10101,'Srinivasan','Comp. Sci.',65000),
(12121,'Wu','Finance',90000),
(15151,'Mozart','Music',40000),
(22222,'Einstein','Physics',95000),
(32343,'El Said','History',60000),
(33456,'Gold','Physics',87000),
(45565,'Katz','Comp. Sci.',75000),
(58583,'Califieri','History',62000),
(76543,'Singh','Finance',80000),
(76766,'Crick','Biology',72000),
(83821,'Brandt','Comp. Sci.',92000),
(98345,'Kim','Elec. Eng.',80000);
GO

INSERT INTO student VALUES
(128,'Zhang','Comp. Sci.',102),
(12345,'Shankar','Comp. Sci.',32),
(19991,'Brandt','History',80),
(23121,'Chavez','Finance',110),
(44553,'Peltier','Physics',56),
(45678,'Levy','Physics',46),
(54321,'Williams','Comp. Sci.',54),
(55739,'Sanchez','Music',38),
(70557,'Snow','Physics',0),
(76543,'Brown','Comp. Sci.',58),
(76653,'Aoi','Elec. Eng.',60),
(98765,'Bourikas','Elec. Eng.',98),
(98988,'Tanaka','Biology',120);
GO

INSERT INTO time_slot VALUES
('A','Monday','08:00','09:30'),
('B','Monday','09:30','11:00'),
('C','Tuesday','11:00','12:30');
GO

INSERT INTO section VALUES
('CS-101','1','Fall',2023,'Packard','101','A','Monday','08:00'),
('CS-347','1','Fall',2023,'Taylor','3128','B','Monday','09:30'),
('PHY-101','1','Fall',2023,'Watson','100','C','Tuesday','11:00');
GO

INSERT INTO teaches VALUES
(10101,'CS-101','1','Fall',2023),
(45565,'CS-347','1','Fall',2023),
(22222,'PHY-101','1','Fall',2023);
GO

INSERT INTO takes VALUES
(12345,'CS-101','1','Fall',2023,'A'),
(128,'CS-101','1','Fall',2023,'B'),
(45678,'PHY-101','1','Fall',2023,'A'),
(54321,'CS-347','1','Fall',2023,'A');
GO

INSERT INTO advisor VALUES
(12345,10101),
(128,45565),
(45678,22222);
GO

INSERT INTO prereq VALUES
('BIO-301','BIO-101'),
('CS-347','CS-101'),
('CS-315','CS-101'),
('CS-319','CS-101');
GO