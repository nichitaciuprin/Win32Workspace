#include "..\base.hpp"

int __cdecl main(void)
{
    InitWinsock();

    struct addrinfo* addressServer = {};
    CreateAddress(NULL, SERVER_PORT, 1, &addressServer);

    SOCKET sock = INVALID_SOCKET;
    CreateSocket(addressServer,&sock,true);

    struct sockaddr senderSockAddress;

    auto messages = vector<string>();

    while (true)
    {
        Sleep(1000);
        auto message = Receive(sock, &senderSockAddress);
        if (message.size() == 0) continue;
        auto command = (unsigned short)message[0];
        cout << command << endl;
        switch (command)
        {
            case 0:
            {
                Send2(sock, to_string(messages.size()), &senderSockAddress);
                continue;
            }
        }

        // if (StringStartsWith(message,"STATUS"))
        // {
        // }
        // if (StringStartsWith(message,"TEST"))
        // {
        //     for (size_t i = 0; i < MESSAGE_COUNT; i++)
        //     {
        //         auto message = Receive(sock, &senderSockAddress);
        //         WriteSysTime(message, 1);
        //         auto systime1 = ReadSysTime((char*)message.data(),0);
        //         auto systime2 = ReadSysTime((char*)message.data(),1);
        //         PrintSysTime2(systime1,systime2);
        //         messages.push_back(message);
        //     }

        //     for (size_t i = 0; i < MESSAGE_COUNT; i++)
        //     {
        //         auto message = messages[i];
        //         Send2(sock, message, &senderSockAddress);
        //     }

        //     messages.clear();

        //     continue;
        // }
    }

    FreeWinsock();

    return 0;
}