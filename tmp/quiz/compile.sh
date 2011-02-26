cc 34g.orig.c  -I/opt/local/var/macports/software/libsdl/1.2.14_9/opt/local/include\
	 -I/opt/local/var/macports/software/libsdl_gfx/2.0.22_0/opt/local/include \
	-I/opt/local/var/macports/software/libsdl/1.2.14_9/opt/local/include/SDL\
	 -L/opt/local/lib `sdl-config --libs` `sdl-config --cflags` -lSDL_gfx -g
