
win:
	gcc -o test_win test_win.c -I../LuaJit-2.0.0/src ./cyglua51.dll

hi: 
	gcc -c save_hi.c
	gcc -shared -o save_hi.dll save_hi.o -Wl,--out-implib,libsave_hi.a
	gcc -c test_hi.c -I../LuaJit-2.0.0/src 
	gcc -o test_hi.exe test_hi.o -L. -lcyglua51

udpbroadcast:
	gcc -c udpbroadcast.c
	gcc -shared -o udpbroadcast.dll udpbroadcast.o -Wl,--out-implib,libudpbroadcast.a -lws2_32
