#include "BSPNode.h"

BSPNode::BSPNode() : nodeid(0), leaf(false), numpolys(0)
{
	myplane.x = 0.;
	myplane.y = 0.;
	myplane.z = 0.;
}

BSPNode::~BSPNode()
{
}

BSPNode::BSPNode(BSPNode *front, BSPNode *back, Plane3D& pplane, unsigned long depth) {
	this->leaf = false;
	this->myplane = pplane;
	this->frontnode = front;
	this->backnode  = back;
	this->solid = false;
	this->nodeid = depth;
}

BSPNode::BSPNode(int label) {
	this->leaf = true;
	this->solid = (label == BSPNode::OUT) ? false : true;
}

BSPNode& BSPNode::operator =(const BSPNode &other) {
	if (this != &other) {
		this->CopyFrom(other);
	}
	return *this;
}
BSPNode::BSPNode(const BSPNode& other) {
	this->CopyFrom(other);
}
void BSPNode::CopyFrom(const BSPNode &other) {
	this->backnode = other.backnode;
	this->frontnode = other.frontnode;
	this->leaf = other.IsLeaf();
	this->myplane = other.myplane;
	this->nodeid = other.nodeid;
	this->numpolys = other.NumOfPolygons();
	this->bspnodePolygons = other.bspnodePolygons;
}
