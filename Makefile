ifndef CROSS_COMPILE
CROSS_COMPILE = or32-uclinux-
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
NM = $(CROSS_COMPILE)nm
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
endif

SREC2MIF = ./srec2mif.pl
SREC2RTL = ./srec2rtl.pl

export	CROSS_COMPILE

.SUFFIXES: .or32

all: hello.or32

reset.o: reset.S Makefile board.h
	$(CC) -g -c -o $@ $< $(CFLAGS) -Wa,-alnds=$*.log

hello.o: hello.c Makefile board.h
	$(CC) -g -c -o $@ $< $(CFLAGS) -Wa,-alnds=$*.log

hello.or32: reset.o hello.o Makefile
	$(LD) -Tram.ld -o $@ reset.o hello.o $(LIBS)
	$(OBJCOPY) -O srec $@ $*.srec
	$(OBJCOPY) -O ihex $@ $*.ihex
	$(OBJDUMP) -S $@ > $*.S
	$(SREC2MIF) $*.srec
	$(SREC2RTL) $*.srec

System.map: hello.or32
	@$(NM) $< | \
		grep -v '\(compiled\)\|\(\.o$$\)\|\( [aUw] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)' | \
		sort > System.map

#########################################################################
clean:
	find . -type f \
		\( -name 'core' -o -name '*.bak' -o -name '*~' \
		-o -name '*.o'  -o -name '*.a' -o -name '*.tmp' \
		-o -name '*.or32' -o -name '*.bin' -o -name '*.srec' -o -name '*.ihex' \
		-o -name '*.mem' -o -name '*.img' -o -name '*.out' \
		-o -name '*.aux' -o -name '*.log' \) -print \
		| xargs rm -f
	rm -f System.map
	rm -f onchip_ram_bank?.mif
	rm -f onchip_ram_bank?.v
	rm -f hello.S

distclean: clean
	find . -type f \
		\( -name .depend -o -name '*.srec' -o -name '*.bin' \
		-o -name '*.pdf' \) \
		-print | xargs rm -f
	rm -f $(OBJS) *.bak tags TAGS
	rm -fr *.*~


