#include <stdlib.h>
#include <stdio.h>

unsigned char reverse(unsigned char b)
{
   b = (b & 0xF0) >> 4 | (b & 0x0F) << 4;
   b = (b & 0xCC) >> 2 | (b & 0x33) << 2;
   b = (b & 0xAA) >> 1 | (b & 0x55) << 1;
   return b;
}
void show_mem_rep(char* start, int n)
{
    for (int i = 0; i < n; i++)
         printf("%x", start[i]);
    printf("\n");
}
void PrintChar(char value)
{
    for (int i = 0; i < 8; i++)
        printf("%d", !!((value << i) & 0x80));
}
void PrintMemory(char* start, int count)
{
    for (int i = 0; i < count; i++)
    {
        printf("%p ",start);
        PrintChar(start[i]);
        printf("\n");
        start++;
    }
}
