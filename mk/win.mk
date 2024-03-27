EXES = $(addsuffix .exe,$(BINARIES))

EXE_CC = x86_64-w64-mingw32-gcc

EXE_CFLAGS := $(CFLAGS) -Wno-format-zero-length
EXE_LDLIBS := $(LDLIBS)
#EXES = $(addsuffix .exe,$(addprefix source/,$(BINARIES)))
EXE_FLAGS := $(EXE_CFLAGS) $(EXE_LDLIBS)

exe: CC = $(EXE_CC)
exe: $(EXES)

%.exe: source/%.c
	$(CC) $< -o $@ $(EXE_FLAGS)

clean_exe:
	rm -f $(EXES)
