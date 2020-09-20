# flexiblas: FlexiBLAS API Interface for R

<!-- badges: start -->
[![Build Status](https://github.com/Enchufa2/r-flexiblas/workflows/build/badge.svg)](https://github.com/Enchufa2/r-flexiblas/actions)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/flexiblas)](https://cran.r-project.org/package=flexiblas)
<!-- badges: end -->

[FlexiBLAS](https://www.mpi-magdeburg.mpg.de/projects/flexiblas) is a BLAS
wrapper library which allows to change the BLAS without recompiling the programs.

Fedora 33+ ships R linked against FlexiBLAS. You can install multiple backends
(atlas, blis-[serial|openmp|threads], openblas-[serial|openmp|threads]) as well
as compile third-party libraries (MKL...), and switch between them within the R
session using this package.

## Usage

Example of GEMM benchmark for all the backends available:

```r
library(flexiblas)

n <- 2000
runs <- 10
ignore <- "__FALLBACK__"

A <- matrix(runif(n*n), nrow=n)
B <- matrix(runif(n*n), nrow=n)

# load backends
backends <- grep(ignore, flexiblas_list(), value=TRUE, invert=TRUE)
idx <- flexiblas_load_backend(backends)

# benchmark
timings <- sapply(idx, function(i) {
  flexiblas_switch(i)

  # warm-up
  X <- matrix(runif(100*100), nrow=100) %*% matrix(runif(100*100), nrow=100)

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
results
#>           backend timing [s] performance [GFlops]
#> 1          NETLIB     65.082            0.2458437
#> 2 OPENBLAS-OPENMP      1.635            9.7859327
```

## Installation

Install the release version from CRAN:

``` r
install.packages("flexiblas")
```

The installation from GitHub requires the
[remotes](https://cran.r-project.org/package=remotes) package.

```r
# install.packages("remotes")
remotes::install_github("Enchufa2/flexiblas")
```
