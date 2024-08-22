DECLARE
    TYPE R_PERSON IS RECORD (
        FNAME VARCHAR2(30),
        LNAME VARCHAR2(30),
        AGE NUMBER
    );
    V_PERSON R_PERSON;
BEGIN
    V_PERSON.FNAME := "Victor";
    V_PERSON.LNAME := "Martin";
    V_PERSON.AGE := 21; -- :)
END;

DECLARE
    TYPE T_ARRAY IS
        TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
    V_ARRAY T_ARRAY;
BEGIN
    V_ARRAY(1) := 'Hellow World!';
    V_ARRAY(2) := 'Hello Again!';
END;

CREATE OR REPLACE TYPE O_PERSON AS OBJECT ( FNAME VARCHAR2(30), LNAME VARCHAR2(30), AGE NUMBER );
DECLARE
    V_PERSON O_PERSON;
BEGIN
    V_PERSON := O_PERSON('Victor', 'Martin', 21);
END;

DECLARE
    V_PERSON O_PERSON := O_PERSON_COLL();
BEGIN
    V_PERSON.EXTEND;
    V_PERSON(1) := O_PERSON('Victor', 'Martin', 21);
END;