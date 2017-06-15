This is one of the good way to know whether the EVENTS has been enabled / disabled or not.

Example:-

1. Enabling now.

SQL> ALTER SYSTEM SET EVENTS '10442 trace name context forever, level 10';

2. Disabling now.

SQL> ALTER SYSTEM SET EVENTS '10442 trace name context off';

System altered.

The same can be found form the alert log.

OS Pid: 24789 executed alter system set events '10442 trace name context off'
Sat Jul 14 04:30:25 2012

There are ways to find out from the db level, whether this is disabled or enabled.

one way is to use dbms_system.read_ev

set serveroutput on

DECLARE
lev BINARY_INTEGER;
BEGIN
dbms_system.read_ev(10442, lev);
dbms_output.put_line(lev);
END;
/
10 -- means the event is enabled.

PL/SQL procedure successfully completed.



set serveroutput on

DECLARE
lev BINARY_INTEGER;
BEGIN
dbms_system.read_ev(10442, lev);
dbms_output.put_line(lev);
END;
/
0 -- means the event is disabled.


The output 0 means disabled or if not set.
