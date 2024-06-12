create database healthcare
use healthcare

CREATE TABLE CLINIC (
	C_ID INT IDENTITY(1,1),
	OPEN_HOURS TIME,
	CLOSE_HOURS TIME,
	C_SPECIALITY VARCHAR (30),

	PRIMARY KEY (C_ID) 
);

CREATE TABLE DOCTOR (
	D_ID INT IDENTITY(1,1),
	D_NAME VARCHAR (30),
	D_SPECIALITY VARCHAR (30),
	DAYS VARCHAR (30),

	PRIMARY KEY (D_ID)
);

CREATE TABLE ASSIGNMENT (
	ASS_S_TIME Time,
	ASS_E_TIME Time,

	ASS_CID INT FOREIGN KEY REFERENCES CLINIC(C_ID),
	ASS_DID INT FOREIGN KEY REFERENCES DOCTOR(D_ID),
	
	PRIMARY KEY (ASS_CID,ASS_DID),
);

CREATE TABLE PATIENT (
	P_ID INT IDENTITY(1,1),
	P_NAME VARCHAR (30),
	
	PRIMARY KEY (P_ID)
);

CREATE TABLE APPOINTMENT (
	AP_S_TIME TIME,
	AP_E_TIME TIME,
	AP_PID INT FOREIGN KEY REFERENCES PATIENT(P_ID),
	AP_DID INT FOREIGN KEY REFERENCES DOCTOR(D_ID),
	AP_CID INT FOREIGN KEY REFERENCES CLINIC(C_ID),
	AP_SPEC VARCHAR (30),
	
	PRIMARY KEY (AP_PID, AP_DID,AP_CID)
);

CREATE TABLE REQUEST (
	RQ_S_TIME TIME,
	RQ_E__TIME TIME,
	RQ_PID INT FOREIGN KEY REFERENCES PATIENT(P_ID),
	RQ_DID INT FOREIGN KEY REFERENCES DOCTOR(D_ID),
	RQ_CID INT FOREIGN KEY REFERENCES CLINIC(C_ID),
	RQ_SPEC VARCHAR (30)
	
	PRIMARY KEY (RQ_PID, RQ_DID,RQ_CID)
);

CREATE TABLE WAITING_LIST (
	WL_S_TIME TIME,
	WL_E_TIME TIME,
	WL_PID INT FOREIGN KEY REFERENCES PATIENT(P_ID),
	WL_DID INT FOREIGN KEY REFERENCES DOCTOR(D_ID),
	WL_CID INT FOREIGN KEY REFERENCES CLINIC(C_ID),
	WL_SPEC VARCHAR (30),
	
	PRIMARY KEY (WL_PID, WL_DID,WL_CID)
);

CREATE TRIGGER RQ_TO_WL_ASS
ON REQUEST
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ID INT
	DECLARE @S_TIME TIME
	DECLARE @E_TIME TIME
	DECLARE @SPEC VARCHAR (30)
	DECLARE @ASSS_TIME TIME
	DECLARE @ASSE_TIME TIME
	DECLARE @PID INT
	DECLARE @DID INT
	DECLARE @CID INT


	SELECT   @PID=INSERTED.RQ_PID , @DID=INSERTED.RQ_DID , @CID=INSERTED.RQ_CID , 
			@S_TIME=INSERTED.RQ_S_TIME , @E_TIME=INSERTED.RQ_E__TIME , @SPEC=INSERTED.RQ_SPEC
	FROM INSERTED
	   	
	SELECT @ASSS_TIME = ASS_S_TIME, @ASSE_TIME = ASS_E_TIME 
	FROM ASSIGNMENT  where ASS_DID = @DID

	IF @S_TIME<@ASSS_TIME OR  @E_TIME>@ASSE_TIME 
	BEGIN
		INSERT INTO WAITING_LIST VALUES(@S_TIME,@E_TIME,@PID,@DID,@CID,@SPEC);
		PRINT 'WAITING LIST';
	END
	ELSE 
	BEGIN
		INSERT INTO APPOINTMENT VALUES(@S_TIME,@E_TIME,@PID,@DID,@CID,@SPEC)
		PRINT 'APPOINTMENT';
	END
END

CREATE TRIGGER MOVE_TO_ASS 
ON ASSIGNMENT
	INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @C_OPEN TIME ;
	DECLARE @C_CLOSE TIME ;
	DECLARE @ASS_START TIME;
	DECLARE @ASS_END TIME;
	DECLARE @C_ID INT;
	DECLARE @D_ID INT;

	SELECT @C_ID= INSERTED.ASS_CID, @D_ID= INSERTED.ASS_DID, @ASS_START= INSERTED.ASS_S_TIME , @ASS_END= INSERTED.ASS_E_TIME
	FROM INSERTED;

	SELECT @C_OPEN = OPEN_HOURS FROM CLINIC where C_ID=@C_ID
	SELECT @C_CLOSE = CLOSE_HOURS FROM CLINIC where C_ID=@C_ID

	IF(@ASS_START < @C_OPEN OR @ASS_END > @C_CLOSE)
		PRINT 'CANT ASSIGN';
	ELSE 
		INSERT INTO ASSIGNMENT VALUES(@ASS_START,@ASS_END,@C_ID,@D_ID); 
END

/*----------------------------------------- INSERTION --------------------------------------------------------*/

INSERT INTO DOCTOR VALUES('Alina','Cardiologist','Monday');
INSERT INTO DOCTOR VALUES('Saba','Dermatology','Tuesday');
INSERT INTO DOCTOR VALUES('Abdullah','Anesthesiology','Wednesday');
INSERT INTO DOCTOR VALUES('Ayesha','Neurology','Thursday');
INSERT INTO DOCTOR VALUES('Salwa','Surgery','Friday');
INSERT INTO DOCTOR VALUES('Ramsha','Pediatrics','Saturday');
INSERT INTO DOCTOR VALUES('Asad','Urology','Sunday');
INSERT INTO DOCTOR VALUES('Taha','Cardiologist','Tuesday');
INSERT INTO DOCTOR VALUES('Sara','Dermatology','Tuesday');

INSERT INTO CLINIC VALUES('12:00:00','15:00:00','Cardiologist');
INSERT INTO CLINIC VALUES('15:00:00','18:00:00','Dermatology');
INSERT INTO CLINIC VALUES('18:00:00','21:00:00','Neurology');
INSERT INTO CLINIC VALUES('21:00:00','23:00:00','Anesthesiology');

INSERT INTO CLINIC VALUES('13:00:00','14:00:00','Surgery');
INSERT INTO CLINIC VALUES('13:00:00','14:00:00','Urology');
--ASSIGNED
INSERT INTO ASSIGNMENT VALUES('13:00:00', '14:00:00',1,2);
INSERT INTO ASSIGNMENT VALUES('19:00:00', '20:00:00',3,4);
INSERT INTO ASSIGNMENT VALUES('21:30:00', '22:30:00',4,3);
INSERT INTO ASSIGNMENT VALUES('16:00:00', '17:00:00',2,5);

INSERT INTO ASSIGNMENT VALUES('13:00:00', '14:00:00',1,8);
INSERT INTO ASSIGNMENT VALUES('13:00:00', '14:00:00',5,3);
INSERT INTO ASSIGNMENT VALUES('13:00:00', '14:00:00',6,5);
INSERT INTO ASSIGNMENT VALUES('21:30:00','22:00:00',4,8);
INSERT INTO ASSIGNMENT VALUES('13:00:00', '14:00:00',1,1);

--NOT ASSIGNED
INSERT INTO ASSIGNMENT VALUES('13:00:00', '14:00:00',2,2);
INSERT INTO ASSIGNMENT VALUES('16:00:00', '17:00:00',1,6);
INSERT INTO ASSIGNMENT VALUES('1:00:00', '2:00:00',2,1);
INSERT INTO ASSIGNMENT VALUES('2:00:00', '3:00:00',3,7);

INSERT INTO PATIENT VALUES('Saba');
INSERT INTO PATIENT VALUES('Ayesha');
INSERT INTO PATIENT VALUES('Ahmed');
INSERT INTO PATIENT VALUES('Umair');
INSERT INTO PATIENT VALUES('Karim');
INSERT INTO PATIENT VALUES('Amjad');

--REQUEST MOVED TO APPOINTMENT
INSERT INTO REQUEST VALUES('13:00:00', '14:00:00', 1, 2, 1, 'Cardiologist');
INSERT INTO REQUEST VALUES('16:00:00', '17:00:00',2,5,2, 'Dermatology');
INSERT INTO REQUEST VALUES('19:00:00', '20:00:00',3,4,3, 'Neurology');
INSERT INTO REQUEST VALUES('21:45:00', '22:15:00',4,3,4, 'Anesthesiology');
INSERT INTO REQUEST VALUES('13:00:00', '14:00:00', 5, 1, 2, 'Cardiologist');
INSERT INTO REQUEST VALUES('21:45:00', '22:15:00',5,7,1, 'Urology');
INSERT INTO REQUEST VALUES('13:00:00', '14:00:00', 5, 2, 1, 'Cardiologist');
INSERT INTO REQUEST VALUES('21:45:00', '22:15:00',1,2,4, 'Anesthesiology');

INSERT INTO REQUEST VALUES('13:30:00', '13:45:00',2,2,1, 'Neurology');
INSERT INTO REQUEST VALUES('13:45:00', '14:00:00',5,3,1, 'Anesthesiology');
INSERT INTO REQUEST VALUES('13:00:00', '14:00:00', 3, 2, 1, 'Pediatrics');
INSERT INTO REQUEST VALUES('13:00:00', '14:00:00', 1, 8, 1, 'Pediatrics');

--REQUEST MOVED TO WAITING LIST
INSERT INTO REQUEST VALUES('17:00:00', '18:00:00',2,4,3, 'Cosmetics');
INSERT INTO REQUEST VALUES('11:00:00', '12:00:00',1,2,2, 'Cardiologist');
INSERT INTO REQUEST VALUES('11:00:00', '12:00:00',2,4,2, 'Anesthesiology');
INSERT INTO REQUEST VALUES('01:00:00', '08:00:00',4,4,4, 'Pediatrics');

DROP TABLE DOCTOR
DROP TABLE CLINIC
DROP TABLE PATIENT
DROP TABLE ASSIGNMENT
DROP TABLE APPOINTMENT
DROP TABLE WAITING_LIST
DROP TABLE REQUEST

SELECT * FROM PATIENT 
SELECT * FROM doctor 
SELECT * FROM clinic
SELECT * FROM ASSIGNMENT
SELECT * FROM WAITING_LIST
SELECT * FROM APPOINTMENT
go

/*----------------------------------------- QUERIES --------------------------------------------------------*/

--QUERY 1
SELECT DISTINCT A.AP_CID,P_Name
FROM PATIENT P 
JOIN APPOINTMENT A ON P.P_ID = A.AP_PID
WHERE A.AP_CID = 1;

--Query 2
SELECT A.AP_SPEC , P.P_NAME FROM APPOINTMENT A INNER JOIN PATIENT P ON 
P.P_ID = A.AP_PID 
WHERE A.AP_SPEC = 'Cardiologist';

--Query 3
SELECT A.AP_PID AS 'Patient ID',P.P_NAME AS 'Patient Name', A.AP_DID AS 'Doctor ID' FROM APPOINTMENT A 
INNER JOIN PATIENT P ON 
P.P_ID = A.AP_PID ;

--QUERY 4
SELECT * FROM ASSIGNMENT
WHERE ASS_S_TIME ='13:00:00' 
AND ASS_E_TIME = '14:00:00';

--Query 5
SELECT D1.D_NAME AS 'Doctor Name', D1.D_SPECIALITY AS 'Speciality', A1.ASS_S_TIME AS 'Start Time', 
A1.ASS_E_TIME AS 'End Time', D1.DAYS, D2.D_NAME AS 'Doctor Name', D2.D_SPECIALITY AS 'Speciality',
A2.ASS_S_TIME AS 'Start Time', A2.ASS_E_TIME AS 'End Time', D2.DAYS FROM DOCTOR D1
JOIN DOCTOR D2 ON D1.D_SPECIALITY = D2.D_SPECIALITY			--speciality of both doctors should match 
JOIN ASSIGNMENT A1 ON A1.ASS_DID = D1.D_ID						--checking assignment of doctor 
JOIN ASSIGNMENT A2 ON A2.ASS_DID = D2.D_ID 
WHERE (D1.DAYS = D2.DAYS) AND (D1.D_ID != D2.D_ID) AND (A1.ASS_CID = A2.ASS_CID) AND 
(A1.ASS_S_TIME = A2.ASS_S_TIME) AND (A1.ASS_E_TIME = A2.ASS_E_TIME) ;

--QUERY 6
SELECT TOP 3 AP_DID,COUNT(AP_DID) AS 'No. Of Appointments'
FROM APPOINTMENT
GROUP BY AP_DID
ORDER BY COUNT(AP_DID) ASC


--QUERY 7
SELECT TOP 1 AP_DID,COUNT(AP_DID) AS 'No. Of Appointments', AP_SPEC
FROM APPOINTMENT
WHERE AP_SPEC ='Anesthesiology'
GROUP BY AP_DID,AP_SPEC
ORDER BY COUNT(AP_DID) DESC


--NO. OF REQUESTS IN WAITING LIST
SELECT COUNT(*) AS 'No. of Waiting Requests' 
FROM WAITING_LIST ;

--NO. OF REQUESTS APPROVED AND MOVED TO APPOINTMENT  
SELECT COUNT(*) AS 'No. of Appointments' 
FROM APPOINTMENT ;


--NO. OF ASSIGNMENTS TAKEN BY DR.ABDULLAH
SELECT D_NAME,COUNT(*) AS 'No. Of Assignments'FROM ASSIGNMENT A 
JOIN DOCTOR D ON A.ASS_DID = D.D_ID
WHERE D.D_NAME = 'Abdullah'
GROUP BY D_NAME

--TIME ON WHICH REQUESTS WERE MADE BY PATIENT AYESHA
 SELECT P.P_NAME, R.RQ_S_TIME, R.RQ_E__TIME, R.RQ_SPEC
 FROM PATIENT P JOIN REQUEST R
 ON P.P_ID=R.RQ_PID
 WHERE P.P_NAME='Ayesha'

 --DOCTOR THAT CAN SIT ON THE CLINICS ACC TO THEIR SPECIALITY
 SELECT D.D_ID, D.D_NAME,D.d_SPECIALITY, C.C_ID,C.C_SPECIALITY
 FROM DOCTOR D 
 JOIN CLINIC C ON D.D_SPECIALITY = C.C_SPECIALITY

 --DOCTORS WHO WORK ON CLINIC 1
 SELECT D.D_NAME, A.ASS_CID FROM DOCTOR D 
 JOIN ASSIGNMENT A ON D.D_ID = A.ASS_DID
 WHERE A.ASS_CID = 1

 -- APPOINTMENTS ON FRIDAY
 SELECT D.D_NAME AS DOCTOR ,P.P_NAME AS PATIENT, A.AP_S_TIME AS 'START TIME' ,A.AP_E_TIME AS 'END TIME',
 A.AP_SPEC AS SPECIALITY, D.DAYS AS DATE FROM APPOINTMENT A 
 JOIN DOCTOR D ON A.AP_DID=D.D_ID
 JOIN PATIENT P ON A.AP_PID=P.P_ID
 WHERE D.DAYS='Friday'

 --NAME OF PATIENTS IN WAITING LIST
 SELECT P.P_NAME AS 'Patients in Waiting List'FROM PATIENT P 
 JOIN WAITING_LIST WL ON P.P_ID=WL.WL_PID

 --PATIENTS WHO HAVE APPOINTMENTS ON TUESDAY
 SELECT P.P_NAME AS 'Patient Name', D.DAYS AS Day FROM APPOINTMENT A 
 JOIN DOCTOR D ON A.AP_DID=D.D_ID
 JOIN PATIENT P ON A.AP_PID=P.P_ID
 WHERE D.DAYS = 'Tuesday'

--SPECIALISATIONS AVAILABLE ON TUESDAY 
SELECT distinct C.C_SPECIALITY AS Speciality, D.DAYS AS Date FROM ASSIGNMENT A 
JOIN DOCTOR D ON A.ASS_DID=D.D_ID
JOIN CLINIC C ON A.ASS_CID=C_ID
WHERE D.DAYS = 'TuDesday'

--NAMES OF ALL DOCTORS ASSIGNED TO CLINIC 1
SELECT D.D_NAME AS 'Doctors Working in Clinic 1'FROM DOCTOR D 
JOIN ASSIGNMENT A ON D.D_ID=A.ASS_DID
JOIN CLINIC C ON A.ASS_CID=C.C_ID
WHERE C.C_ID = 1


--DOCTOR WITH CORRESPONDING NUMBER OF APPOINTMENTS 
SELECT D.D_ID, D.D_NAME, D.D_SPECIALITY, COUNT(A.AP_DID) AS 'NO OF APPOINTMENTS'FROM DOCTOR D 
JOIN APPOINTMENT A ON 
A.AP_DID = D.D_ID 
GROUP BY D.D_ID, D.D_NAME, D.D_SPECIALITY

--DOCTOR WITH MAX NUMBER OF APPOINTMENTS 
SELECT D.D_ID, D.D_NAME, D.D_SPECIALITY, COUNT(A.AP_DID) AS 'NO OF APPOINTMENTS'FROM DOCTOR D 
JOIN APPOINTMENT A ON 
A.AP_DID = D.D_ID 
GROUP BY D.D_ID, D.D_NAME, D.D_SPECIALITY 
HAVING COUNT(*) IN 
(SELECT MAX(A.FREQ) 
FROM (SELECT COUNT (*) AS FREQ FROM DOCTOR DD JOIN APPOINTMENT AA ON AA.AP_DID = DD.D_ID 
GROUP BY DD.D_ID, DD.D_NAME, DD.D_SPECIALITY)A);

--DOCTOR WITH MIN NUMBER OF APPOINTMENTS
SELECT D.D_ID, D.D_NAME, D.D_SPECIALITY, COUNT(A.AP_DID) AS 'NO OF APPOINTMENTS'FROM DOCTOR D 
JOIN APPOINTMENT A ON 
A.AP_DID = D.D_ID 
GROUP BY D.D_ID, D.D_NAME, D.D_SPECIALITY 
HAVING COUNT(*) IN 
(SELECT MIN(A.FREQ) 
FROM (SELECT COUNT (*) AS FREQ FROM DOCTOR DD JOIN APPOINTMENT AA ON AA.AP_DID = DD.D_ID 
GROUP BY DD.D_ID, DD.D_NAME, DD.D_SPECIALITY)A);

--PATIENTS WITH OVERALPPING APPOINTMENT AT SAME CLINIC 
SELECT P1.P_ID, P1.P_NAME AS 'Patient Name',A1.AP_CID AS 'Clinic ID', 
A1.AP_S_TIME AS 'Start Time', A1.AP_E_TIME AS 'End Time',P2.P_ID,P2.P_NAME AS 'Patient Name', 
A2.AP_CID AS 'Clinic ID',A2.AP_S_TIME AS 'Start Time', A2.AP_E_TIME AS 'End Time'FROM PATIENT P1
JOIN PATIENT P2 ON P1.P_ID <> P2.P_ID
JOIN APPOINTMENT A1 ON P1.P_ID = A1.AP_PID  	
JOIN APPOINTMENT A2 ON A2.AP_PID = P2.P_ID 
WHERE (A1.AP_CID = A2.AP_CID) AND 
(A1.AP_S_TIME = A2.AP_S_TIME) AND (A1.AP_E_TIME = A2.AP_E_TIME) ;