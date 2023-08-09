#include "base.h"
#include "sockets.h"

#define DEFAULT_PORT "27015"

int __cdecl main(void)
{
    WSADATA wsaData;
    auto result = WSAStartup(MAKEWORD(2,2), &wsaData);
    if (result != 0) return 1;
    return 0;
}