## New submission
FlexiBLAS is a wrapper library that enables the exchange of the BLAS and LAPACK
implementation used in an executable without recompiling or re-linking it. This
could in principle also be achieved using the LD_LIBRARY_PATH mechanism, if
all BLAS and LAPACK were consistently implemented as a single library file
with a fully compatible interface. Unfortunately, not all BLAS and
LAPACK libraries are realized as only this exact one shared library
containing all required symbols. Implementations with differing numbers of
library files (shared objects) clearly break this mechanism of easily switching
via the LD_LIBRARY_PATH environment variable.

The FlexiBLAS library provides a GNU Fortran compatible interface to all
functions and subroutines provided by the Netlib reference implementations. As
backends FlexiBLAS can employ all BLAS and LAPACK implementations which
consist of a single shared library directly. Other variants like the Intel MKL
or ATLAS that use multiple files are integrated by FlexiBLAS by wrapping all
files into a single surrogate library.

## Test environments
- local R installation, R 4.0.2
- fedora:33 on GitHub

## R CMD check results
0 errors | 0 warnings | 0 notes
