### Task 1: Develop an Entity-Relationship Diagram (ERD)

For the healthcare scheduling system, the key entities and their relationships are as follows:

1. **Entities:**
   - Clinic
   - Doctor
   - Patient
   - Assignment
   - Appointment
   - Waiting List
   - Request

2. **Relationships:**
   - A Clinic can have multiple Doctors.
   - A Doctor can be assigned to multiple Clinics.
   - A Patient can request multiple Appointments.
   - An Appointment involves one Patient, one Doctor, and one Clinic.
   - A Waiting List entry involves one Patient, one Doctor, and one Clinic.
   - A Request entry involves one Patient, one Doctor, and one Clinic.

3. **Attributes:**
   - Clinic: `C_ID`, `OPEN_HOURS`, `CLOSE_HOURS`, `C_SPECIALITY`
   - Doctor: `D_ID`, `D_NAME`, `D_SPECIALITY`, `DAYS`
   - Patient: `P_ID`, `P_NAME`
   - Assignment: `ASS_S_TIME`, `ASS_E_TIME`, `ASS_CID`, `ASS_DID`
   - Appointment: `AP_S_TIME`, `AP_E_TIME`, `AP_PID`, `AP_DID`, `AP_CID`, `AP_SPEC`
   - Waiting List: `WL_S_TIME`, `WL_E_TIME`, `WL_PID`, `WL_DID`, `WL_CID`, `WL_SPEC`
   - Request: `RQ_S_TIME`, `RQ_E__TIME`, `RQ_PID`, `RQ_DID`, `RQ_CID`, `RQ_SPEC`

4. **ERD Diagram Components:**
   - Primary Keys (PK) and Foreign Keys (FK)
   - Cardinality (one-to-many, many-to-many)

### Task 2: Map the ERD to the Relational Data Model

**Relational Schema:**

1. **Clinic**: 
   - `C_ID (PK)`
   - `OPEN_HOURS`
   - `CLOSE_HOURS`
   - `C_SPECIALITY`

2. **Doctor**: 
   - `D_ID (PK)`
   - `D_NAME`
   - `D_SPECIALITY`
   - `DAYS`

3. **Patient**: 
   - `P_ID (PK)`
   - `P_NAME`

4. **Assignment**:
   - `ASS_S_TIME`
   - `ASS_E_TIME`
   - `ASS_CID (FK)`
   - `ASS_DID (FK)`
   - `PK (ASS_CID, ASS_DID)`

5. **Appointment**:
   - `AP_S_TIME`
   - `AP_E_TIME`
   - `AP_PID (FK)`
   - `AP_DID (FK)`
   - `AP_CID (FK)`
   - `AP_SPEC`
   - `PK (AP_PID, AP_DID, AP_CID)`

6. **Request**:
   - `RQ_S_TIME`
   - `RQ_E__TIME`
   - `RQ_PID (FK)`
   - `RQ_DID (FK)`
   - `RQ_CID (FK)`
   - `RQ_SPEC`
   - `PK (RQ_PID, RQ_DID, RQ_CID)`

7. **Waiting List**:
   - `WL_S_TIME`
   - `WL_E_TIME`
   - `WL_PID (FK)`
   - `WL_DID (FK)`
   - `WL_CID (FK)`
   - `WL_SPEC`
   - `PK (WL_PID, WL_DID, WL_CID)`

### Task 3: Identify Different Queries

**Queries for Reporting:**

1. **Clinic-specific appointments** (daily, weekly, monthly).
2. **Specialty-specific appointments across clinics** (daily, weekly, monthly).
3. **Appointments with specific doctors** (daily, weekly, monthly).
4. **Appointments or assignments within a specific time range in a clinic**.
5. **Overlapping assignments for doctors of the same specialty** (daily, weekly, monthly).
6. **Doctors with the least number of appointments in a clinic** (daily, weekly, monthly).
7. **Doctors with the maximum number of appointments related to a specialty** (daily, weekly, monthly).
8. **Patients with recurrent appointments with the same doctor**.
9. **Patients with recurrent appointments with different doctors**.
10. **User management queries** (administrators, doctors, patients, front desk staff).

### Task 4: Relational Algebra Queries

1. **List patients with appointments at a certain clinic**:
   - `σAP_CID = 1 (APPOINTMENT ⨝ PATIENT)`

2. **Patients with appointments related to a specific specialty**:
   - `σAP_SPEC = 'Cardiologist' (APPOINTMENT ⨝ PATIENT)`

3. **All patient appointments with a certain set of doctors**:
   - `APPOINTMENT ⨝ PATIENT`

4. **Assignments within a specific time range**:
   - `σASS_S_TIME = '13:00:00' ∧ ASS_E_TIME = '14:00:00' (ASSIGNMENT)`

5. **Doctors of the same specialty with overlapping assignments**:
   - `πD_NAME, D_SPECIALITY, ASS_S_TIME, ASS_E_TIME (σD_SPECIALITY = D_SPECIALITY ∧ DAYS = DAYS ∧ ASS_S_TIME = ASS_S_TIME ∧ ASS_E_TIME = ASS_E_TIME (DOCTOR ⨝ ASSIGNMENT))`

### Task 5: SQL Queries for Full System Functionality

Write SQL queries to:

1. **Create tables and constraints**.
2. **Insert data**.
3. **Fetch data** to demonstrate system functionality.

### Conclusion

This project covers the design and implementation of a healthcare scheduling system using SQL, ER diagrams, and relational algebra. 
