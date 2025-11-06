gcc -m32 -c raygui.c
fbc32 -lib raygui.o -x libraygui.32.a

gcc -c raygui.c
fbc64 -lib raygui.o -x libraygui.64.a

echo RayGui is built, copy the static libs to the appropriate directory and remove the bit indicator from the extensions