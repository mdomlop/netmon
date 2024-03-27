OPTI_STATIC_CFLAGS := $(OPTI_CFLAGS) -static
OPTI_STATIC_LDLIBS := $(LDLIBS)
OPTI_STATIC_FLAGS := $(OPTI_STATIC_CFLAGS) $(OPTI_STATIC_LDLIBS)

OPTI_STATIC_ELFS = $(addsuffix .opti_static_elf,$(BINARIES))

opti_static: $(OPTI_STATIC_ELFS)
%.opti_static_elf: source/%.c
	$(CC) $^ -o $@ $(OPTI_STATIC_FLAGS)


clean_opti_static:
	rm -f $(OPTI_STATIC_ELFS)
