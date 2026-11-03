/*******************************************************************************
            Macro name: bkill
              Location: <SVCLIDIR> TBD
            Written by: Dave Glemaker, David.Glemaker@sas.com.
         Creation date: Aug 4, 2025.
            As of date: Aug 4, 2025.
           SAS version: Stable 2025.04, release 20250501.1746103561677
               Purpose: Kills Compute job of jobid provided and List the status
                        of the kill command for that jobid
                 Usage: %bkill(jobid)
            Parameters: jobid=numeric Compute Job ID
   Optional Parameters: none
     Data sets created: work.bkill
File Reference created: bkill
           Limitations:
                 Notes: 1. requires xcmd turned on and sas-viya CLI configured
                        2. requires authentication to viya to reside in users home
                        directory. /sashls2-export/pvs/<viyanme>/home/<myid>/.sas
                        3. requires &svclidir, ex. /nfsshare/mysvcliloc
                        4. requires default or custom profile, viya auth init
               History: 08/04/2025 Dave Glemaker created macro
     Sample Macro call: %bkill(1789)
This macro is made available “as is” and disclaims any and all representations
and warranties, including without limitation, implied warranties of
merchantability, accuracy, and fitness for a particular purpose.
*******************************************************************************/

%macro bkill(jobid);
filename bkill pipe "&svclidir/sas-viya workload-orchestrator jobs cancel --force --id &jobid";

data bkill;
   infile bkill missover dlm="?" firstobs=1;
   length JobInfo $200. ;
   input JobInfo;
run;
title "Cancel Job &jobid status";
proc print data=bkill; where jobinfo ne " ";
var jobinfo;
run;

%mend bkill;