CREATE USER HOTEL IDENTIFIED BY "H0t3ls!_Password";

GRANT UNLIMITED TABLESPACE TO HOTEL;

ALTER SESSION SET CURRENT_SCHEMA = HOTEL;

GRANT CONNECT, RESOURCE TO HOTEL;