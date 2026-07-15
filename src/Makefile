CC := gcc
TARGET != $(CC) -dumpmachine
ifeq ($(DEBUG),1)
	COPTS := -g
	FBCCOPTS := -g
else
	COPTS := -O2 -march=native
	FBCCOPTS :=
endif

FBCC := fbc

all : dir-exists ../lib/$(TARGET)/libraygui.a ../lib/$(TARGET)/librlgl.a ../lib/$(TARGET)/librres.a ../lib/$(TARGET)/librres-raylib.a

.PHONY : dir-exists
dir-exists:
	@echo "Creating Library directory for $(TARGET)"
	@mkdir -p ../lib/$(TARGET)

../lib/$(TARGET)/libraygui.a : raygui.o
	@echo "Compiling RayGUI"
	@$(FBCC) -lib $(FBCCOPTS) raygui.o -x ../lib/$(TARGET)/libraygui.a

../lib/$(TARGET)/librlgl.a : rlgl.o
	@echo "Compiling RLGL"
	@$(FBCC) -lib $(FBCCOPTS) rlgl.o -x ../lib/$(TARGET)/librlgl.a

../lib/$(TARGET)/librres.a : rres.o
	@echo "Compiling Rres"
	@$(FBCC) -lib $(FBCCOPTS) rres.o -x ../lib/$(TARGET)/librres.a

../lib/$(TARGET)/librres-raylib.a : rres-raylib.o
	@echo "Compiling Rres-raylib"
	@$(FBCC) -lib $(FBCCOPTS) rres-raylib.o -x ../lib/$(TARGET)/librres-raylib.a

%.o : %.c
	$(CC) $(COPTS) -c $<

.PHONY : clean
clean : clean-objects clean-libraries

.PHONY : clean-objects
clean-objects :
	@echo "Removing Object Files"
	@-rm *.o

.PHONY : clean-libraries
clean-libraries :
	@echo "Removing Libraries"
	@-rm ../lib/$(TARGET)/libraygui.a ../lib/$(TARGET)/librlgl.a ../lib/$(TARGET)/librres.a ../lib/$(TARGET)/librres-raylib.a
