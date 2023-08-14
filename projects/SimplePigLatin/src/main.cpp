#include "base.h"
#include <regex>

string concat(const vector<string>& words)
{
    auto result = string("");
    for (auto const& word : words)
        result.append(word);
    return result;
}
vector<string> split(const string& text)
{
    auto textLenght = text.length();
    auto words = vector<string>();

    if (textLenght == 0) return words;

    auto curentWord = string();

    auto firstChar = (text.data())[0];
    auto takeWhitespace = firstChar == ' ';
    curentWord.push_back(firstChar);

    for (size_t i = 1; i < textLenght; i++)
    {
        auto char_ = (text.data())[i];

        auto switchMode =
            ( takeWhitespace && char_ != ' ') ||
            (!takeWhitespace && char_ == ' ');

        if (switchMode)
        {
            takeWhitespace = !takeWhitespace;
            words.push_back(curentWord);
            curentWord.clear();
        }

        curentWord.push_back(char_);
    }

    words.push_back(curentWord);

    return words;
}
string pig_it(string str)
{
    auto words = split(str);
    for (auto & word : words)
    {
        auto firstChar = word.data()[0];
        if (!isalpha(firstChar)) continue;
        word.erase(0,1);
        word.push_back(firstChar);
        word.append("ay");
    }
    return concat(words);
}
void test(const string text)
{
    cout << text << " -> " << pig_it(text) << endl;
}
int main(void)
{
    test("Pig latin is cool");
    test("Hello world !");
    test("hey, my string");
    return 0;
}
