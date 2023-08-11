#include "base.h"

string to_camel_case(string text)
{
    for (size_t i = 0; i < text.size(); i++)
    {
        if (text[i] == '-' || text[i] == '_')
        {
            text.erase(i,1);
            text[i] = (char)toupper(text[i]);
        }
    }
    return text;
}
int main(void)
{
    auto test1 = string("the-stealth-warrior");
    auto test2 = string("The_Stealth_Warrior");
    auto test3 = string("The_Stealth-Warrior");

    cout << test1 << " -> " << to_camel_case(test1) << endl;
    cout << test2 << " -> " << to_camel_case(test2) << endl;
    cout << test3 << " -> " << to_camel_case(test3) << endl;

    return 0;
}