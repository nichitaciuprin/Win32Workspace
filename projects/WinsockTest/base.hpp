#pragma once

#undef UNICODE

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <assert.h>
#include <string>
#include <vector>

using namespace std;

#include "../timemessage.hpp"

#pragma comment (lib, "Ws2_32.lib")

// 60 * 1920 * 1080 * 10;
// #define MESSAGE_COUNT 2430000
#define MESSAGE_COUNT 30
#define MESSAGE_SIZE 512

#define SERVER_ADDRESS "localhost"
#define SERVER_PORT "27015"
#define CLIENT_PORT "27016"

string base_name(string const & path)
{
    return path.substr(path.find_last_of("/\\") + 1);
}
#define Fail(message) { cout << base_name(__FILE__) << ":" << __LINE__ << " " << message << endl; abort(); }

bool StringStartsWith(const string& str1, const string& str2)
{
    return str1.rfind(str2, 0) == 0;
}
void PrintSocketAddress(const struct sockaddr& address)
{
    auto address_in = (const struct sockaddr_in&)address;

    auto ipLong = address_in.sin_addr.s_addr;
    auto ipP = (char*)&ipLong;
    auto num0 = (unsigned short)ipP[0];
    auto num1 = (unsigned short)ipP[1];
    auto num2 = (unsigned short)ipP[2];
    auto num3 = (unsigned short)ipP[3];
    auto ipString =
        to_string(num0)+'.'+
        to_string(num1)+'.'+
        to_string(num2)+'.'+
        to_string(num3);

    auto port = htons(address_in.sin_port);

    cout << "IP:" << ipString << " PORT:" << port;
}
void PrintSocket(SOCKET sock)
{
    struct sockaddr sockaddr1;
    int sockaddr1Size = sizeof(sockaddr1);
    auto getsocknameResult = getsockname(sock,&sockaddr1,&sockaddr1Size);
    if (getsocknameResult != 0)
        Fail(getsocknameResult);
    PrintSocketAddress(sockaddr1);
    cout << endl;
}
void InitWinsock()
{
    WSADATA wsaData;
    auto result = WSAStartup(MAKEWORD(2,2), &wsaData);
    if (result == 0) return;
    Fail(to_string(result));
}
void FreeWinsock()
{
    auto result = WSACleanup();
    if (result == 0) return;
    Fail(to_string(result));
}
void CreateAddress(char* address, char* port, int protocol, struct addrinfo** outAddress)
{
    assert(0 <= protocol && protocol >= 1);

    struct addrinfo* addressInfo = NULL;

    struct addrinfo addressInfoHints;
    ZeroMemory(&addressInfoHints, sizeof(addressInfoHints));
    addressInfoHints.ai_flags = AI_PASSIVE;
    addressInfoHints.ai_family = AF_INET;

    if (protocol == 0)
    {
        addressInfoHints.ai_socktype = SOCK_STREAM;
        addressInfoHints.ai_protocol = IPPROTO_TCP;
    }
    else if (protocol == 1)
    {
        addressInfoHints.ai_socktype = SOCK_DGRAM;
        addressInfoHints.ai_protocol = IPPROTO_UDP;
    }

    auto getaddrinfoResult = getaddrinfo(address, port, &addressInfoHints, &addressInfo);
    if (getaddrinfoResult != 0)
        Fail(to_string(getaddrinfoResult));

    *outAddress = addressInfo;
}
void CreateAddressClient(struct addrinfo** outAddress)
{
    struct addrinfo* addressInfo = NULL;
    CreateAddress(NULL, CLIENT_PORT, 1, &addressInfo);
    *outAddress = addressInfo;
}
void CreateAddressServer(struct addrinfo** outAddress)
{
    struct addrinfo* addressInfo = NULL;
    CreateAddress(SERVER_ADDRESS, SERVER_PORT, 1, &addressInfo);
    *outAddress = addressInfo;
}
void CreateSocket(struct addrinfo* addressInfo, SOCKET* outSocket, bool withTimeout)
{
    SOCKET resultSocket = INVALID_SOCKET;

    resultSocket = socket(addressInfo->ai_family, addressInfo->ai_socktype, addressInfo->ai_protocol);
    if (resultSocket == INVALID_SOCKET)
        Fail(to_string(WSAGetLastError()));

    auto bindResult = bind(resultSocket, addressInfo->ai_addr, (int)addressInfo->ai_addrlen);
    if (bindResult == SOCKET_ERROR)
        Fail(to_string(WSAGetLastError()));

    if (withTimeout)
    {
        DWORD milliseconds = 1000*5;
        setsockopt(resultSocket, SOL_SOCKET, SO_RCVTIMEO, (char*)&milliseconds, sizeof(milliseconds));
    }

    *outSocket = resultSocket;
}
void Print(const struct sockaddr_in& address)
{
    auto ipLong = address.sin_addr.s_addr;
    auto ipP = (char*)&ipLong;
    auto num0 = (unsigned short)ipP[0];
    auto num1 = (unsigned short)ipP[1];
    auto num2 = (unsigned short)ipP[2];
    auto num3 = (unsigned short)ipP[3];
    auto ipString =
        to_string(num0)+'.'+
        to_string(num1)+'.'+
        to_string(num2)+'.'+
        to_string(num3);

    auto port = htons(address.sin_port);

    cout << "Address:" << ipString << " Port:" << port;
}
string Receive(SOCKET sock, struct sockaddr* outSockAddress)
{
    struct sockaddr sockAddress;
    int sockAddressSize = sizeof(sockAddress);

    char messageBuffer[MESSAGE_SIZE] = {};

    auto bytesReceived = recvfrom(sock, messageBuffer, MESSAGE_SIZE, 0, &sockAddress, &sockAddressSize);
    if (bytesReceived < 0)
    {
        // Fail(to_string(WSAGetLastError()));
        return "";
    }

    auto result = string(bytesReceived,0);
    auto duno = (char*)result.data();
    for (size_t i = 0; i < bytesReceived; i++)
        duno[i] = messageBuffer[i];

    if (outSockAddress != nullptr)
        *outSockAddress = sockAddress;

    return result;
}
int Send(SOCKET sock, const string& message, const struct addrinfo* addressServer)
{
    auto pMessage = message.data();
    auto messageSize = static_cast<int>(message.length());
    auto flags = 0;
    auto address = addressServer->ai_addr;
    auto addressSize = static_cast<int>(addressServer->ai_addrlen);
    auto bytesSent = sendto(sock,pMessage,messageSize,flags,address,addressSize);
    if (bytesSent < 0)
        Fail(to_string(WSAGetLastError()));
    return bytesSent;
}
int Send2(SOCKET sock, const string& message, const struct sockaddr* address)
{
    auto pMessage = message.data();
    auto messageSize = static_cast<int>(message.length());
    auto flags = 0;
    auto bytesSent = sendto(sock,pMessage,messageSize,flags,address,sizeof(struct sockaddr));
    if (bytesSent < 0)
        Fail(to_string(WSAGetLastError()));
    return bytesSent;
}