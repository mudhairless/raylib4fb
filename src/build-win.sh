gcc -m32 -c raygui.c
fbc32 -lib raygui.o -x libraygui.a
mv libraygui.a ../lib/win32

gcc -c raygui.c
fbc64 -lib raygui.o -x libraygui.a
mv libraygui.a ../lib/win64

gcc -m32 -c rlgl.c
fbc32 -lib rlgl.o -x librlgl.a
mv librlgl.a ../lib/win32

gcc -c rlgl.c
fbc64 -lib rlgl.o -x librlgl.a
mv librlgl.a ../lib/win64

gcc -m32 -c rres.c
fbc32 -lib rres.o -x librres.a
mv librres.a ../lib/win32

gcc -c rres.c
fbc64 -lib rres.o -x librres.a
mv librres.a ../lib/win64

gcc -m32 -c rres-raylib.c
fbc32 -lib rres-raylib.o -x librres-raylib.a
mv librres-raylib.a ../lib/win32

gcc -c rres-raylib.c
fbc64 -lib rres-raylib.o -x librres-raylib.a
mv librres-raylib.a ../lib/win64

echo RayGui, RLGL and RRES are built!