
libezshare:
	gcc -c udpbroadcast.c
	gcc -c gui.c
	gcc -shared -o ezshare.dll gui.o udpbroadcast.o -Wl,--out-implib,libezshare.a -lcomdlg32 -lws2_32

all: libezshare
	gcc -o ezshare ezshare.c -I../LuaJit-2.0.0/src -L. -lcyglua51  -mwindows 


