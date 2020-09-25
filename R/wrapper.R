# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.
#
# Copyright (C) 2020 Iñaki Ucar

#' Check Availability
#'
#' Check whether FlexiBLAS is available.
#'
#' @return A boolean.
#' @seealso [flexiblas_version], [flexiblas-backends], [flexiblas-threads]
#' @md
#' @export
flexiblas_avail <- function() {
  .Call(`_flexiblas_avail`)
}

#' Handle Backends
#'
#' Get current backend, list available ones, load and switch between backends.
#'
#' @return `flexiblas_current_backend` and `flexiblas_list*` return a character
#' vector of backend names or paths.
#'
#' `flexiblas_load_backend` and `flexiblas_switch` return the indices of
#' the loaded backends if the operation was successful, or fail otherwise.
#' @seealso [flexiblas_avail], [flexiblas_version], [flexiblas-threads]
#' @name flexiblas-backends
#' @md
#' @export
flexiblas_current_backend <- function() {
  .Call(`_flexiblas_current_backend`)
}

#' Get/Set Number of Threads
#'
#' Get or set the number of threads for the BLAS backend.
#'
#' @return `flexiblas_get_num_threads` returns the number of threads.
#' @seealso [flexiblas_avail], [flexiblas_version], [flexiblas-backends]
#' @name flexiblas-threads
#' @md
#' @export
flexiblas_get_num_threads <- function() {
  .Call(`_flexiblas_get_num_threads`)
}

#' @name flexiblas-backends
#' @export
flexiblas_list <- function() {
  .Call(`_flexiblas_list`)
}

#' @name flexiblas-backends
#' @export
flexiblas_list_loaded <- function() {
  .Call(`_flexiblas_list_loaded`)
}

#' @name flexiblas-backends
#' @param name character vector of backend names or paths (case insensitive).
#' @export
flexiblas_load_backend <- function(name) {
  .Call(`_flexiblas_load_backend`, name)
}

#' @examples \donttest{
#' max_threads <- 4
#' n <- 2000
#' runs <- 10
#'
#' A <- matrix(runif(n*n), nrow=n)
#' B <- matrix(runif(n*n), nrow=n)
#'
#' for (i in seq_len(max_threads)) {
#'   message("Set number of threads to: ", i)
#'   flexiblas_set_num_threads(i)
#'
#'   print(system.time({
#'     for (j in seq_len(runs))
#'       C <- A %*% B
#'   }))
#' }
#' }
#'
#' @name flexiblas-threads
#' @param n number of threads.
#' @return `flexiblas_set_num_threads` returns nothing.
#' @export
flexiblas_set_num_threads <- function(n) {
  invisible(.Call(`_flexiblas_set_num_threads`, n))
}

#' @examples \donttest{
#' n <- 2000
#' runs <- 10
#' ignore <- "__FALLBACK__"
#'
#' A <- matrix(runif(n*n), nrow=n)
#' B <- matrix(runif(n*n), nrow=n)
#'
#' # load backends
#' backends <- setdiff(flexiblas_list(), ignore)
#' idx <- flexiblas_load_backend(backends)
#'
#' # benchmark
#' timings <- sapply(idx, function(i) {
#'   flexiblas_switch(i)
#'
#'   # warm-up
#'   C <- A[1:100, 1:100] %*% B[1:100, 1:100]
#'
#'   unname(system.time({
#'     for (j in seq_len(runs))
#'       C <- A %*% B
#'   })[3])
#' })
#'
#' if (length(timings)) {
#'   results <- data.frame(
#'     backend = backends,
#'     `timing [s]` = timings,
#'     `performance [GFlops]` = (2 * (n / 1000)^3) / timings,
#'     check.names = FALSE)
#'
#'   results[order(results$performance),]
#' }
#' }
#' @name flexiblas-backends
#' @param n loaded backend index.
#' @export
flexiblas_switch <- function(n) {
  invisible(.Call(`_flexiblas_switch`, n))
}

#' Get Version
#'
#' Get current version of FlexiBLAS.
#'
#' @return A [package_version] object.
#' @seealso [flexiblas_avail], [flexiblas-backends], [flexiblas-threads]
#' @md
#' @export
flexiblas_version <- function() {
  cls <- c("package_version", "numeric_version")
  structure(list(.Call(`_flexiblas_version`)), class=cls)
}
