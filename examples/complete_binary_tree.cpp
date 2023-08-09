#include <iostream>
#include <vector>
#include <stack>

using namespace std;

void print_array(const vector<int> array)
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
}
vector<int> create_path_in_order(int size)
{
    auto result = vector<int>();
    auto history = stack<int>();
    auto curentIndex = 0;
    while (true)
    {
        if (curentIndex < size)
        {
            history.push(curentIndex);
            curentIndex = 2*curentIndex+1;
        }
        else
        {
            if (history.empty()) break;
            auto index = history.top(); history.pop();
            result.push_back(index);
            curentIndex = 2*index+2;
        }
    }
    return result;
}
vector<int> complete_binary_tree(const vector<int>& input)
{
    auto size = input.size();
    auto result = vector<int>(size);
    auto path = create_path_in_order(size);
    for (size_t i = 0; i < size; i++)
        result[path[i]] = input[i];
    return result;
}
void test_1()
{
    cout << "test_1" << endl;
    auto input = vector<int> {1,2,3,4,5,6,7,8,9,10};
    auto expected = vector<int> {7,4,9,2,6,8,10,1,3,5};
    auto output = complete_binary_tree(input);
    cout << "input    : "; print_array(input);    cout << endl;
    cout << "expected : "; print_array(expected); cout << endl;
    cout << "output   : "; print_array(output);   cout << endl;
    cout << endl;
}
void test_2()
{
    cout << "test_2" << endl;
    auto input = vector<int> {1,2,2,6,7,5};
    auto expected = vector<int> {6,2,5,1,2,7};
    auto output = complete_binary_tree(input);
    cout << "input    : "; print_array(input);    cout << endl;
    cout << "expected : "; print_array(expected); cout << endl;
    cout << "output   : "; print_array(output);   cout << endl;
    cout << endl;
}
int main()
{
    test_1();
    test_2();
    return 0;
}