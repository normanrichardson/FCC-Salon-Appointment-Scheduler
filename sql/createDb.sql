--create databases
CREATE DATABASE salon;

--create tables in worldcup
\connect salon;
\i createTables.sql
\i populate.sql
