#include "Plane3D.h"
#include "CPolygon.h"
#include "MeshIO.h"

#include <vector>

class BSPNode
{
public:
	BSPNode();
	BSPNode(BSPNode* front, BSPNode* backk, Plane3D& pplane, unsigned long depth);
	BSPNode(int label);
	BSPNode(const BSPNode& other);
	BSPNode& operator=(const BSPNode& other);
	void CopyFrom(const BSPNode& other);

	~BSPNode(void);

	enum SolidLeafLabel {IN, OUT};

	unsigned long nodeid;
	Plane3D myplane;
	std::vector<Polygon *> bspnodePolygons;
	BSPNode* backnode;
	BSPNode* frontnode;

	inline bool IsLeaf() const { return this->leaf; }
	inline bool IsSolid() const { return this->solid; }
	inline unsigned long NumOfPolygons() const { return leaf ? (bspnodePolygons.size()) : 0; } // Returns number of polygons in leaf node otherwise zero

private:
	bool leaf, solid;
	unsigned long numpolys;

};
