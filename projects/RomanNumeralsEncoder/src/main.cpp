#include "base.h"

string solution(int number)
{
    auto result = string();
    while ( number  >= 1000 )  { number -= 1000; result.append(  "M" ); }
    if    ( number >=   900 )  { number -=  900; result.append( "CM" ); }
    if    ( number >=   500 )  { number -=  500; result.append(  "D" ); }
    if    ( number >=   400 )  { number -=  400; result.append( "CD" ); }
    if    ( number >=   100 )  { number -=  100; result.append(  "C" ); }
    if    ( number >=    90 )  { number -=   90; result.append( "XC" ); }
    if    ( number >=    50 )  { number -=   50; result.append(  "L" ); }
    if    ( number >=    40 )  { number -=   40; result.append( "XL" ); }
    if    ( number >=    10 )  { number -=   10; result.append(  "X" ); }
    if    ( number >=     9 )  { number -=    9; result.append( "IX" ); }
    if    ( number >=     5 )  { number -=    5; result.append(  "V" ); }
    if    ( number >=     4 )  { number -=    4; result.append( "IV" ); }
    if    ( number >=     1 )  { number -=    1; result.append(  "I" ); }
    return result;
}
int main(void)
{
    auto number1 =  102; cout << number1 << " -> " << solution(number1) << endl;
    auto number2 = 1994; cout << number2 << " -> " << solution(number2) << endl;
    auto number3 = 2041; cout << number3 << " -> " << solution(number3) << endl;
    auto number4 = 2023; cout << number4 << " -> " << solution(number4) << endl;
    return 0;
}
