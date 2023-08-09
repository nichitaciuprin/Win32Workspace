#include <iostream>
#include <vector>
#include <stack>
#include <string>

using namespace std;

void Print(const vector<string> array)
{
    auto size = array.size();
    if (size == 0)
    {
        cout << "[]";
    }
    else if (size == 1)
    {
        cout << '[' << array[0] << ']';
    }
    else
    {
        cout << '[';
        cout << array[0];
        for (size_t i = 1; i < size; i++)
        {
            cout << ',';
            cout << array[i];
        }
        cout << ']';
    }
    cout << endl;
}
vector<string> split(const string& str, size_t char_count)
{
    auto result = vector<string>();
    auto length = str.length();

    for (size_t i = 0; i < length; i += char_count)
    {
        auto substring = str.substr(i, char_count);
        result.push_back(substring);
    }

    if (result.size() == 0)
        return result;

    string& last = result.back();
    auto append_count = last.length() % char_count;

    last.append(append_count,'_');

    return result;
}
vector<string> solution(const string& s)
{
    return split(s,2);
}
void test_1()
{
    auto result = solution("abcde");
    Print(result);
}
int main()
{
    test_1();
    return 0;
}