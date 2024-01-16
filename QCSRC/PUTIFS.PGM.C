#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>

#define argcpy(a,b)   { \
                          int i=sizeof(a)-1; \
                          (a)[i]=0x00;       \
                          strncpy((a),(b),i); \
                          do { \
                            (a)[i--]=0x00; \
                          } while ((a)[i] == ' '); \
                       }
#define isBlank(v)     ((v) == ' ' || (v) == '\t')
#if defined(__OS400_TGTVRM__) || defined(__ILEC400__)
#  define isSep(v)     (isBlank(v) || (v) == 0x25 || (v) == '\r' || (v) == '\n' || (v) == 0x00)
#else
#  define isSep(v)     (isBlank(v) || (v) == '\r' || (v) == '\n' || (v) == 0x00)
#endif
#define trimEOF(l)   	{ int len=strlen(l)-1; while (isSep((l)[len])) (l)[len--]=0x00; }



static const char clError[]="Error message ID = ";
int	main(int	argc,
	     char *	argv[])
{
  int   rc  = 0;
  char          lib[10+1];
  char          file[10+1];
  char          mbr[10+1];

  argcpy(lib,	        argv[1]);
  argcpy(file,	        argv[2]);
  argcpy(mbr,	        argv[3]);

  {
    FILE *fd;
    char  fileName[100];
    char  line[1024];
    char  lastCmd[1024];

    sprintf(fileName, "/QSYS.LIB/%s.LIB/%s.FILE/%s.MBR", lib, file, mbr);
    if ((fd = fopen(fileName, "r")) == NULL)
    {
      fprintf(stderr, "open(%s, 'r') failed, errno = %d\n", fileName, errno);
      return 1;
    }

    while (!feof(fd))
    {
      if (fgets(line, sizeof(line), fd) == NULL)
        break;

      trimEOF(line);

      if (line[0] == 0x00)
        continue;

      if (isdigit(line[0]) && line[3] == ' ')
      {
        if (memcmp(line+4, "bytes transferred in ", 21) == 0)
          continue;

        if (line[0] == '4' || line[0] == '5')
        {
          if (memcmp(lastCmd, "QUOTE RCMD MKDIR DIR(", 21) == 0)
            continue;

          rc = atoi(line);
          fprintf(stderr, "Error %d in command: %s\n", rc, lastCmd);
        }

      } else if (memcmp(line, clError, sizeof(clError)-1) == 0) {
        if (memcpy(lastCmd, "SYSCMD CRTSAVF FILE(QTEMP/PUTIFSSAVF)", 37) == 0)
          continue;

        rc = atoi(line + sizeof(clError));
        fprintf(stderr, "Error %s in command: %s\n", line + sizeof(clError), lastCmd);

      } else if (line[0] == '>') {
        strcpy(lastCmd, line + 2);
      }
    }

    if (rc > 0)
    {
      fprintf(stderr, "-- Dump of %s ----------------\n", file);
      fseek(fd, 0, SEEK_SET);
      while (!feof(fd))
      {
        if (fgets(line, sizeof(line), fd) == NULL)
          break;
        trimEOF(line);

        if (line[0] == 0x00)
          continue;

        fprintf(stderr, "%s\n", line);
      }
      fprintf(stderr, "-- End of %s ----------------\n", file);
      fflush(stderr);
      gets(line);
    }

    fclose(fd);
  }
  return rc;
}

