#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

using namespace std;

int fallback = 0;

struct Node
{
    int value;
    Node* left;
    Node* right;
};
Node* InsertLevelOrder(int nodeCountTarget, int nodeIndex)
{
    if (nodeCountTarget <= nodeIndex) return nullptr;

    auto node = new Node();
    node->value = nodeIndex;

    node->left = InsertLevelOrder(nodeCountTarget,2*nodeIndex+1);
    node->right = InsertLevelOrder(nodeCountTarget,2*nodeIndex+2);

    return node;
}
Node* CreateTree(int nodeCount)
{
    return InsertLevelOrder(nodeCount,0);
}
void CountLevelsRec(const Node* node, int curentLevel, int* maxLevel)
{
    if (node == nullptr) return;
    curentLevel++;
    if (*maxLevel < curentLevel)
        *maxLevel = curentLevel;
    CountLevelsRec(node->left,curentLevel,maxLevel);
    CountLevelsRec(node->right,curentLevel,maxLevel);
}
int CountLevels(const Node* node)
{
    int maxLevel = 0;
    CountLevelsRec(node,0,&maxLevel);
    return maxLevel;
}
void PrintRec(const Node* node, int level, int levelToPrint)
{
    if (node == nullptr) return;
    if (level == levelToPrint)
    {
        cout << node->value << ',';
        return;
    }
    level++;
    PrintRec(node->left,level,levelToPrint);
    PrintRec(node->right,level,levelToPrint);
}
void Print(const Node* node)
{
    auto levelCount = CountLevels(node);
    for (int i = 0; i < levelCount; i++)
    {
        PrintRec(node,0,i);
        cout << endl;
    }
    cout << "----------------" << endl;
}
void CreatePathInOrderRec(Node* node, vector<Node*>& outPath)
{
    if (node == nullptr) return;
    CreatePathInOrderRec(node->left,outPath);
    outPath.push_back(node);
    CreatePathInOrderRec(node->right,outPath);
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
vector<Node*> CreatePathInOrder(Node* root)
{
    auto result = vector<Node*>();
    CreatePathInOrderRec(root,result);
    return result;
}
vector<Node*> CreatePathBreathFirst(Node* root)
{
    auto outPath = vector<Node*>();
    queue<Node*> nodes {};
    nodes.push(root);
    while (!nodes.empty())
    {
        auto nextNode = nodes.front();
        if (nextNode->left != nullptr) nodes.push(nextNode->left);
        if (nextNode->right != nullptr) nodes.push(nextNode->right);
        outPath.push_back(nextNode);
        nodes.pop();
    }
    return outPath;
}
Node* FindParent(Node* root, Node* target)
{
    auto path = CreatePathBreathFirst(root);

    for (auto item : path)
    {
        if (item->left == target) return item->left;
        if (item->right == target) return item->right;
    }

    return nullptr;
}
void SwapValues(Node* node1, Node* node2)
{
    auto temp = node1->value;
    node1->value = node2->value;
    node2->value = temp;
}
void FixTree(Node* root)
{
    { fallback++; if (fallback > 1000) { cout << "RECURSION. FixTree" << endl; return; }; }

    {
        auto child = root->left;
        if (child != nullptr)
        {
            FixTree(child);
            if (root->value < child->value)
                SwapValues(root,child);
        }
    }
    {
        auto child = root->right;
        if (child != nullptr)
        {
            FixTree(child);
            if (root->value > child->value)
                SwapValues(root,child);
        }
    }
}
Node* Add(Node* root, int value)
{
    auto path = CreatePathBreathFirst(root);

    auto newNode = new Node();
    newNode->value = value;

    for (auto& item : path)
    {
        if (item->left == nullptr)
        {
            item->left = newNode;
            break;
        }
        if (item->right == nullptr)
        {
            item->right = newNode;
            break;
        }
    }

    return newNode;
}
vector<int> Solution(vector<int>& input)
{
    auto result = vector<int>();

    auto size = static_cast<int>(input.size());
    if (size == 0) return result;

    // sort(input.begin(),input.end());

    auto root = CreateTree(size);

    auto path1 = CreatePathInOrder(root);
    for (int i = 0; i < size; i++)
        path1[i]->value = input[i];


    auto path2 = CreatePathBreathFirst(root);
    for (int i = 0; i < size; i++)
        result.push_back(path2[i]->value);

    return result;
}
int main()
{
    // auto input = vector<int> { 1,2,3,4,5,6,7,8,9,10 };
    auto input = vector<int> { 1, 2, 2, 6, 7, 5 };
    auto output = Solution(input);
    Print(input);
    Print(output);

    return 0;
}