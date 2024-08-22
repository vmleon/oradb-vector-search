-- Traces

SELECT
    USERNAME,
    SID,
    SERIAL#
FROM
    V$SESSION
WHERE
    USERNAME = 'HOTEL';

execute dbms_system.set_sql_trace_in_session(<SID>, <SERIAL#>, true);

SHOW PARAMETERS user_dump_dest;

-- AWR Report
@?/rdbms/admin/awrrpt; -- @?/rdbms/admin/awrrpti; for RAC