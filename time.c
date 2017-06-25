#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int status;
int main (int argc,char *argv[])
{

	int pid;
	int  a, b;	
	pid = fork();
	if (pid == 0)
	{	
		exec(argv[1], argv);
		printf(1, "exec %s failed\n", argv[1]);
	}
	else
	{
		status = waitx(&a, &b);
	} 
	printf(1, "Wait Time = %d\n Run Time = %d with status %d \n", a, b, status); 
	exit();
}
