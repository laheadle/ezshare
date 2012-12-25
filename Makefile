
win:
	gcc -o test_win test_win.c -I../LuaJit-2.0.0/src ./cyglua51.dll

hi: 
	gcc -c save_hi.c
	gcc -shared -o save_hi.dll save_hi.o -Wl,--out-implib,libsave_hi.a
	gcc -c test_hi.c -I../LuaJit-2.0.0/src 
	gcc -o test_hi.exe test_hi.o -L. -lcyglua51

libezshare:
	gcc -c udpbroadcast.c
	gcc -c gui.c
	gcc -shared -o ezshare.dll gui.o udpbroadcast.o -Wl,--out-implib,libezshare.a -lcomdlg32 -lws2_32

gui: libezshare
	gcc -o ezshare ezshare.c -I../LuaJit-2.0.0/src -L. -lcyglua51  -mwindows 


