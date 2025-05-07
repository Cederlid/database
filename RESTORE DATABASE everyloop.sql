RESTORE DATABASE everyloop
FROM DISK = '/var/opt/mssql/backups/everloop.bak'
WITH MOVE 'everyloop' TO '/var/opt/mssql/data/everyloop.mdf',
     MOVE 'everyloop_log' TO '/var/opt/mssql/data/everyloop_log.ldf',
     REPLACE;
