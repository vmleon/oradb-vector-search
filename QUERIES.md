# Queries

[Oracle AI Vector Search User's Guide](https://docs.oracle.com/en/database/oracle/oracle-database/23/vecse/index.html)

## Vector DDL, DML, and Queries

```
sqlplus vector/vector@orclpdb1
```

```sql
DROP TABLE IF EXISTS t1;

CREATE TABLE IF NOT EXISTS t1 (v  vector);

DESC t1
```

```sql
INSERT INTO t1 VALUES ('[1.1, 2.7, 3.141592653589793238]'),
                      ('[9.34, 0.0, -6.923]'),
                      ('[-2.01, 5, -25.8]'),
                      ('[-8.2, -5, -1013.6]'),
                      ('[7.3]'),
                      ('[2.9]'),
                      ('[1, 2, 3, 4, 5]') ;
```

```sql
SELECT * FROM t1;
```

```sql
UPDATE t1 SET v = '[1.9, -5.02, 4]';

SELECT * FROM t1;
```

DML operations on Vectors

```sql
CREATE TABLE IF NOT EXISTS t2
   ( id           NUMBER NOT NULL,
     name         VARCHAR2(32),
     v1           VECTOR,
                  PRIMARY KEY (id)
   );

DESC t2;
```

```sql
INSERT INTO t2 VALUES (1, 'A', '[1.1]'),
                      (2, 'B', '[2.2]'),
                      (3, 'C', '[3.3]'),
                      (4, 'D', '[4.4]'),
                      (5, 'E', '[5.5]');

SELECT * FROM t2;
```

```sql
UPDATE t2
SET   v1 = '[2.9]'
WHERE id = 2;

SELECT * FROM t2
WHERE id = 2;
```

```sql
DELETE FROM  t2
WHERE  id IN (1, 3);

SELECT * FROM t2;
```

Tables with multiple vectors

```sql
CREATE TABLE IF NOT EXISTS t3
       ( id           NUMBER NOT NULL,
         name         VARCHAR2(32),
         v1           VECTOR,
         v2           VECTOR,
         v3           VECTOR,
                      PRIMARY KEY (id)
       );

DESC t3;
```

```sql
INSERT INTO t3 VALUES
       (1,
        'One',
        '[2.3, 4.5, 0.1]',
        '[1.3]',
        '[4.981, -6.3]'
       );

SELECT * FROM t3;
```

Operations on Vector with fixed dimensions

```sql
CREATE TABLE IF NOT EXISTS t4
                    ( v   VECTOR(3, FLOAT32) );

      DESC t4;
```

```sql
INSERT INTO t4 VALUES ('[1.1, 2.2, 3.3]');
INSERT INTO t4 VALUES ('[1.2, 2.3, 3.4]');
INSERT INTO t4 VALUES ('[1.2, 2.3, 3.4]');
INSERT INTO t4 VALUES ('[1.3]'); -- will fail
INSERT INTO t4 VALUES ('[1.3, 2.4, 3.5, 4.1]'); -- will fail
INSERT INTO t4 VALUES ('[1.4, 2.5, a]'); -- will fail
```

Create tables with different Vector formats

```sql
CREATE TABLE IF NOT EXISTS t5
         ( v1        VECTOR(3, float32),
           v2        VECTOR(2, float64),
           v3        VECTOR(1, int8),
           v4        VECTOR(1, *),
           v5        VECTOR(*, float32),
           v6        VECTOR(*, *),
           v7        VECTOR
         );

DESC t5;
```

```sql
INSERT INTO t5 VALUES ('[1.1, 2.2, 3.3]',
                       '[1.1, 2.2]',
                       '[7]',
                       '[9]',
                       '[1.1, 2.2, 3.3, 4.4, 5.5]',
                       '[1.1, 2.2]',
                       '[1.1, 2.2, 3.3, 4.4, 5.5, 6.6]'
                      );

SELECT * FROM t5;
```

DDL operations on Vectors

```sql
CREATE TABLE IF NOT EXISTS t6
          (
           id          NUMBER NOT NULL,
           name        VARCHAR2(32),
                       PRIMARY KEY (id)
          );

ALTER TABLE t6 ADD v1 VECTOR;
ALTER TABLE t6 ADD v2 VECTOR(2, float32);

DESC t6;
```

```sql
ALTER TABLE t6 DROP COLUMN v2;

DESC t6;

DROP TABLE IF EXISTS t6;
```

Create Table As Select (CTAS)

```sql
CREATE TABLE IF NOT EXISTS t7
    AS SELECT * FROM t3;

DESC t7;

SELECT * FROM t7;
```

Oracle error message

```sql
SELECT id, name FROM t2
WHERE  v1 IN (SELECT v FROM t1 WHERE t2.v1 = t1.v );

SELECT id, name FROM t2 WHERE v1 = '[2.9]';

SELECT id, name FROM t2 WHERE v1 = vector('[2.9, 0]', 2, float32);
```

## Vector Distance

```sql
SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100
```

```sql
SELECT VECTOR('[0,0]');
SELECT VECTOR('[10,0]');
SELECT VECTOR('[0,5]', 2, float32);
SELECT VECTOR('[4,3]');
SELECT VECTOR('[5,-2]');
SELECT VECTOR('[-3,-4]');
SELECT VECTOR('[3.14,2.718]');
SELECT VECTOR('[-5.3,4.2]');
SELECT VECTOR('[-7,-9]');
```

```sql
SELECT VECTOR_DISTANCE(
      VECTOR('[0, 0]'),
      VECTOR('[10, 0]'),
      EUCLIDEAN) DISTANCE;
```

> Result 10

```sql
SELECT TO_NUMBER(VECTOR_DISTANCE(
    VECTOR('[0, 0]', 2, FLOAT32),
    VECTOR('[0, 5]',2, FLOAT32),
    EUCLIDEAN)) DISTANCE;
```

> Result 5

```sql
SELECT TO_NUMBER(VECTOR_DISTANCE(
      VECTOR('[0, 0]', 2, FLOAT32),
      VECTOR('[4, 3]', 2, FLOAT32),
      EUCLIDEAN)) DISTANCE;
```

> Result 5

```sql
SELECT TO_NUMBER(VECTOR_DISTANCE(
      VECTOR('[0, 0]'),
      VECTOR('[3, 4]'),
      EUCLIDEAN)) DISTANCE;
```

> Result 5

```sql
SELECT TO_NUMBER(VECTOR_DISTANCE(
      VECTOR('[5, -2]', 2, FLOAT32),
      VECTOR('[-3, -4]',2, FLOAT32),
      EUCLIDEAN)) DISTANCE;
```

> Result 8.246211051940918

```sql
SELECT TO_NUMBER(VECTOR_DISTANCE(
      VECTOR('[3.14, 2.718]'),
      VECTOR('[-5.3, 4.2]'),
      EUCLIDEAN)) DISTANCE;
```

> Result 8.569127082824707

## Similarity Search

```sql
CREATE TABLE IF NOT EXISTS vt1
         (id   NUMBER NOT NULL,
          v    VECTOR(2, FLOAT32),
               PRIMARY KEY (id)
         );

DESC vt1;
```

```sql
INSERT INTO vt1 VALUES (1, '[3, 3]'),  (2, '[5, 3]'),  (3, '[7, 3]'),
                       (4, '[3, 5]'),  (5, '[5, 5]'),  (6, '[7, 5]'),
                       (7, '[3, 7]'),  (8, '[5, 7]'),  (9, '[7, 7]');

COMMIT;

SELECT * FROM vt1
ORDER BY id;
```

```sql
SELECT id
FROM   vt1
ORDER  BY  vector_distance(
                vector('[5, 0]'), v)
FETCH FIRST 3 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY  vector_distance(vector('[3, 0]'), v)
FETCH FIRST 3 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY  vector_distance(vector('[7, 0]'), v)
FETCH FIRST 3 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY  vector_distance(vector('[10, 7]'), v)
FETCH FIRST 3 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY  vector_distance(vector('[3, 9]'), v)
FETCH FIRST 3 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY  vector_distance(vector('[0, 0]'),  v)
FETCH FIRST 3 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY  vector_distance(vector('[5, 5]'), v)
FETCH FIRST 5 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY vector_distance(vector('[3.1, 6.9]'), v)
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY vector_distance(vector('[20, 1]'), v)
FETCH FIRST 10 ROWS ONLY;
```

```sql
INSERT INTO vt1 VALUES (21, '[9, -1]'),
                       (22, '[10, -1]'),
                       (23, '[11, -1]'),
                       (24, '[9, -3]'),
                       (25, '[10, -4]'),
                       (26, '[12, -3]') ;

INSERT INTO vt1 VALUES (31, '[13, 6]'),
                       (32, '[14, 7]'),
                       (33, '[14, 4]'),
                       (34, '[16, 6]') ;

INSERT INTO vt1 VALUES (41, '[0, 7]'),
                       (42, '[1, 7]'),
                       (43, '[1, 6]'),
                       (44, '[0, 5]'),
                       (45, '[1, 5]') ;

INSERT INTO vt1 VALUES (51, '[5, 9]'),
                       (52, '[7, 9]'),
                       (53, '[6, 10]'),
                       (54, '[5, 11]'),
                       (55, '[7, 11]') ;

COMMIT ;

SELECT * FROM vt1;
```

```sql
SELECT id
FROM   vt1
ORDER  BY vector_distance(vector('[16, 4]'), v)
FETCH FIRST 3 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY vector_distance(vector('[7, -5]'), v)
FETCH FIRST 5 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY vector_distance(vector('[6, 10]'), v)
FETCH FIRST 5 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY vector_distance(vector('[-1, 6]'), v)
FETCH FIRST 5 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY vector_distance(vector('[6, 8]'), v)
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id
FROM   vt1
ORDER  BY vector_distance(vector('[2.5, 8.5]'), v)
FETCH FIRST 4 ROWS ONLY;
```

## Attribute Filtering

```sql
DROP TABLE IF EXISTS vt2 ;

CREATE TABLE vt2 AS SELECT * FROM vt1;

ALTER TABLE vt2 ADD (vsize varchar2(16),
                     shape varchar2(16),
                     color varchar2(16)
                    );

 DESC vt2;
```

```sql
UPDATE vt2
SET    vsize = 'Small'
WHERE  id IN (1, 4, 6, 8, 9, 21, 23, 26, 33, 44, 45, 52);

UPDATE vt2
SET    vsize = 'Medium'
WHERE  id IN (5, 22, 25, 32, 34, 42, 43, 53, 54, 55);

UPDATE vt2
SET    vsize = 'Large'
WHERE  id IN (2, 3, 7, 24, 31, 41, 51);
```

```sql
UPDATE vt2
SET    shape = 'Square'
WHERE  id IN (1, 3, 6, 42, 43, 54);

UPDATE vt2
SET    shape = 'Triangle'
WHERE  id IN (2, 4, 7, 22, 31, 41, 44, 55);

UPDATE vt2
SET    shape = 'Oval'
WHERE  id IN (5, 8, 9, 21, 23, 24, 25, 26, 32, 33, 34, 45, 51, 52, 53);
```

```sql
UPDATE vt2
SET    color = 'Red'
WHERE  id IN (5, 8, 24, 26, 33, 34, 42, 44, 45, 53, 54, 55);

UPDATE vt2
SET    color = 'Green'
WHERE  id IN (1, 4, 6, 21, 31, 52);

UPDATE vt2
SET    color = 'Blue'
WHERE id IN (2, 3, 7, 9, 22, 23, 25, 32, 41, 43, 51);

COMMIT;
```

```sql
SELECT id, vsize, shape, color, v
FROM   vt2
ORDER  BY id;
```

```sql
SELECT vsize, count(vsize)
FROM   vt2
GROUP  BY vsize;

SELECT color, COUNT(color)
FROM   vt2
GROUP  BY color;

SELECT shape, COUNT(shape)
FROM   vt2
GROUP  BY shape;
```

```sql
SELECT id, vsize, shape, color,
       to_number(vector_distance(vector('[16, 3]'), v)) distance
FROM   vt2
WHERE  id > 30 AND id < 40
ORDER  BY vector_distance(vector('[16, 3]'), v)
FETCH FIRST 3 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color,
       to_number(vector_distance(vector('[16, 3]'), v)) distance
FROM   vt2
WHERE  id > 30 AND id < 40
AND    shape = 'Oval'
ORDER  BY vector_distance(vector('[16, 3]'), v)
FETCH FIRST 3 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt2
ORDER  BY vector_distance(vector('[6, 8]'), v)
FETCH FIRST 10 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt2
WHERE  color = 'Red'
ORDER  BY vector_distance(vector('[6, 8]'), v)
FETCH FIRST 10 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt2
WHERE  color = 'Red'
AND    shape = 'Oval'
ORDER  BY vector_distance(vector('[6, 8]'), v)
FETCH FIRST 10 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt2
WHERE  color = 'Red'
AND    shape = 'Oval'
AND    vsize  = 'Small'
ORDER  BY vector_distance(vector('[6, 8]'), v)
FETCH FIRST 10 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt2
WHERE  color = 'Red'
AND    shape = 'Oval'
AND    vsize  = 'Small'
AND    id    > 10
ORDER  BY vector_distance(vector('[6, 8]'), v)
FETCH FIRST 10 ROWS ONLY;
```

## Other Distance Functions

```sql
DROP TABLE IF EXISTS vt3 ;

CREATE TABLE vt3 AS SELECT * FROM vt2;

SELECT * FROM vt3 ORDER BY 1;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY vector_distance( vector('[16, 4]'), v, COSINE)
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY vector_distance( vector('[16, 4]'), v, EUCLIDEAN)
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY vector_distance(vector('[16, 4]'), v, DOT)
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY vector_distance(vector('[16, 4]'), v, MANHATTAN)
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY vector_distance( vector('[16, 4]'), v, HAMMING)
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY L1_DISTANCE(vector('[16, 4]'), v)
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY L2_DISTANCE(vector('[16, 4]'), v)
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY COSINE_DISTANCE( vector('[16, 4]'), v)
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY INNER_PRODUCT(vector('[16, 4]'), v)
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY vector('[16, 4]') <-> v
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY vector('[16, 4]') <=> v
FETCH FIRST 4 ROWS ONLY;
```

```sql
SELECT id, vsize, shape, color
FROM   vt3
ORDER  BY vector('[16, 4]') <#> v
FETCH FIRST 4 ROWS ONLY;
```

## Other Vector Functions

```sql
SELECT to_vector('[34.6, 77.8]', 2, float32) FROM dual;

SELECT to_vector('[34.6, 77.8, -89.34]', 3, float32);
```

```sql
SELECT vector_norm(vector('[4, 3]', 2, float32) );

SELECT vector_norm(vector('[4, 3]', 2, float64) );

SELECT vector_norm(vector('[4, 3]', 2, int8) );
```

```sql
SELECT vector_dimension_count(vector('[34.6, 77.8]', 2, float64));

SELECT vector_dimension_count(vector('[34.6, 77.8, 9]', 3, float32));

SELECT vector_dimension_count(vector('[34.6, 77.8, 9, 10]', 3, int8));
```

```sql
SELECT vector_dimension_format(vector('[34.6, 77.8]', 2, float64));

SELECT vector_dimension_format(vector('[34.6, 77.8, 9]', 3, float32));

SELECT vector_dimension_format(vector('[34.6, 77.8, 9, 10]', 3, int8));
```

```sql
SELECT vector_serialize(vector('[1.1, 2.2, 3.3]', 3, float32));

SELECT vector_serialize(vector('[1.1, 2.2, 3.3]', 3, float32)
       returning varchar2(1000));

SELECT vector_serialize(vector('[1.1, 2.2, 3.3]', 3, float32)
       returning clob);
```

```sql
SELECT from_vector(vector('[1.1, 2.2, 3.3]', 3, float32));

SELECT from_vector(vector('[1.1, 2.2, 3.3]', 3, float32) returning varchar2(1000));

SELECT from_vector(vector('[1.1, 2.2, 3.3]', 3, float32) returning clob);
```
