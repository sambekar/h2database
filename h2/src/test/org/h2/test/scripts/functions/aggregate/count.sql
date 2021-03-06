-- Copyright 2004-2018 H2 Group. Multiple-Licensed under the MPL 2.0,
-- and the EPL 1.0 (http://h2database.com/html/license.html).
-- Initial Developer: H2 Group
--

-- with filter condition

create table test(v int);
> ok

insert into test values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), (null);
> update count: 13

select count(v), count(v) filter (where v >= 4) from test where v <= 10;
> COUNT(V) COUNT(V) FILTER (WHERE (V >= 4))
> -------- --------------------------------
> 10       7
> rows: 1

select count(*), count(*) filter (where v >= 4) from test;
> COUNT(*) COUNT(*) FILTER (WHERE (V >= 4))
> -------- --------------------------------
> 13       9
> rows: 1


select count(*), count(*) filter (where v >= 4) from test where v <= 10;
> COUNT(*) COUNT(*) FILTER (WHERE (V >= 4))
> -------- --------------------------------
> 10       7
> rows: 1

create index test_idx on test(v);
> ok

select count(v), count(v) filter (where v >= 4) from test where v <= 10;
> COUNT(V) COUNT(V) FILTER (WHERE (V >= 4))
> -------- --------------------------------
> 10       7
> rows: 1

select count(v), count(v) filter (where v >= 4) from test;
> COUNT(V) COUNT(V) FILTER (WHERE (V >= 4))
> -------- --------------------------------
> 12       9
> rows: 1

drop table test;
> ok

CREATE TABLE TEST (ID INT PRIMARY KEY, NAME VARCHAR);
> ok

INSERT INTO TEST VALUES (1, 'b'), (3, 'a');
> update count: 2

SELECT COUNT(ID) OVER (ORDER BY NAME) AS NR,
    A.ID AS ID FROM (SELECT ID, NAME FROM TEST ORDER BY NAME) AS A;
> NR ID
> -- --
> 1  3
> 2  1
> rows (ordered): 2

SELECT NR FROM (SELECT COUNT(ID) OVER (ORDER BY NAME) AS NR,
    A.ID AS ID FROM (SELECT ID, NAME FROM TEST ORDER BY NAME) AS A)
    AS B WHERE B.ID = 1;
>> 2

DROP TABLE TEST;
> ok
