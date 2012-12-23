
hi:
	gcc -c save_hi.c 
	gcc -shared -o save_hi.dll save_hi.o
	gcc -o test_hi test_hi.c -L./ -lsave_hi -I../LuaJit-2.0.0/src ./cyglua51.dll

win:
	gcc -o test_win test_win.c -I../LuaJit-2.0.0/src ./cyglua51.dll

hi2: 
	gcc -c save_hi.c 
	gcc -shared -o cygsave_hi.dll \
	-Wl,--out-implib=libsave_hi.dll.a \
	-Wl,--export-all-symbols \
	-Wl,--enable-auto-import \
	-Wl,--whole-archive save_hi.o
