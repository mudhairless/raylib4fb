CC := gcc
COPTS :=
FBCC := fbc

all : ../lib/lin64/libraygui.a ../lib/lin64/librlgl.a ../lib/lin64/librres.a ../lib/lin64/librres-raylib.a

../lib/lin64/libraygui.a : raygui.o
	@$(FBCC) -lib raygui.o -x ../lib/lin64/libraygui.a

../lib/lin64/librlgl.a : rlgl.o
	@$(FBCC) -lib rlgl.o -x ../lib/lin64/librlgl.a

../lib/lin64/librres.a : rres.o
	@$(FBCC) -lib rres.o -x ../lib/lin64/librres.a

../lib/lin64/librres-raylib.a : rres-raylib.o
	@$(FBCC) -lib rres-raylib.o -x ../lib/lin64/librres-raylib.a

%.o : %.c
	@$(CC) $(COPTS) -c $<

.PHONY clean : clean-objects clean-libraries

clean-objects :
	@-rm *.o

clean-libraries :
	@-rm ../lib/lin64/libraygui.a ../lib/lin64/librlgl.a ../lib/lin64/librres.a ../lib/lin64/librres-raylib.a
