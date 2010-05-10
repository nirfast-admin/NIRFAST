#
## a cylinder
#
algebraic3d

# cut cylinder by planes:

solid cyl = cylinder ( 0, 0, -50; 0, 0, 50; 43 );
solid a = cyl
	and plane (0, 0, -30; 0, 0, -1)
	and plane (0, 0, 30; 0, 0, 1);
tlo a;
