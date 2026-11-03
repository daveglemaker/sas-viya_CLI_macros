/* Check if the session return code is 4 (Warnings only), reset to 0*/
%macro reset_rc;
    %if &syscc = 4 %then %do;
        /* Reset the SAS condition code to 0 */
        %let syscc=0;
    %end;
%mend reset_rc;

