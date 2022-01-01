MBRSRC=src/mbr.s
MBROBJ=$(patsubst %.s, %.o, $(MBRSRC))

MBRTARG=dist/mbr.bin
MBRCFLAGS=-ffreestanding
MBRLDFLAGS=-Tmbr.ld --oformat binary

.PHONY: all clean scripts
all: $(MBRTARG) scripts

$(MBRTARG): $(MBROBJ)
	mkdir -p dist
	ld -o $@ $^ $(MBRLDFLAGS)

%.o: %.s
	gcc $(MBRCFLAGS) -o $@ -c $<

clean:
	rm $(MBROBJ) $(MBRTARG)
	rmdir dist
	@$(MAKE) -C scripts clean

scripts:
	@$(MAKE) -C scripts
