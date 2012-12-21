
all:
	gcc -mwindows -o tst -I../LuaJit-2.0.0/src test.c ./cyglua51.dll

