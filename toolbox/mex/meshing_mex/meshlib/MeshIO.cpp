#include "MeshIO.h"

MeshIO::MeshIO()
{
}

MeshIO::MeshIO(std::string& nodefn, std::string& elefn) {
	this->efn = elefn;
	this->nfn = nodefn;
}
MeshIO::~MeshIO()
{
}

// Reads a polyhedron from file and returns number of nodes per polygon
int MeshIO::ReadPolyhedron(std::vector<Point *> &nodes, std::vector<unsigned long> &ele) {
	if (this->nfn.empty() || this->efn.empty()) {
		std::cerr << "\n\tMeshIO: IO filenames are not set.\n";
		return -1;
	}
	CFileOperation myfile;
	std::ifstream ifs;
	std::string s, junk;

	// Read the node file
	myfile.OpenInFile(ifs, nfn, "text");
	myfile.GetLine(ifs, s);

	unsigned long nnodes = strtoul(myfile.GetArg(s, ' ').c_str(), NULL, 0);
	long dim = strtol(myfile.GetArg(s, ' ').c_str(), NULL, 0);
	unsigned long marker = strtoul(myfile.GetArg(s, ' ').c_str(), NULL, 0);

	for (unsigned long i=0; i< nnodes; ++i) {
		double x, y, z;
		myfile.GetLine(ifs, s);
		myfile.GetArg(s, ' '); // discard node numbering
		x = strtod(myfile.GetArg(s, ' ').c_str(), NULL);
		y = strtod(myfile.GetArg(s, ' ').c_str(), NULL);
		z = strtod(myfile.GetArg(s, ' ').c_str(), NULL);
		if (marker !=0) { // For now we ignore node markers.
			unsigned long junk = strtoul(myfile.GetArg(s, ' ').c_str(), NULL, 0);
		}
		nodes.push_back(new Point(x,y,z));
	}
	ifs.clear();
	ifs.close();

	// Read the element file
	myfile.OpenInFile(ifs, efn, "text");
	myfile.GetLine(ifs, s);

	unsigned long ne = strtoul(myfile.GetArg(s, ' ').c_str(), NULL, 0);
	int nnpe = atoi(myfile.GetArg(s, ' ').c_str());
	int natts = atoi(myfile.GetArg(s, ' ').c_str());

	for (unsigned long i=0; i<ne; ++i) {
		myfile.GetLine(ifs, s);
		myfile.GetArg(s, ' '); // discard element numbering
		for (int j=0; j<nnpe; ++j) {
			ele.push_back(strtoul(myfile.GetArg(s, ' ').c_str(), NULL, 0));
		}
		if (natts != 0) { // For now we ignore element attributes
			//
		}
	}
	return nnpe;
}
