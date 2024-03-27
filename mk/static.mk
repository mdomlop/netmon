STATIC_CFLAGS := $(CFLAGS) -static
STATIC_LDLIBS := $(LDLIBS)
STATIC_FLAGS := $(STATIC_CFLAGS) $(STATIC_LDLIBS)

STATIC_ELFS = $(addsuffix .static_elf,$(BINARIES))

static: $(STATIC_ELFS)
%.static_elf: source/%.c
	$(CC) $^ -o $@ $(STATIC_FLAGS)


clean_static:
	rm -f $(STATIC_ELFS)
