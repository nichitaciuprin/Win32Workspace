#include "..\base.hpp"

int __cdecl main(void)
{
    InitWinsock();

    struct addrinfo* addressClient = NULL;
    CreateAddress(NULL, CLIENT_PORT, 1, &addressClient);

    struct addrinfo* addressServer = NULL;
    CreateAddress(SERVER_ADDRESS, SERVER_PORT, 1, &addressServer);

    SOCKET sock = INVALID_SOCKET;
    CreateSocket(addressClient,&sock,true);

    char msg[MESSAGE_SIZE];
    msg[0] = (char)0;

    Send(sock,msg,addressServer);
    auto message = Receive(sock, nullptr);
    cout << message << endl;

    // auto messages = vector<string>();

    // for (size_t i = 0; i < MESSAGE_COUNT; i++)
    // {
    //     auto message = string(MESSAGE_SIZE,'x');
    //     WriteSysTime(message, 0);
    //     Send(sock,message,addressServer);
    // }

    // for (size_t i = 0; i < MESSAGE_COUNT; i++)
    // {
    //     auto message = Receive(sock, nullptr);
    //     messages.push_back(message);
    // }

    FreeWinsock();

    return 0;
}