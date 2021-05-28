
      * Status Data Structure
      *
     d                sds
      * Program Name
     d stPgmName               1     10
      * Exception Error Message Text
     d stExcText              91    170

     d isotodat        pr                    extpgm('DAT001')
       // input
     d  dat8                          8  0
       // result
     d  date                           d
       // Null Indicator Parameters
     d  dat8_ind                      5i 0
     d  date_ind                      5i 0
       // SQL Function Parameters
       // SQL State  -  Input/Output
     d SQL_State                      5
       // Function Name    Schema.Def name - Input only
     d Function_Name                139
       // Function Specific Name - Input Only
     d Specific_Name                128
       // Message Text - Input/Output
     d Msg_Text                      70    varying

     d isotodat        pi
     d  dat8                          8  0
     d  date                           d
     d  dat8_ind                      5i 0
     d  date_ind                      5i 0
     d SQL_State                      5
     d Function_Name                139
     d Specific_Name                128
     d Msg_Text                      70    varying
      /free
       // Clear NULL column indicator and SQL State
       date_ind=*zero ;
       SQL_State='00000';
        // If valid date return *on
       test(de) *iso dat8;
       if %error;
         date_ind = -1;
       else;
         date = %date(dat8:*iso);
       endif;
       return;

       begsr *PSSR;
         // Return error code in SQL State (38xxx)
         // Set SQL Message Text to first 70 characters of SDS exception text

         SQL_State='38I02';
         Msg_Text=%trimr(stExcText);
         return;
       endsr;
      /end-free
