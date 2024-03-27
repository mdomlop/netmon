OPTI_CFLAGS := $(CFLAGS) -march=native -mtune=native -O3
OPTI_LDLIBS := $(LDLIBS)
OPTI_FLAGS := $(OPTI_CFLAGS) $(OPTI_LDLIBS)

OPTI_ELFS = $(addsuffix .opti_elf,$(BINARIES))

opti: $(OPTI_ELFS)
%.opti_elf: source/%.c
	$(CC) $^ -o $@ $(OPTI_FLAGS)


clean_opti:
	rm -f $(OPTI_ELFS)
