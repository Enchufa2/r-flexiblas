# flexiblas: FlexiBLAS API Interface for R

<!-- badges: start -->
[![Build Status](https://github.com/Enchufa2/r-flexiblas/workflows/build/badge.svg)](https://github.com/Enchufa2/r-flexiblas/actions)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/flexiblas)](https://cran.r-project.org/package=flexiblas)
<!-- badges: end -->

Provides functions to switch the BLAS/LAPACK optimized backend
and change the number of threads without leaving the R session, which needs
to be linked against the [FlexiBLAS](https://www.mpi-magdeburg.mpg.de/projects/flexiblas)
wrapper library.

## Usage

See the [installation](#installation) section below for instructions on how to
set a proper environment and install this package.

### Basic

```r
library(flexiblas)

# check whether FlexiBLAS is available
flexiblas_avail()
#> [1] TRUE

# get the current backend
flexiblas_current_backend()
#> [1] "OPENBLAS-OPENMP"

# list all available backends
flexiblas_list()
#> [1] "NETLIB"           "__FALLBACK__"     "BLIS-THREADS"     "OPENBLAS-OPENMP"
#> [5] "BLIS-SERIAL"      "ATLAS"            "OPENBLAS-SERIAL"  "OPENBLAS-THREADS"
#> [9] "BLIS-OPENMP"

# get/set the number of threads
flexiblas_set_num_threads(12)
flexiblas_get_num_threads()
#> [1] 12
```

### Benchmarking

Example of GEMM benchmark for all the backends available:

```r
library(flexiblas)

n <- 2000
runs <- 10
ignore <- "__FALLBACK__"

A <- matrix(runif(n*n), nrow=n)
B <- matrix(runif(n*n), nrow=n)

# load backends
backends <- setdiff(flexiblas_list(), ignore)
idx <- flexiblas_load_backend(backends)

# benchmark
timings <- sapply(idx, function(i) {
  flexiblas_switch(i)

  # warm-up
  C <- A[1:100, 1:100] %*% B[1:100, 1:100]

  unname(system.time({
    for (j in seq_len(runs))
      C <- A %*% B
  })[3])
})

results <- data.frame(
  backend = backends,
  `timing [s]` = timings,
  `performance [GFlops]` = (2 * (n / 1000)^3) / timings,
  check.names = FALSE)

results[order(results$performance),]
#>            backend timing [s] performance [GFlops]
#> 1           NETLIB     56.776            0.2818092
#> 5            ATLAS      5.988            2.6720107
#> 2     BLIS-THREADS      3.442            4.6484602
#> 8      BLIS-OPENMP      3.408            4.6948357
#> 4      BLIS-SERIAL      3.395            4.7128130
#> 6  OPENBLAS-SERIAL      3.206            4.9906425
#> 7 OPENBLAS-THREADS      0.773           20.6985770
#> 3  OPENBLAS-OPENMP      0.761           21.0249671
```

## Installation

### Environment

Fedora 33+ ships R linked against FlexiBLAS. You can install multiple backends
(`atlas`, `blis-[serial|openmp|threads]`, `openblas-[serial|openmp|threads]`)
as well as compile third-party libraries (such as MKL), and switch between them
without leaving your R session using this package. If you are not running
Fedora >= 33, you can set up a proper environment using docker.

```bash
$ docker run --rm -it fedora:rawhide
```

The following command installs R and all the optimized BLAS/LAPACK backends
shipped in Fedora (use `sudo` if appropriate):

```bash
$ dnf install R flexiblas-*
```

### Package

Within the environment above, it can be installed from the official repos:

```bash
$ dnf install R-flexiblas
```

or install the release version from CRAN:

``` r
install.packages("flexiblas")
```

The installation from GitHub requires the
[remotes](https://cran.r-project.org/package=remotes) package.

```r
# install.packages("remotes")
remotes::install_github("Enchufa2/r-flexiblas")
```
