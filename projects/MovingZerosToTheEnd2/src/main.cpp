#include "base.h"

void print_array(const vector<int>& array)
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
vector<int> move_zeroes(const vector<int>& input)
{
    vector<int> result = input;
    stable_partition(result.begin(), result.end(), [] (auto x) { return x; });
    return result;
}
int main(void)
{
    auto vec1 = vector<int> { 1, 0, 1, 2, 0, 1, 3 };
    auto vec2 = move_zeroes(vec1);
    print_array(vec1); cout << endl;
    print_array(vec2); cout << endl;
    return 0;
}