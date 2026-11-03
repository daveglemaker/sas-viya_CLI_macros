/*******************************************************************************
            Macro name: gjobs
              Location: <svclidir> TBD
            Written by: Dave Glemaker, David.Glemaker@sas.com.
         Creation date: Aug 4, 2025.
            As of date: Aug 4, 2025.
           SAS version: Stable 2025.04, release 20250501.1746103561677
               Purpose: List Grid Job information for active user
                 Usage: %gjobs(jfid)
            Parameters: jfid=numeric Compute First Job ID
   Optional Parameters: none
     Data sets created: work.gjobs
File Reference created: gjobs 
           Limitations:
                 Notes: 1. requires xcmd turned on and sas-viya CLI configured
                        2. requires authentication to viya to reside in users home
                        directory. /sashls2-export/pvs/<viyanme>/home/<myid>/.sas
                        3. requires &svclidir, ex. /nfsshare/mysvcliloc
                        4. requires default or custome profile, viya auth init
               History: 08/04/2025 Dave Glemaker created macro
     Sample Macro call: %gjobs(1789)
This macro is made available “as is” and disclaims any and all representations
and warranties, including without limitation, implied warranties of
merchantability, accuracy, and fitness for a particular purpose.
*******************************************************************************/

%macro gjobs(fjid);
filename gjobs pipe "&svclidir/sas-viya workload-orchestrator jobs list --firstjobid &fjid --limit 50 --details";

data gjobs;
   infile gjobs missover truncover dlm=' ' firstobs=2;
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
proc print data=gjobs label;
   run;
title;
%mend gjobs;