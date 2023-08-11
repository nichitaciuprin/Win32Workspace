#include "base.h"

bool contains(const vector<char>& items, char item)
{
    for (auto const& i : items)
        if (i == item) return true;
    return false;
}
string concat(const vector<string>& words)
{
    auto result = string("");
    for (auto const& word : words)
        result.append(word);
    return result;
}
vector<string> split_2(const string& text, const vector<char>& chars)
{
    auto textLenght = text.length();
    auto words = vector<string>();
    if (textLenght == 0) return words;
    auto curentWord = string();
    auto textPtr = text.data();
    for (size_t i = 0; i < text.length(); i++)
    {
        auto char_ = textPtr[i];
        if (contains(chars,char_))
        {
            words.push_back(curentWord);
            curentWord.clear();
        }
        else
        {
            curentWord.push_back(char_);
        }
    }
    words.push_back(curentWord);
    return words;
}
string to_camel_case(string text)
{
    auto chars = vector<char> { '-','_' };
    auto words = split_2(text,chars);
    for (size_t i = 1; i < words.size(); i++)
    {
        string& word = words[i];
        if (word.size() == 0) continue;
        word[0] = (char)toupper(word[0]);
    }
    return concat(words);
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