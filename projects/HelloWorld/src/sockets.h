#pragma once

#include <winsock2.h>
#pragma warning(push)
#pragma warning(disable : 6101) // some out params are not inited
#include <ws2tcpip.h>
#pragma warning(pop)
#pragma comment(lib, "Ws2_32.lib")