#include "Graph.h"
#include "stdafx.h"

//****************************************************************************//

void Graph::clearGraph()
{
    this->nodes.clear();
    this->leaves.clear();
    this->roots.clear();
}

//****************************************************************************//

Node* Graph::insertNode(Node & node)
{
    // since graph is map, conflict will relpace the original
    std::pair<string, Node> graphInsertPair = {node.name, node};
    std::pair<std::unordered_map<string, Node>::iterator , bool> graphInsertRes = 
            this->nodes.insert(graphInsertPair);
    return(& graphInsertRes.first->second);
}

//****************************************************************************//

void Graph::printToFile(ofstream & outFile, bool leavesAndRoots)
{
    for(auto const &node : this->nodes)
    { 

        outFile << node.first << ' ' << node.second.name << endl;
        outFile << "    Op: " << node.second.op << endl;
        outFile << "    Children: " << node.second.children.size() << endl;
        for(auto const &child : node.second.children)
            outFile << child->name << ' ';
        outFile << "\n    Parents: " << node.second.parents.size() << endl;
        for(auto const &parent : node.second.parents)
            outFile << parent->name << ' ';
        outFile << endl << "   matName: " << node.second.matName;
        outFile << endl << "   Storage: ";
            if(node.second.matPointer)
            {
                outFile << node.second.matPointer->name;
            }
            else
            {
                outFile << "NULL";
            };
        outFile << endl << "   Storage Index: " << node.second.memMapIndex;
        outFile << endl << "   level: " << node.second.level << endl;
        outFile << endl;
    }
    if(leavesAndRoots)
    {
        outFile << "Leaves: " << this->leaves.size() << endl;
        for(auto node : this->leaves)
            outFile << node->name << ' ';
        outFile << endl << "Roots: " << this->roots.size() << endl;
        for(auto node : this->roots)
            outFile << node->name << ' ';
        outFile << endl;
    }
}


//****************************************************************************//

void Graph::findLeavesAndRoots()
{
    // clear previous nodes
    this->leaves.clear();
    this->roots.clear();
    for(auto node = this->nodes.begin(); node!= this->nodes.end(); node++)
    {
        if(int(node->second.children.size()) == 0)
            this->leaves.push_back(& node->second);
        if(int(node->second.parents.size()) == 0)
            this->roots.push_back(& node->second);
    }
}

//****************************************************************************//

bool removeType(pair<string, Node> nodePair)
{
    // If node is pass type
    if(nodePair.second.op == "pass") return true;
    // Future adds
    // If multiplier or divider node operand 1
    // Add or Sub had 0 operand
    return false;
}

//****************************************************************************//

void Graph::removeUselessNodes()
{
    #ifdef PRINT_DEBUG_0
    debugFile << "Remove Status of nodes" << endl;
    string dotFileName;
    #endif

    vector<Node *>::iterator vecIt;

    for(auto it = this->nodes.begin(); it != this->nodes.end();)
    {
        #ifdef PRINT_DEBUG_1
        debugFile << setw(15) << left << it->first << ' ' << setw(5) << left << it->second.op << ' ' << removeType(*it) << endl;
        string dotFileName = "exeTree_" + it->first;;
        #endif

        if(removeType(*it)) //If a mac_sub node has no multiply terms, that mac_sub node is useless
        {
            // for each parent
            for(auto parent : it->second.parents)
            {
                // replacing the useless child node of that parent with the child of that useless child node(Note that a useless node will have only one child node)
                vecIt = std::find(parent->children.begin(), parent->children.end(), &(it->second));
                *vecIt = it->second.children[0];
            }
            // for each child, (only one child in current config)
            for(auto child : it->second.children) //Although for loop is used, it's not necessary as size of it->second.children is 1
            {
                // remove node from parent's child's list
                child->parents.erase(std::remove(child->parents.begin(), child->parents.end(), &(it->second)), child->parents.end());
                // connect children nodes to parent
                child->parents.insert(child->parents.end(), it->second.parents.begin(), it->second.parents.end());
                // pass memory information to children
                child->store = it->second.store | child->store;
                if(it->second.store == true && child->store == false) //This case can never occur as apparent from the line above the if statement
                {
                    child->matPointer = it->second.matPointer;
                    child->memMapIndex = it->second.memMapIndex;
                }
                else if(it->second.store & child->store)
                {
                    //The child node will always be of type 'A_'
                    this->musthaveSameMemLoc.push_back(std::make_tuple(it->second.matPointer, it->second.memMapIndex, child->matPointer, child->memMapIndex));
                }
                else{
                    //These are the nodes that start with name 'mac_sub'. These node have a division('/') node as a parent node which calculates an element of L matrix.
                    //'store' parameter of these nodes is false. Hence no need to save them and can be safely removed.
                }
            }
            // delete node from Graph
            this->nodes.erase(it++);
            #ifdef PRINT_DEBUG_2
            // this->printToFile(debugFile);
            convertDotToPng(dotFileName);
            #endif
        }
        else
        { ++it;}
    }
}

//****************************************************************************//

void convertDotToPng(string dotFileName)
{
    int retVal;
    cout << "Checking if processor is available...";
    if(system(NULL)) puts("ok");
    else exit(EXIT_FAILURE);
    cout << endl << "Compiling .dot file.." << endl;
    retVal = system(("/usr/bin/dot -Tsvg " + dotFileName + ".dot -o " + dotFileName + ".svg").c_str());
    cout << "The value returned was: " << retVal << endl;
}

//****************************************************************************//


bool assignLevels_unready(const Node * x)
{
    for(auto & child: x->children)
    {
        if(child->level == levelNULL)
            return true;
    }
    return false;
}

void Graph::assignLevelsAndIds()
{
    vector<Node *> parents, currLevelNodes;
    int currLevel = 0;
    int nodeId = nodeIdStart; // 'nodeIdStart' is specified in stdafx.h

    parents = this->leaves;

    while(parents.size() > 0)
    {
        #ifdef PRINT_DEBUG_2
        debugFile << "currLevel: "<< currLevel << endl;
        for(auto node : parents)
            debugFile << node->name << " | ";
        debugFile << endl;
        #endif

        currLevelNodes = parents;
        parents.clear();
        // assign level and list all the parents
        for(auto n : currLevelNodes)
        {
            n->level = currLevel;
            if(n->name == "0") //node with op = "const"
            {
                n->nodeId = 0;
            }
            else
            {
                n->nodeId = nodeId ++;
            }
            parents.insert(parents.end(), n->parents.begin(), n->parents.end());
        }

        // remove repeated entries(as same nodes can have multiple children, repeated entries can be there)
        sort( parents.begin(), parents.end() );
        parents.erase( unique( parents.begin(), parents.end() ), parents.end() );
        // remove parents with unassigned children
        //Its possible that a node has multiple children and all children are not a same level. In that case a few children node might still have unassigned level
        parents.erase(std::remove_if(
            parents.begin(), parents.end(),
            assignLevels_unready),
            parents.end());
        currLevel++ ;
        this->levels.push_back(currLevelNodes);

    }
    this->maxLevel = currLevel - 1;
}


//****************************************************************************//

void Graph::executeGraphUsingLevels(string const dotFileName)
{
    //vector<Node *> readyNodes;
    // Node* currNode;
    f_type tmpVar;
    // bool ready = false;
    //readyNodes = this->leaves;
    int i;
    // // make all nodes not ready from previous operation

    // for(auto node = this->nodes.begin(); node != this->nodes.end(); node++)
    //     node->second.ready = false;

    #ifdef MAKE_GRAPH
    ofstream dotFile(dotFileName + ".dot");
    dotFile << "digraph tree {\n graph [dpi = " << GRAPH_DPI << "]" << endl;
    #endif
    
    // change level starting to 1
    for(int level = 0; level <= this->maxLevel; level++)
    {
        for(auto currNode : this->levels[level])
        {
            // find value for the node
            if(currNode->op == "*")
            {
                currNode->val = currNode->children[0]->val * currNode->children[1]->val;
            }
            else if(currNode->op == "/")
            {
                currNode->val = currNode->children[0]->val / currNode->children[1]->val;
            }
            else if(currNode->op == "+")
            {
                currNode->val = currNode->children[0]->val + currNode->children[1]->val;
            }
            else if(currNode->op == "-")
            {
                currNode->val = currNode->children[0]->val - currNode->children[1]->val;
            }
            else if(currNode->op == "mac_add")
            {
                tmpVar = currNode->children[0]->val;
                for(i = 1; i < currNode->children.size(); i+=2)
                    tmpVar += currNode->children[i]->val * currNode->children[i+1]->val;
                currNode->val = tmpVar;
            }
            else if(currNode->op == "mac_sub")
            {
                //cout.precision(17);
                tmpVar = currNode->children[0]->val;
                for(i = 1; i < currNode->children.size(); i+=2){
                    tmpVar -= currNode->children[i]->val * currNode->children[i+1]->val;
                }
                currNode->val = tmpVar;
            }
            else if(currNode->op == "pass")
            {
                currNode->val = currNode->children[0]->val;
            }
            else if(currNode->op == "rd") {}
            else if(currNode->op == "wr") {}
            else if(currNode->op == "const") {}
            else
            {
                cout << "Error: Unknown operation " << currNode->op << endl;
                exit(0);
            }
            
            #ifdef MAKE_GRAPH
            // create node
            dotFile << currNode->name << " [ label = \"" << currNode->name << 
                ';' << currNode->op << ';' << currNode->nodeId << "\n" << currNode->level << 
                ';' << currNode->priority <<"\"];" << endl;
            // connect children
            for(auto child : currNode->children)
            {
                dotFile << child->name << " -> " << currNode->name << " [ label = \"" 
                        << child->val << "\" ];" << endl;
                // dotFile << child->name << " -> " << currNode->name << ";" << endl;
            }
            #endif

        }

        #ifdef PRINT_DEBUG_1
        debugFile << "Ready nodes" << endl;
        for(auto rNode : this->levels[level])
            debugFile << rNode->name << ' ';
        debugFile << endl;
        #endif
    }

    #ifdef MAKE_GRAPH
    dotFile << "dummy [label = \"dummy\"];" << endl;
    for(auto rNode : this->roots)
    {
        dotFile << rNode->name << " -> dummy [ label = \"" << rNode->val << "\"];" << endl;
    }
    dotFile << "}" << endl;
    dotFile.close();
    #endif
}

//****************************************************************************//
