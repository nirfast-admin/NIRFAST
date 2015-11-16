#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>

#include <CGAL/Mesh_triangulation_3.h>
#include <CGAL/Mesh_complex_3_in_triangulation_3.h>
#include <CGAL/Mesh_criteria_3.h>
#include <CGAL/Mesh_constant_domain_field_3.h>

#include <CGAL/Labeled_image_mesh_domain_3.h>
#include <CGAL/make_mesh_3.h>
#include <CGAL/Image_3.h>

// Domain
typedef CGAL::Exact_predicates_inexact_constructions_kernel K;
typedef CGAL::Labeled_image_mesh_domain_3<CGAL::Image_3,K> Mesh_domain;

// Triangulation
typedef CGAL::Mesh_triangulation_3<Mesh_domain>::type Tr;
typedef CGAL::Mesh_complex_3_in_triangulation_3<Tr> C3t3;

// Criteria
typedef CGAL::Mesh_criteria_3<Tr> Mesh_criteria;
typedef CGAL::Mesh_constant_domain_field_3<Mesh_domain::R,
                                           Mesh_domain::Index> Sizing_field;

// To avoid verbose function and named parameters call
using namespace CGAL::parameters;

// Usage: image2mesh_cgal inputstack.inr criteria.txt
// criterial.txt is a text file containing setting for mesh sizes and refirement options.

int main(int argc, char *argv[])
{
	// Loads image
	CGAL::Image_3 image;
	std::string cfn, inrfn, outfn;
	double facet_angle=25, facet_size=2, facet_distance=1.5,
	       cell_radius_edge=2, general_cell_size=2;
	double special_size = 0.9; // Cell size to be used in subdomains of image with 'special_subdomain_label'
	int special_subdomain_label = 0; // If this is set to zero, no subdomain resizing will be performed
	int volume_dimension = 3;
	
	bool defulatcriteria = false;
	
	if (argc == 1) {
		std::cout << " Enter the image stack file name (.inr): ";
		std::cin >> inrfn;
		defulatcriteria = true;
		std::cout << " (Using default settings for meshing parameters!)\n";
	}
	else if (argc==2) {
		inrfn = argv[1];
		defulatcriteria = true;
	}
	else if (argc >= 3) {
		inrfn = argv[1];
		cfn = argv[2];
	}
	if (!defulatcriteria) {
		std::ifstream cfs(cfn.c_str());
		if (!cfs) {
			std::cerr << " Can not read mesh criteria file!\n";
			exit(-1);
		}
		cfs >> facet_angle;
		cfs >> facet_size;
		cfs >> facet_distance;
		cfs >> cell_radius_edge;
		cfs >> general_cell_size;
		cfs >> special_subdomain_label;
		cfs >> special_size;
		/*std::cout << facet_angle << std::endl <<
					 facet_size << std::endl <<
					 facet_distance << std::endl <<
					 cell_radius_edge << std::endl <<
					 general_cell_size << std::endl <<
					 special_subdomain_label << std::endl <<
					special_size << std::endl;*/
	}
	if (argc >= 4)
		outfn = argv[3];
	else
		outfn = "_tmp_image2mesh_cgal.mesh";
		
	image.read(inrfn.c_str());

	// Domain
	Mesh_domain domain(image);

	// Sizing field: set global size to general_cell_size
	// and special size (label special_subdomain_label) to special_size
	Sizing_field size(general_cell_size);
	if (special_subdomain_label) {
		std::cout << " Refining domain with label ID: " << special_subdomain_label << std::endl;
		size.set_size(special_size, volume_dimension, 
		              domain.index_from_subdomain_index(special_subdomain_label));
	}

	// Mesh criteria
	Mesh_criteria criteria(facet_angle, facet_size, facet_distance,
	                       cell_radius_edge, cell_size=size);

	// Meshing
	C3t3 c3t3 = CGAL::make_mesh_3<C3t3>(domain, criteria);

	// Output
	std::ofstream medit_file(outfn.c_str());
	c3t3.output_to_medit(medit_file);

	return 0;
}
