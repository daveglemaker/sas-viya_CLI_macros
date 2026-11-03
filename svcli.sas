/*******************************************************************************
            Macro name: svcli
              Location: <SVCLIDIR> TBD
            Written by: Dave Glemaker, David.Glemaker@sas.com.
         Creation date: Aug 4, 2025.
            As of date: Aug 4, 2025.
           SAS version: Stable 2025.04, release 20250501.1746103561677
               Purpose: Submit a sas program with sasgsub and 
                        List Grid Job information for that job
                 Usage: %svcli(mypgm)
            Parameters: mypgm=fully qualified path and filename of sas program
   Optional Parameters: none
     Data sets created: work.mygsubjob
File Reference created: results
           Limitations:
                 Notes: 1. requires xcmd turned on and sas-viya CLI configured
                        2. requires authentication to viya to reside in users home
                        directory. /sashls2-export/pvs/<viyanme>/home/<myid>/.sas
                        3. requires &svclidir, ex. /nfsshare/mysvcliloc
                        4. requires default or custome profile, viya auth init
               History: 08/04/2025 Dave Glemaker created macro
     Sample Macro call: %svcli(/myshared_dir/pgms/sleep1.sas)
This macro is made available “as is” and disclaims any and all representations
and warranties, including without limitation, implied warranties of
merchantability, accuracy, and fitness for a particular purpose.
*******************************************************************************/

%macro svcli(mypgm);
filename results pipe "&svclidir/sas-viya batch jobs submit-pgm --pgm &mypgm --context default";
data svclijob;
   infile results DLM=">>>" missover truncover;
   length Info $200.;
   input Info;
   id=substr(Info,29,36);
   jobid=compress(substr(Info,97),'"');
   if jobid=" " then id=" ";
run;
title "My SAS Viya CLI Job";
proc print data=svclijob; where info ne " ";
var info;
run;

%mend svcli;