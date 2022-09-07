/* this is OPM CL for completeness of example */
/* in practice you should just use ILE CL     */
PGM        PARM(&CUID)
    DCL    VAR(&CUID) TYPE(*DEC) LEN(5 0)
    
    CALL ORD100C PARM(&CUID)
ENDPGM