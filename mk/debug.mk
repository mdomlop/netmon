DEBUG_CFLAGS := -Wall -ggdb3
DEBUG_LDLIBS := $(LDLIBS)
DEBUG_FLAGS := $(DEBUG_CFLAGS) $(DEBUG_LDLIBS)

DEBUG_ELFS = $(addsuffix .debug_elf,$(BINARIES))

debug: $(DEBUG_ELFS)
%.debug_elf: source/%.c
	$(CC) $^ -o $@ $(DEBUG_FLAGS)


clean_debug:
	rm -f $(DEBUG_ELFS)
