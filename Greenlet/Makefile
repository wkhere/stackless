CFLAGS = -fno-strict-aliasing -DNDEBUG -g -Wall -Wstrict-prototypes -fPIC
INCLUDE = -I/usr/local/include/python2.3

greenlet.so: greenlet.c
	gcc -shared $(CFLAGS) $(INCLUDE) -O2 -fno-omit-frame-pointer $^ -o $@
