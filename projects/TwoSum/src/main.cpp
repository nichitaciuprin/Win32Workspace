#include "base.h"

pair<size_t,size_t> two_sum(const vector<int>& numbers, int target)
{
    auto count = numbers.size();
    for (size_t i = 0; i < count; i++)
    for (size_t j = 1; j < count; j++)
    {
        auto sum = numbers[i] + numbers[j];
        if (sum == target)
            return pair<size_t,size_t>(i,j);
    }
    throw exception();
}
int main(void)
{
    return 0;
}