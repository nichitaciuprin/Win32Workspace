#include <iostream>
#include <array>

using namespace std;

string CreateReversed(string str)
{
    auto length = str.length();
    auto strNew = string(length,'\0');
    for (auto i = 0; i < length; i++)
        strNew[i] = str[length-1-i];
    return strNew;
}
int main()
{
    cout << CreateReversed("Kevin") << endl;
    cout << CreateReversed("Tom") << endl;
    cout << CreateReversed("David") << endl;
	return 0;
}