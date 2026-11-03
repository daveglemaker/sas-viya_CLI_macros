/*******************************************************************************
            Macro name: bhosts
              Location: <svclidir> TBD
            Written by: Dave Glemaker, David.Glemaker@sas.com.
         Creation date: Aug 4, 2025.
            As of date: Aug 4, 2025.
           SAS version: Stable 2025.04, release 20250501.1746103561677
               Purpose: List Compute Host Names, the state they are in, number of
                        jobs running and suspended on each
                 Usage: %bhosts
            Parameters: none
   Optional Parameters: none
     Data sets created: work.bhosts
File Reference created: bhosts
           Limitations: 
                 Notes: 1. requires xcmd turned on and sas-viya CLI configured 
                        2. requires authentication to viya to reside in users home
                        directory. /sashls2-export/pvs/<viyanme>/home/<myid>/.sas
                        3. requires &svclidir, ex. /nfsshare/mysvcliloc
                        4. requires default or custome profile, viya auth init
               History: 08/04/2025 Dave Glemaker created macro
     Sample Macro call: %bhosts
This macro is made available “as is” and disclaims any and all representations 
and warranties, including without limitation, implied warranties of 
merchantability, accuracy, and fitness for a particular purpose.
*******************************************************************************/    

%macro bhosts;
filename bhosts pipe "&svclidir/sas-viya workload-orchestrator hosts list";

data bhosts;
   infile bhosts missover dlm=' ' firstobs=2;
      length name $25. type $20. state $20. jobsrunning 8. jobssuspended 8. ;
      input NAME TYPE STATE JOBSRUNNING JOBSSUSPENDED ;     
      label name='Name'
            type='Type'
            state='State'
            jobsrunning='Jobs Running'
            jobssuspended='Jobs Suspended';
run;
title "Compute Host Listing";
proc print label;
   run;
title;
%mend bhosts;