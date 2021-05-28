             CMD        PROMPT('Convert Spool to PDF')

             PARM       KWD(FROMFILE) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('From spooled file name')

             PARM       KWD(TOSTMF) TYPE(*NAME) LEN(64) MIN(1) PROMPT('To +
                          stream file name')

             PARM       KWD(TODIR) TYPE(*PNAME) LEN(256) MIN(1) PROMPT('To +
                          directory')

             PARM       KWD(JOB) TYPE(JOB) DFT(*) SNGVAL((*)) PROMPT('Job +
                          name')
 JOB:        QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) MIN(1) PROMPT('User')
             QUAL       TYPE(*CHAR) LEN(6) RANGE(000000 999999) MIN(1) +
                          PROMPT('Number')

             PARM       KWD(SPLNBR) TYPE(*DEC) LEN(4) DFT(*ONLY) RANGE(1 +
                          9999) SPCVAL((*LAST -2) (*ONLY -3)) +
                          PROMPT('Spooled file number')

             PARM       KWD(STMFOPT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*NONE) VALUES(*NONE *REPLACE ) +
                          PROMPT('Stream file option')

             PARM       KWD(STMFCODPAG) TYPE(*DEC) LEN(5 0) DFT(1250) +
                          RANGE(1 32767) SPCVAL((*PCASCII -1) (*STMF -2)) +
                          PMTCTL(*PMTRQS) PROMPT('Stream file code page')

             PARM       KWD(TITLE) TYPE(*CHAR) LEN(50) RSTD(*NO) +
                          DFT(*NONE) SPCVAL((*NONE) (*STMFILE)) +
                          PROMPT('Title for PDF')

             PARM       KWD(PAGESIZE) TYPE(LIST3) DFT(*SPLF) +
                          SNGVAL((*SPLF) (*CUSTOM)) CHOICE(*NONE) +
                          PROMPT('Page size')
 LIST3:      ELEM       TYPE(*CHAR) LEN(7) RSTD(*YES) VALUES(*A4 *A5 +
                          *LETTER *LEGAL *EXEC) PROMPT('Paper size')
             ELEM       TYPE(*CHAR) LEN(10) RSTD(*YES) DFT(*LANDSCAPE) +
                          VALUES(*LANDSCAPE *PORTRAIT) +
                          PROMPT('Orientation')

             PARM       KWD(CUSTOMPAGE) TYPE(LIST4) CHOICE(*NONE) +
                          PMTCTL(CUSTOM) PROMPT('Custom page size')
 LIST4:      ELEM       TYPE(*DEC) LEN(6 3) DFT(210) RANGE(.001 999.999) +
                          EXPR(*YES) PROMPT('Page width')
             ELEM       TYPE(*DEC) LEN(6 3) DFT(297) RANGE(.001 999.999) +
                          EXPR(*YES) PROMPT('Page length')
             ELEM       TYPE(*CHAR) LEN(5) RSTD(*YES) DFT(*MM) +
                          VALUES(*INCH *MM) EXPR(*YES) PROMPT('Unit of +
                          measure')

             PARM       KWD(FONT) TYPE(LIST5) DFT(*CONVERT) +
                          SNGVAL((*CONVERT)) CHOICE(*NONE) PROMPT('Font')
 LIST5:      ELEM       TYPE(*CHAR) LEN(10) RSTD(*YES) SPCVAL((*COURIER) +
                          (*COURIERB) (*COURIERO) (*COURIERBO) +
                          (*HELVETICA) (*HELVB) (*HELVO) (*HELVBO) +
                          (*TIMES) (*TIMESB) (*TIMESI) (*TIMESBI) +
                          (*SYMBOL) (*DINGBATS)) EXPR(*YES) PROMPT('Face')
             ELEM       TYPE(*DEC) LEN(2) DFT(*CALC) RANGE(4 36) +
                          SPCVAL((*CALC -1)) EXPR(*YES) PROMPT('Size')

             PARM       KWD(BOOKMARK) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*PAGNBR) VALUES(*PAGNBR *POS *KEY *NONE) +
                          PROMPT('Type of PDF bookmarks')

             PARM       KWD(BMARKPOS) TYPE(LIST1) PMTCTL(POS) PROMPT('PDF +
                          bookmark string position')
 LIST1:      ELEM       TYPE(*DEC) LEN(3 0) DFT(1) RANGE(1 300) +
                          PROMPT('Line number')
             ELEM       TYPE(*DEC) LEN(3 0) DFT(1) RANGE(1 378) +
                          PROMPT('Character position')
             ELEM       TYPE(*DEC) LEN(3 0) DFT(1) RANGE(1 378) +
                          PROMPT('Length')

             PARM       KWD(BMARKKEY) TYPE(LIST2) PMTCTL(KEY) PROMPT('PDF +
                          bookmark string key')
 LIST2:      ELEM       TYPE(*CHAR) LEN(378) DFT(' ') VARY(*YES *INT2) +
                          PROMPT('Key string')
             ELEM       TYPE(*DEC) LEN(3 0) DFT(1) RANGE(1 999) +
                          PROMPT('Occurrence')
             ELEM       TYPE(*DEC) LEN(3 0) DFT(0) RANGE(-378 378) +
                          PROMPT('Offset')
             ELEM       TYPE(*DEC) LEN(3 0) DFT(1) RANGE(1 378) +
                          PROMPT('Length')

 CUSTOM:     PMTCTL     CTL(PAGESIZE) COND((*EQ *CUSTOM)) NBRTRUE(*EQ 1)

 POS:        PMTCTL     CTL(BOOKMARK) COND((*EQ *POS)) NBRTRUE(*EQ 1)

 KEY:        PMTCTL     CTL(BOOKMARK) COND((*EQ *KEY)) NBRTRUE(*EQ 1)

