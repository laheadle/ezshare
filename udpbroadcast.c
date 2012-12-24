/* Inspired by code here: http://developerweb.net/viewtopic.php?pid=32260 */

#ifdef WIN32
# include <winsock2.h>
# include <io.h>
# define  socklen_t int
# define  sockopt_t char
#else
# include <netdb.h>
# include <netinet/in.h>
# include <arpa/inet.h>
# include <sys/time.h>
# include <sys/types.h>
# include <sys/socket.h>
# include <unistd.h>
# include <time.h>
# define  sockopt_t int
#endif
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define PORT 2080
#include "udpbroadcast.h"

typedef struct peer {
  SOCKET socket;
  struct sockaddr_in addr;
} peer;

int initialized = 0;
static void init(){
  if (initialized)
    return;
  initialized = 1;
  WSADATA WSAData;
  if (WSAStartup (MAKEWORD(2,2), &WSAData) != 0) 
    {
      printf("WSAStartup failed!\n");
      exit(2);
    }
}

void* peer_create(int isServer) 
{
  init();
  peer *p = (peer*)malloc(sizeof(peer));
  sockopt_t broadcast=1;

  if ((p->socket = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
    perror("socket");
    exit(1);
  }
  if ((setsockopt(p->socket, SOL_SOCKET, SO_BROADCAST,
		  &broadcast, sizeof broadcast)) == -1) {
    perror("setsockopt - SO_SOCKET ");
    exit(1);
  }
  printf("Socket created\n");

  memset(&p->addr, 0, sizeof p->addr);
  p->addr.sin_family = AF_INET;
  p->addr.sin_port = htons(PORT);
  p->addr.sin_addr.s_addr = INADDR_BROADCAST;

  if (isServer) {
    p->addr.sin_addr.s_addr = INADDR_ANY;
    if (bind(p->socket, (struct sockaddr*)&p->addr, sizeof p->addr) == -1) {
      perror("bind");
      printf("%d", WSAGetLastError());
      exit(1);
    }
  }

  return p;
}


int peer_broadcast(void* peerIn, char* msg, unsigned int size)
{
  peer* p = (peer*) peerIn;
  return sendto(p->socket, msg, size, 0, 
		(struct sockaddr *)&p->addr, sizeof p->addr);
}

void peer_destroy(void* p)
{
  free((peer*)p);
}

/* timneout is milliseconds */
int peer_select(void* peerIn, int timeout) {
  peer* p = (peer*) peerIn;
  int n;
  fd_set set;
  struct timeval timev = { 0, timeout*1000 };
  FD_ZERO(&set);
  FD_SET(p->socket, &set);
  
  return select(p->socket+1, &set, NULL, NULL, &timev);
}

int peer_receive(void* peerIn, char* buf, int bufsize) 
{
  peer* p = (peer*) peerIn;
  socklen_t addr_len = sizeof p->addr;
  return recvfrom(p->socket, buf, bufsize, 0, 
		  (struct sockaddr *)&p->addr, &addr_len);
}
