#!/bin/bash

clear

cc -m32 -std=c99 -c main.c
nasm -f elf32 firstconst.s 
cc -m32 -g -o firstconst main.o firstconst.o

rm firstconst.o main.o
