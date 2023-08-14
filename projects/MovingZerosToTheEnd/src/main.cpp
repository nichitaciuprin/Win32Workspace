#include "base.h"

vector<int> move_zeroes(const vector<int>& input)
{
    auto result = vector<int>(input.size(), 0);
    auto resultIndex = 0;
    for (auto& number : input)
    {
        if (number == 0) continue;
        result[resultIndex] = number;
        resultIndex++;
    }
    return result;
}
int main(void)
{
    auto vec1 = vector<int> { 1, 0, 1, 2, 0, 1, 3 };
    return 0;
}