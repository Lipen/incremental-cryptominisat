EXE = incremental-cryptominisat
SRC = incremental-cryptominisat.cpp
BINDIR = /usr/local/bin

CC = g++
CV = -std=gnu++11
OPTLVL = -O3
INCLUDE = -I/usr/local/include
LIBRARY = -L/usr/local/lib
CFLAGS = $(CV) -Wall -static $(OPTLVL) $(INCLUDE)
LDFLAGS = $(LIBRARY) -lcryptominisat5 -lm4ri -lpthread


all: $(EXE)

$(EXE):
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) -o $@

.PHONY: install
install:
	install -m 557 $(EXE) $(BINDIR)
	strip -S --strip-unneeded --remove-section=.note.gnu.gold-version --remove-section=.comment --remove-section=.note --remove-section=.note.gnu.build-id --remove-section=.note.ABI-tag $(BINDIR)/$(EXE)

.PHONY: uninstall
uninstall:
	rm $(BINDIR)/$(EXE)
