/*******************************************************************************
            Macro name: bjobs
              Location: <svclidir> TBD
            Written by: Dave Glemaker, David.Glemaker@sas.com.
         Creation date: Aug 4, 2025.
            As of date: Aug 5, 2026.
           SAS version: Stable 2026.06, Release: 20260630.1782830232867
               Purpose: List Grid Job information for active user from time of day up to 100 jobs
                 Usage: %bjobs(tod=09:30)
            Parameters: tod=time, time of day of first job to list, format HH:MM
         default value: 08:00
   Optional Parameters: none
     Data sets created: work.bjobs
File Reference created: bjobs 
           Limitations:
                 Notes: 1. requires xcmd turned on and sas-viya CLI configured
                        2. requires authentication to viya to reside in users home
                        directory. /sashls2-export/pvs/<viyanme>/home/<myid>/.sas
                        3. requires &svclidir, ex. /nfsshare/mysvcliloc
                        4. requires default or custome profile, sas-viya auth init
               History: 08/04/2025 Dave Glemaker created macro
                        08/05/2026 Dave Glemaker edited to change firstjobid to firstendtime and fjid to tod
     Sample Macro call: %bjobs(tod=09:00)
This macro is made available “as is” and disclaims any and all representations
and warranties, including without limitation, implied warranties of
merchantability, accuracy, and fitness for a particular purpose.
*******************************************************************************/

%macro bjobs(tod=08:00);
data _null_;
    dt=today();
    call symput("dt",put(dt,yymmdd10.));
run;
filename bjobs pipe "&svclidir/sas-viya workload-orchestrator jobs list --firstendtime &dt.T&tod:00 --limit 100 --details";

data bjobs;
   infile bjobs missover truncover dlm=' ' firstobs=2;
      length id 8. name $200. user $20. state $20. executionhost $20. exitcode 8. submittime $20. starttime $20. endtime $20.;
      input ID NAME USER STATE EXECUTIONHOST EXITCODE SUBMITTIME  STARTTIME ENDTIME;
      label id='JobID'
            state='State'
            user='User'
            name='Job Name'
            exitcode='Exit Code'
            executionhost='Execution Host'
            submittime='Submit Time'
            starttime='Start Time'
            endtime='End Time';
run;
title "Compute Job Listing";
proc print data=bjobs label;
   run;
title;
%mend bjobs;