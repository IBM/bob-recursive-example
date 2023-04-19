#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/signal.h>

#define argcpy(a,b)     memcpy((a),(b),sizeof(a)-1); (a)[sizeof(a)-1]=0x00


int	main(int	argc,
	     char *	argv[])
{
  /*
  int	signal;
  char  szSignal[10+1];
  char  szPidFile[100+1];

  argcpy(szPidFile,	argv[1]);
  argcpy(szSignal,	argv[2]);

  {
    int         i=sizeof(szPidFile)-2;
    while (szPidFile[i] == ' ')
      szPidFile[i--]=0x00;
  }
  */
  {
    char curDir[1024];
    char buf[10];
    char *p=getcwd(curDir, sizeof(curDir));
    if (p == NULL)
      fprintf(stderr, "getcwd() failed\n");
    fprintf(stdout, "%s\n", p);

    gets(buf);
    return 0;
  }
}
