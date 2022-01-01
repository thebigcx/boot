SRC=mkboot.c
TARG=$(patsubst %.c, %, $(SRC))

.PHONY: all clean

all: $(TARG)

%: %.c
	gcc -o $@ $<

clean:
	rm $(TARG)
