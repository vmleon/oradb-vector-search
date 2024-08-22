BEGIN
    DBMS_CLOUD.CREATE_CREDENTIAL (
        CREDENTIAL_NAME => 'obj_store_cred',
        USERNAME => 'me@example.com',
        PASSWORD => '{my-Auth-Token}'
    );
END;
/

column credential_name format a25

column username format a20

SELECT
    CREDENTIAL_NAME,
    USERNAME,
    ENABLED
FROM
    USER_CREDENTIALS
ORDER BY
    CREDENTIAL_NAME;

BEGIN
    DBMS_CREDENTIAL.DISABLE_CREDENTIAL('obj_store_cred');
    DBMS_CREDENTIAL.ENABLE_CREDENTIAL('obj_store_cred');
END;
/

BEGIN
    DBMS_CREDENTIAL.UPDATE_CREDENTIAL(
        CREDENTIAL_NAME => 'obj_store_cred',
        ATTRIBUTE => 'username',
        VALUE => 'me@example.com'
    );
    DBMS_CREDENTIAL.UPDATE_CREDENTIAL(
        CREDENTIAL_NAME => 'obj_store_cred',
        ATTRIBUTE => 'password',
        VALUE => '{my-Auth-Token}'
    );
END;
/

BEGIN
    DBMS_CLOUD.DROP_CREDENTIAL(
        CREDENTIAL_NAME => 'obj_store_cred'
    );
END;
/

BEGIN
    DBMS_CLOUD.PUT_OBJECT (
        CREDENTIAL_NAME => 'obj_store_cred',
        OBJECT_URI => 'https://swiftobjectstorage.uk-london-1.oraclecloud.com/v1/my-namespace/ob-bucket/test1.txt',
        DIRECTORY_NAME => 'tmp_files_dir',
        FILE_NAME => 'test1.txt'
    );
END;
/

DECLARE
    L_FILE BLOB;
BEGIN
    L_FILE := UTL_RAW.CAST_TO_RAW('This is another test file');
    DBMS_CLOUD.PUT_OBJECT (
        CREDENTIAL_NAME => 'obj_store_cred',
        OBJECT_URI => 'https://swiftobjectstorage.uk-london-1.oraclecloud.com/v1/my-namespace/ob-bucket/test2.txt',
        CONTENTS => L_FILE
    );
END;
/

set linesize 150

column object_name format a12

column checksum format a35

column created format a35

column last_modified format a35

SELECT
    *
FROM
    DBMS_CLOUD.LIST_OBJECTS(
        CREDENTIAL_NAME => 'obj_store_cred',
        LOCATION_URI => 'https://swiftobjectstorage.uk-london-1.oraclecloud.com/v1/my-namespace/ob-bucket'
    );

SELECT
    DBMS_CLOUD.GET_METADATA(
        CREDENTIAL_NAME => 'obj_store_cred',
        OBJECT_URI => 'https://swiftobjectstorage.uk-london-1.oraclecloud.com/v1/my-namespace/ob-bucket/test2.txt'
    ) AS METADATA
FROM
    DUAL;

BEGIN
    DBMS_CLOUD.GET_OBJECT (
        CREDENTIAL_NAME => 'obj_store_cred',
        OBJECT_URI => 'https://swiftobjectstorage.uk-london-1.oraclecloud.com/v1/my-namespace/ob-bucket/test2.txt',
        DIRECTORY_NAME => 'tmp_files_dir',
        FILE_NAME => 'test2.txt'
    );
END;
/

DECLARE
    L_FILE BLOB;
BEGIN
    L_FILE := DBMS_CLOUD.GET_OBJECT ( CREDENTIAL_NAME => 'obj_store_cred', OBJECT_URI => 'https://swiftobjectstorage.uk-london-1.oraclecloud.com/v1/my-namespace/ob-bucket/test2.txt');
END;
/

BEGIN
    DBMS_CLOUD.DELETE_OBJECT(
        CREDENTIAL_NAME => 'obj_store_cred',
        OBJECT_URI => 'https://swiftobjectstorage.uk-london-1.oraclecloud.com/v1/my-namespace/ob-bucket/test1.txt'
    );
    DBMS_CLOUD.DELETE_OBJECT(
        CREDENTIAL_NAME => 'obj_store_cred',
        OBJECT_URI => 'https://swiftobjectstorage.uk-london-1.oraclecloud.com/v1/my-namespace/ob-bucket/test2.txt'
    );
END;
/

BEGIN
    DBMS_CLOUD.DELETE_FILE(
        DIRECTORY_NAME => 'tmp_files_dir',
        FILE_NAME => 'test1.txt'
    );
    DBMS_CLOUD.DELETE_FILE(
        DIRECTORY_NAME => 'tmp_files_dir',
        FILE_NAME => 'test2.txt'
    );
END;
/

SELECT
    *
FROM
    DBMS_CLOUD.LIST_FILES(
        DIRECTORY_NAME => 'data_pump_dir'
    );