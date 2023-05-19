#!/bin/bash

FILE1=src/flexiblas_api.h
FILE2=src/flexiblas_api_standalone.c
SRC1="https://raw.githubusercontent.com/mpimd-csc/flexiblas/master/$FILE1.in"
SRC2="https://raw.githubusercontent.com/mpimd-csc/flexiblas/master/$FILE2"

curl -s $SRC1 | sed '/#cmakedefine/c\/* #undef INTEGER8 *\/' > $FILE1
curl -s $SRC2 > $FILE2
