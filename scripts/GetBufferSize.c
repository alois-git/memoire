#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
int main ( int arc, char **argv ) {

	int n;
	unsigned int m = sizeof(n);
	int fdsocket = socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP); // example
	getsockopt(fdsocket,SOL_SOCKET,SO_RCVBUF,(void *)&n, &m);
	// now the variable n will have the socket size
	printf("%d\n", n);

}
