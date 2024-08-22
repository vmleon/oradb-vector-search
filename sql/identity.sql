-- List Privileges for a user role
SELECT
    PRIVILEGE,
    GRANTEE
FROM
    DBA_SYS_PRIVS
WHERE
    GRANTEE='SAMPLE'
ORDER BY
    1;

SELECT
    OWNER,
    OBJECT_NAME
FROM
    DBA_OBJECTS
WHERE
    OBJECT_NAME = 'DBMS_CLOUD';

show user;

-- list all users
SELECT
    USERNAME
FROM
    ALL_USERS
ORDER BY
    1;

-- list dba users
SELECT
    USERNAME,
    ACCOUNT_STATUS
FROM
    DBA_USERS
ORDER BY
    1;

-- list user users
SELECT
    USERNAME
FROM
    USER_USERS
ORDER BY
    1;

SELECT
    *
FROM
    USER_SYS_PRIVS;

SELECT
    *
FROM
    USER_SYS_PRIVS
WHERE
    PRIVILEGE LIKE '%CLOUD%';

SELECT
    *
FROM
    USER_TAB_PRIVS;

SELECT
    *
FROM
    USER_ROLE_PRIVS;