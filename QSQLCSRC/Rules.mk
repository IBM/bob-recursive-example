MODULEs := ANZ_FILE2.MODULE 
PGMs := ANZ_FILE2.PGM

ANZ_FILE2.MODULE: ANZ_FILE2.SQLC
#ANZ_FILE2.MODULE: private INLINE = *ON *AUTO *NOLIMIT *NOLIMIT *YES
#ANZ_FILE2.PGM: private ACTGRP = *CALLER
ANZ_FILE2.MODULE: private OPTIMIZE = 40
ANZ_FILE2.PGM: ANZ_FILE2.MODULE

