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

#' \pkg{flexiblas}: FlexiBLAS API Interface for \R
#'
#' Provides functions to switch the BLAS/LAPACK optimized backend
#' and change the number of threads without leaving the R session, which needs
#' to be linked against the FlexiBLAS wrapper library.
#'
#' @author Martin Koehler, Iñaki Ucar
#' @references Koehler M., Saak J. (2020).
#' "FlexiBLAS - A BLAS and LAPACK wrapper library with runtime exchangeable backends."
#' \doi{10.5281/zenodo.3909214}.
#'
#' @docType package
#' @name flexiblas-package
#' @useDynLib flexiblas, .registration=TRUE
NULL
