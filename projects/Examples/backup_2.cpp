#include <iostream>
#include <vector>
#include <queue>
#include <stack>
#include <algorithm>

using namespace std;

struct Node
{
    int value;
    Node* left;
    Node* right;
};

Node* CreateTree(int nodeCount)
{
    if (nodeCount == 0) return nullptr;

    auto nodes = vector<Node*> {};
    for (size_t i = 0; i < nodeCount; i++)
        nodes.push_back(new Node());

    for (size_t i = 0; i < nodeCount; i++)
    {
        auto node = nodes[i];
        auto childIndexLeft = 2*i+1;
        auto childIndexRight = 2*i+2;
        if (childIndexLeft < nodeCount) node->left = nodes[childIndexLeft];
        if (childIndexRight < nodeCount) node->right = nodes[childIndexRight];
    }

    return nodes[0];
}
vector<Node*> CreatePathInOrder(Node* root)
{
    auto result = vector<Node*>();
    auto history = stack<Node*>();
    history.push(root);
    auto curentNode = root;
    while (!history.empty())
    {
        if (curentNode == nullptr)
        {
            auto node = history.top(); history.pop();
            result.push_back(node);
            curentNode = node->right;
        }
        else
        {
            history.push(curentNode);
            curentNode = curentNode->left;
        }
    }
    return result;
}
vector<int> CreatePathInOrder(int size)
{
    auto result = vector<int>();
    auto history = stack<int>();
    history.push(0);
    auto curentIndex = 0;
    while (!history.empty())
    {
        if (curentIndex >= size)
        {
            auto node = history.top(); history.pop();
            result.push_back(node);
            curentIndex = 2*curentIndex+2;
        }
        else
        {
            history.push(curentIndex);
            curentIndex = 2*curentIndex+1;
        }
    }
    return result;
}
vector<Node*> CreatePathBreathFirst(Node* root)
{
    auto result = vector<Node*>();
    auto history = queue<Node*>();
    history.push(root);
    while (!history.empty())
    {
        auto nextNode = history.front();
        if (nextNode->left != nullptr) history.push(nextNode->left);
        if (nextNode->right != nullptr) history.push(nextNode->right);
        result.push_back(nextNode);
        history.pop();
    }
    return result;
}
std::vector<int> complete_binary_tree(const std::vector<int>& input)
{
    auto result = vector<int>();

    auto size = static_cast<int>(input.size());
    if (size == 0) return result;

    auto root = CreateTree(size);

    auto path1 = CreatePathInOrder(root);
    for (int i = 0; i < size; i++)
        path1[i]->value = input[i];

    auto path2 = CreatePathBreathFirst(root);
    for (int i = 0; i < size; i++)
        result.push_back(path2[i]->value);

    return result;
}
void Print(const vector<int> array)
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
int main()
{
    auto input = vector<int>{0,1,2,3,4,5};
    // auto input = vector<int>{1,2,2,6,7,5};
    // auto output = complete_binary_tree(input);
    auto output = CreatePathInOrder(input.size());
    // Print(input);
    // Print(output);
    return 0;
}