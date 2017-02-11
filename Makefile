CC = sdcc
ASM = sdasz80
PLATFORM = -mz80
EMULATOR = openmsx -machine msx1 -carta
HEXBIN = makebin -s 65536

STARTUPDIR = startups
INCLUDEDIR = includes
LIBDIR = libs
SRCDIR = src

CRT0 = crt0msx.32k.4000.s
ADDR_CODE = 0x4020
ADDR_DATA = 0xC000

#VERBOSE = -V
CCFLAGS = $(VERBOSE) $(PLATFORM) --code-loc $(ADDR_CODE) --data-loc $(ADDR_DATA) \
			--no-std-crt0 --out-fmt-ihx --opt-code-size
OBJECTS = $(CRT0)
SOURCES = main.c
OUTFILE = test.rom

.PHONY: all compile build clean emulator

all: clean compile build

compile: $(OBJECTS) $(SOURCES)

$(CRT0): 
	@echo "Compiling $(CRT0)"
	@$(ASM) -o $(notdir $(@:.s=.rel)) $(STARTUPDIR)/$(CRT0)
%.s:
	@echo "Compiling $@"
	@[ -f $(LIBDIR)/$@ ] && $(ASM) -o $(notdir $(@:.s=.rel)) $(LIBDIR)/$@ || true
	@[ -f $(SRCDIR)/$@ ] && $(ASM) -o $(notdir $(@:.s=.rel)) $(SRCDIR)/$@ || true
%.c:
	@echo "Compiling $@"
	@[ -f $(LIBDIR)/$@ ] && $(CC) $(VERBOSE) $(PLATFORM) -I$(INCLUDEDIR) -c -o $(notdir $(@:.c=.rel)) $(LIBDIR)/$@ || true
	@[ -f $(SRCDIR)/$@ ] && $(CC) $(VERBOSE) $(PLATFORM) -I$(INCLUDEDIR) -c -o $(notdir $(@:.c=.rel)) $(SRCDIR)/$@ || true

$(SOURCES):
	$(CC) -I$(INCLUDEDIR) $(CCFLAGS) \
			$(addsuffix .rel, $(basename $(notdir $(OBJECTS)))) \
			$(SRCDIR)/$(SOURCES)

build: main.ihx
	@echo "Building $(OUTFILE)..."
	@$(HEXBIN) main.ihx $(OUTFILE).tmp
	@dd skip=16384 count=32768 if=$(OUTFILE).tmp of=$(OUTFILE) bs=1 status=none
	@rm $(OUTFILE).tmp
	@echo "Done."

clean:
	@echo "Cleaning..."
	@rm -f $(OUTFILE) *.asm *.bin *.cdb *.ihx *.lk *.lst *.map *.mem *.omf *.rst *.rel *.sym *.noi *.hex *.lnk *.dep

emulator: $(OUTFILE)
	$(EMULATOR) $(OUTFILE) &
