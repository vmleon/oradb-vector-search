set verify off

-- target sample role
define USERROLE='CLOUD_USER'

-- target sample user
define USERNAME='HOTEL'

CREATE ROLE &USERROLE;

GRANT CLOUD_USER TO &USERNAME;

REM the following are minimal privileges to use DBMS_CLOUD
REM - this script assumes core privileges
REM - CREATE SESSION
REM - Tablespace quote on the default tablespace for a user

REM for creation of external tables, e.g. DBMS_CLOUD.CREATE_EXTERNAL_TABLE()
GRANT CREATE TABLE TO &USERROLE;

REM for using COPY_DATA()
REM - Any log and bad file information is written into this directory
GRANT READ, WRITE ON DIRECTORY DATA_PUMP_DIR TO &USERROLE;

REM
GRANT EXECUTE ON DBMS_CLOUD TO &USERROLE;

EXIT;