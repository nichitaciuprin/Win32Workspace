#pragma once

void WriteSysTime(string& message, size_t index)
{
    SYSTEMTIME systime;
    GetSystemTime(&systime);

    auto size = sizeof(SYSTEMTIME);
    auto systimePtr = (char*)&systime;

    auto ptr = (char*)message.data();

    for (size_t i = 0; i < size; i++)
        ptr[i+(size*index)] = systimePtr[i];
}
// void WriteSysTime(char* message, size_t index)
// {
//     SYSTEMTIME systime;
//     GetSystemTime(&systime);

//     auto size = sizeof(SYSTEMTIME);
//     auto systimePtr = (char*)&systime;

//     for (size_t i = 0; i < size; i++)
//         message[i+(size*index)] = systimePtr[i];
// }
SYSTEMTIME ReadSysTime(char* message, size_t index)
{
    SYSTEMTIME systime = {};

    auto size = sizeof(SYSTEMTIME);
    auto systimePtr = (char*)&systime;

    for (size_t i = 0; i < size; i++)
        systimePtr[i] = message[i+(size*index)];

    return systime;
}
void PrintSysTime(SYSTEMTIME systime)
{
    printf("%u:%u:%u.%u", systime.wHour, systime.wMinute, systime.wSecond, systime.wMilliseconds);
}
void PrintSysTime2(SYSTEMTIME start, SYSTEMTIME end)
{
    PrintSysTime(start);
    printf(" -> ");
    PrintSysTime(end);
    printf("\n");
}