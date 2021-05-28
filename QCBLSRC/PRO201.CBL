       PROCESS APOST.
      ****************************************************************
      *                                                              *
      *    PROGRAMME: PRO201                                         *
      *                                                              *
      *                                                              *
      ****************************************************************

       IDENTIFICATION DIVISION.
      *************************

       PROGRAM-ID. PRO201.
       AUTHOR. FORUM AS/400.

       ENVIRONMENT DIVISION.
      **********************

       CONFIGURATION SECTION.
      *---------------------*
       SOURCE-COMPUTER. IBM-AS400.
       OBJECT-COMPUTER. IBM-AS400.

       INPUT-OUTPUT SECTION.
      *--------------------*
       FILE-CONTROL.

           SELECT PROVIDE1 ASSIGN DATABASE-PROVIDE1
                             ORGANIZATION INDEXED
                             ACCESS MODE  SEQUENTIAL
                             RECORD KEY   EXTERNALLY-DESCRIBED-KEY.

           SELECT PRO201D  ASSIGN WORKSTATION-PRO201D
                           ORGANIZATION TRANSACTION
                           ACCESS       DYNAMIC
                           RELATIVE KEY RRN01
                           FILE STATUS IS A
                           CONTROL-AREA F-KEYS.

       DATA DIVISION.
      ***************

       FILE SECTION.
      *------------*

       FD  PROVIDE1.
       01  PRO-REC.
           COPY DDS-FPROV IN PROVIDE1.

       FD  PRO201D.
       01  PRO201D-REC         PIC X(366).

       WORKING-STORAGE SECTION.
      *-----------------------*

       01  CTL01-OUT.
           COPY DDS-CTL01-O    IN PRO201D.
       01  CTL01-IN.
           COPY DDS-CTL01-I    IN PRO201D.

       01  SFL01-OUT.
           COPY DDS-SFL01-O    IN PRO201D.
       01  SFL01-IN.
           COPY DDS-SFL01-I    IN PRO201D.

       01  FMT02-OUT.
           COPY DDS-FMT02-O    IN PRO201D.
       01  FMT02-IN.
           COPY DDS-FMT02-I    IN PRO201D.

       01  PRID-WRK            LIKE PRID IN PRO-REC.

       01  F-KEYS.
           05 F             PIC XX.
              88 F3         VALUE '03'.
              88 F12        VALUE '12'.
      *    ATTENTION PAGEDOWN = 90 AND PAGEUP = 91 ALWAYS !
              88 PAGEDOWN   VALUE '90'.

       01  END-OF-FILE          PIC X.
              88 EOF            VALUE 'E'.
              88 NOF            VALUE 'N'.

       01  IND-ON           PIC 1       VALUE B'1'.
       01  IND-OFF          PIC 1       VALUE B'0'.

       01  A PIC XX.

       01  PANEL          PIC 9(2)    COMP-3    VALUE 1 .
       01  RRN01          PIC 9(4)    COMP-3.
       01  SAVRRN01       PIC 9(4)    COMP-3.
       01  SFLPAG         PIC 9(2)    COMP-3    VALUE 14.
       01  STEP01         PIC X.
       01  STEP02         PIC X.
       01  TELLER         PIC 9(3)    COMP-3.

      * VARIABLES TO IDENTIFY THE PANEL STEP
       01  PRP              PIC X       VALUE 'P'.
       01  DSP              PIC X       VALUE 'D'.
       01  FKEY             PIC X       VALUE 'F'.
       01  CHK              PIC X       VALUE 'C'.
       01  ACT              PIC X       VALUE 'A'.
       01  LOAD             PIC X       VALUE 'L'.

       PROCEDURE DIVISION.
      ********************

        PRO201.
           PERFORM PGM-INIT

           PERFORM UNTIL PANEL = 0
             EVALUATE PANEL
               WHEN 01
                 PERFORM PNL01
               WHEN 02
                 PERFORM PNL02


               WHEN OTHER
                 PERFORM PGM-END
             END-EVALUATE
           END-PERFORM

           PERFORM PGM-END.


       PNL01.

           EVALUATE STEP01
             WHEN PRP
               PERFORM PRP01
             WHEN LOAD
               PERFORM LOD01
             WHEN DSP
               PERFORM DSP01
             WHEN FKEY
               PERFORM FKEY01
             WHEN CHK
               PERFORM CHK01
             WHEN ACT
               PERFORM ACT01
           END-EVALUATE.

      * PREPARE SUBFILE --------------------
       PRP01.
           MOVE IND-ON TO IN30
           MOVE IND-OFF TO IN31
           WRITE PRO201D-REC FROM CTL01-O FORMAT IS 'CTL01'
           END-WRITE
           MOVE IND-OFF TO IN30
           MOVE ZERO TO SAVRRN01


             READ PROVIDE1
                  AT END MOVE IND-ON TO IN80
             END-READ
             MOVE LOAD TO STEP01


      * LOAD SUBFILE   ---------------------
       LOD01.
           MOVE SAVRRN01 TO RRN01
           COMPUTE RRB01 IN CTL01-O = RRN01 + 1
           MOVE 0 TO TELLER
           MOVE 0 TO OPT01 IN SFL01-O
           PERFORM UNTIL IN80 = IND-ON
                         OR TELLER >= SFLPAG
               ADD 1 TO RRN01
               ADD 1 TO TELLER
               MOVE CORR FPROV    TO SFL01-O
               WRITE SUBFILE PRO201D-REC FROM SFL01-O
                             FORMAT IS 'SFL01'
               READ PROVIDE1
                    AT END MOVE IND-ON TO IN80
               END-READ
           END-PERFORM
           MOVE RRN01 TO SAVRRN01
           MOVE DSP TO STEP01

      * DISPLAY PANEL  ---------------------
       DSP01.

           IF SAVRRN01 = ZERO
              MOVE IND-OFF TO IN31
           ELSE
              MOVE IND-ON  TO IN31
           END-IF
           MOVE IND-ON  TO IN32

           WRITE PRO201D-REC FORMAT IS 'KEY01'
           WRITE PRO201D-REC FROM CTL01-O FORMAT IS 'CTL01'
           READ PRO201D INTO CTL01-I FORMAT IS 'CTL01'
           MOVE IND-OFF TO IN35
           MOVE FKEY TO STEP01

      * COMMAND KEYS (EXCEPT CONFIRMATION) ----
       FKEY01.
           EVALUATE TRUE
             WHEN F3
               MOVE 0   TO PANEL
               MOVE PRP TO STEP01
             WHEN F12
               SUBTRACT 1 FROM PANEL
               MOVE PRP TO STEP01
             WHEN PAGEDOWN
               MOVE LOAD TO STEP01
             WHEN OTHER
               MOVE CHK TO STEP01
           END-EVALUATE.

      * CHECK DISPLAY  ---------------------
       CHK01.
           MOVE ACT TO STEP01
           MOVE IND-ON TO IN33
           READ SUBFILE PRO201D NEXT MODIFIED
                               INTO SFL01-I FORMAT IS 'SFL01'
                 AT END SET EOF TO TRUE
                 NOT AT END SET NOF TO TRUE
           END-READ
           PERFORM UNTIL EOF
             MOVE CORR SFL01-I TO SFL01-O
             IF OPT01 IN SFL01-I  NOT = 0
                  AND OPT01 IN SFL01-I NOT = 2
                  AND OPT01 IN SFL01-I NOT = 5
                MOVE IND-ON TO IN35 , IN34
                MOVE DSP TO STEP01
             END-IF
             REWRITE SUBFILE PRO201D-REC FROM SFL01-O
                  FORMAT IS 'SFL01'
             MOVE IND-OFF TO IN34
             READ SUBFILE PRO201D NEXT MODIFIED
                                 INTO SFL01-I FORMAT IS 'SFL01'
                   AT END SET EOF TO TRUE
                   NOT AT END SET NOF TO TRUE
             END-READ
           END-PERFORM
           MOVE IND-OFF TO IN33
      * PERFORM ACTION ---------------------
       ACT01.
             READ SUBFILE PRO201D NEXT MODIFIED
                                 INTO SFL01-I FORMAT IS 'SFL01'
                   AT END SET EOF TO TRUE
                   NOT AT END SET NOF TO TRUE
             END-READ
             IF NOF
                IF OPT01 IN SFL01-I = 2
                   MOVE 2   TO PANEL
                   MOVE CORR SFL01-I TO SFL01-O
                   MOVE 0   TO OPT01 IN SFL01-O
                   REWRITE SUBFILE PRO201D-REC FROM SFL01-O
                       FORMAT IS 'SFL01'

                END-IF
                IF OPT01 IN SFL01-I = 5
                   MOVE PRID IN SFL01-I TO PRID-WRK
                   CALL "ART202" USING  PRID-WRK
                   MOVE CORR SFL01-I TO SFL01-O
                   MOVE 0   TO OPT01 IN SFL01-O
                   REWRITE SUBFILE PRO201D-REC FROM SFL01-O
                       FORMAT IS 'SFL01'
                END-IF
             ELSE
                MOVE DSP TO STEP01
             END-IF.

       PNL02.

             EVALUATE STEP02
               WHEN PRP
                 PERFORM PRP02
               WHEN DSP
                 PERFORM DSP02
               WHEN FKEY
                 PERFORM FKEY02
           END-EVALUATE.

      * PREPARE PANEL 02 ---------------------
       PRP02.
           MOVE CORRESPONDING SFL01-I TO FMT02-O
           MOVE DSP TO STEP02

      * DISPLAY PANEL 02 ---------------------
       DSP02.

           WRITE PRO201D-REC FROM FMT02-O FORMAT IS 'FMT02'
           READ PRO201D INTO FMT02-I FORMAT IS 'FMT02'
           MOVE FKEY TO STEP02

      * COMMAND KEYS (EXCEPT CONFIRMATION) 02 ----
       FKEY02.
             EVALUATE TRUE
               WHEN F3
                 MOVE 1   TO PANEL
                 MOVE PRP TO STEP02
                 MOVE PRP TO STEP01
               WHEN F12
                 SUBTRACT 1 FROM PANEL
                 MOVE PRP TO STEP02
                 MOVE DSP TO STEP01
               WHEN OTHER
                 SUBTRACT 1 FROM PANEL
                 MOVE PRP TO STEP02
           END-EVALUATE.

        PGM-INIT.
           MOVE 1    TO PANEL
           MOVE PRP  TO STEP01
           MOVE PRP  TO STEP02
           OPEN INPUT PROVIDE1
                I-O   PRO201D.

        PGM-END.
           CLOSE  PRO201D PROVIDE1
           STOP RUN.
