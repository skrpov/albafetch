.PHONY: build/albafetch

SHELL := /bin/bash
CC := gcc
CFLAGS := -Wall
TARGET := albafetch
OBJ := info.o main.o queue.o
OBJ_OSX := macos_infos.o bsdwrap.o
SRC := src/info.c src/main.c src/queue.c
SRC_OSX := macos_infos.c bsdwrap.c

build/$(TARGET): $(OBJ)
	mkdir -p build
	cat /usr/bin/pacman >/dev/null 2>/dev/null && $(CC) -o build/$(TARGET) -l alpm $(OBJ) $(CFLAGS) || $(CC) -o build/$(TARGET) $(INCLUDE) $(OBJ) $(CFLAGS)

main.o: src/main.c src/config.h src/vars.h src/logos.h src/info.h
	$(CC) -c src/main.c

info.o: src/info.c src/config.h src/vars.h src/info.h
	cat /usr/bin/pacman >/dev/null 2>/dev/null && $(CC) -c src/info.c -D ARCH_BASED || $(CC) -c src/info.c

bsdwrap.o: src/bsdwrap.c
	$(CC) -c src/bsdwrap.c

macos_infos.o: src/macos_infos.c
	$(CC) -c src/macos_infos.c

queue.o: src/queue.c
	$(CC) -c src/queue.c

macos_gpu_string.o: src/macos_gpu_string.m
	-$(CC) -c src/macos_gpu_string.m -framework Foundation -framework IOKit

osx: $(OBJ) $(OBJ_OSX)
	mkdir -p build
	$(CC) -o build/$(TARGET) $(OBJ) $(OBJ_OSX) $(CFLAGS) -framework Foundation -framework IOKit

run: build/$(TARGET)
	build/$(TARGET)

install: build/$(TARGET)
	cp -f build/$(TARGET) $(DESTDIR)/usr/bin/$(TARGET)

uninstall:
	rm /usr/bin/$(TARGET)

test: test.c
	$(CC) -o build/test test.c && build/test

clean:
	-rm -rf build test *.o
