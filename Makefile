VERSION = $(shell git describe)
CPPFLAGS += -DVERSION=\"$(VERSION)\" -DYABAR_RANDR -D_POSIX_C_SOURCE=199309L
CFLAGS += -std=c99 -pedantic -Wall -O2 `pkg-config --cflags pango pangocairo libconfig`
INCLDS := -I.
LDLIBS := -lxcb -lpthread -lxcb-randr `pkg-config --libs pango pangocairo libconfig`
PROGRAM := yabar
PREFIX ?= /usr
BINPREFIX ?= $(PREFIX)/bin
MANPREFIX ?= $(PREFIX)/share/man

OBJS := $(wildcard src/*.c)
OBJS := $(OBJS:.c=.o)

%.o: %.c %.h
	$(CC) $(CFLAGS) -c -o $@ $<
all: $(PROGRAM)
$(PROGRAM): $(OBJS)
	$(CC) -o $@ $^ $(LDLIBS)
install:
	mkdir -p "$(DESTDIR)$(BINPREFIX)"
	cp -pf $(PROGRAM) "$(DESTDIR)$(BINPREFIX)"
	mkdir -p "$(DESTDIR)$(MANPREFIX)"/man1
	cp -pf doc/yabar.1 "$(DESTDIR)$(MANPREFIX)"/man1
uninstall:
	rm -f "$(DESTDIR)$(BINPREFIX)/$(PROGRAM)"
	rm -f "$(DESTDIR)$(MANPREFIX)"/man1/yabar.1
clean:
	rm -f src/*.o $(PROGRAM)

.PHONY: all install uninstall clean
