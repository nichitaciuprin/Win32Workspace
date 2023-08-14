#include "base.h"

string incrementStringDigits(const string& digits)
{
    auto number = digits.size() == 0 ? 1 : stoi(digits)+1;
    auto numberStr = to_string(number);
    auto zerosStr = string();
    if (digits.size() > numberStr.size())
    {
        auto zeroCount = digits.size() - numberStr.size();
        zerosStr = string(zeroCount,'0');
    }
    return zerosStr+numberStr;
}
string incrementString(const string& str)
{
    int digitCount = 0;
    auto strSize = str.size();
    auto index = strSize - 1;
    for (size_t i = 0; i < strSize; i++)
    {
        auto char_ = str[index-i];
        if (!isdigit(char_)) break;
        digitCount++;
    }
    auto letterCount = strSize - digitCount;

    auto left = str.substr(0,letterCount);
    auto right = str.substr(letterCount,digitCount);

    right = incrementStringDigits(right);

    return left+right;
}
void do_test(const string& input, const string& expected)
{
    auto actual = incrementString(input);
    cout << input << " -> " << actual << endl;
}
int main(void)
{
    do_test("foobar000", "foobar001");
    do_test("foo", "foo1");
    do_test("foobar001", "foobar002");
    do_test("foobar99", "foobar100");
    do_test("foobar099", "foobar100");
    do_test("", "1");
    return 0;
}