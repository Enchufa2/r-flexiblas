/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 *
 * Copyright (C) 2020-2022 Iñaki Ucar
 */

#include <R.h>
#include <Rinternals.h>
#define FLEXIBLAS_API_INT int32_t
#include "flexiblas_api.h"

#define BACKEND_CHAR_LEN 1024

SEXP _flexiblas_avail(void) {
  SEXP ret = PROTECT(Rf_allocVector(LGLSXP, 1));

  INTEGER(ret)[0] = flexiblas_avail();

  UNPROTECT(1);
  return ret;
}

SEXP _flexiblas_current_backend(void) {
  SEXP ret = PROTECT(Rf_allocVector(STRSXP, 1));
  char backend[BACKEND_CHAR_LEN];

  if (flexiblas_avail()) {
    flexiblas_current_backend(backend, BACKEND_CHAR_LEN);
    SET_STRING_ELT(ret, 0, mkChar(backend));
  } else SET_STRING_ELT(ret, 0, NA_STRING);

  UNPROTECT(1);
  return ret;
}

SEXP _flexiblas_get_num_threads(void) {
  SEXP ret = PROTECT(Rf_allocVector(INTSXP, 1));

  if (flexiblas_avail())
    INTEGER(ret)[0] = flexiblas_get_num_threads();
  else INTEGER(ret)[0] = NA_INTEGER;

  UNPROTECT(1);
  return ret;
}

SEXP _flexiblas_list(void) {
  if (!flexiblas_avail()) return Rf_allocVector(STRSXP, 0);

  int nbackends = flexiblas_list(NULL, 0, 0);
  SEXP ret = PROTECT(Rf_allocVector(STRSXP, nbackends));
  char backend[BACKEND_CHAR_LEN];

  for (int i = 0; i < nbackends; i++) {
    flexiblas_list(backend, BACKEND_CHAR_LEN, i);
    SET_STRING_ELT(ret, i, mkChar(backend));
  }

  UNPROTECT(1);
  return ret;
}

SEXP _flexiblas_list_loaded(void) {
  if (!flexiblas_avail()) return Rf_allocVector(STRSXP, 0);

  int nbackends = flexiblas_list_loaded(NULL, 0, 0);
  SEXP ret = PROTECT(Rf_allocVector(STRSXP, nbackends));
  char backend[BACKEND_CHAR_LEN];

  for (int i = 0; i < nbackends; i++) {
    flexiblas_list_loaded(backend, BACKEND_CHAR_LEN, i);
    SET_STRING_ELT(ret, i, mkChar(backend));
  }

  UNPROTECT(1);
  return ret;
}

SEXP _flexiblas_load_backend(SEXP name) {
  if(!Rf_isString(name))
    Rf_error("name is not a string");

  int len = Rf_length(name);
  SEXP ret = PROTECT(Rf_allocVector(INTSXP, len));

  for (int i = 0; i < len; i++) {
    const char *backend = CHAR(STRING_ELT(name, i));
    int n = flexiblas_load_backend(backend);
    if (n < 0)
      n = flexiblas_load_backend_library(backend);
    if (n < 0) {
      UNPROTECT(1);
      Rf_error("backend '%s' not found", backend);
    }
    INTEGER(ret)[i] = n + 1;
  }

  UNPROTECT(1);
  return ret;
}

SEXP _flexiblas_set_num_threads(SEXP n) {
  if(!Rf_isNumeric(n) || Rf_length(n) != 1)
    Rf_error("n is not a single numeric");

  flexiblas_set_num_threads(Rf_asInteger(n));

  return R_NilValue;
}

SEXP _flexiblas_switch(SEXP n) {
  if(!Rf_isNumeric(n) || Rf_length(n) != 1)
    Rf_error("n is not a single numeric");

  int ret = flexiblas_switch(Rf_asInteger(n) - 1);
  if (ret < 0) Rf_error("n out of bounds");

  return R_NilValue;
}

SEXP _flexiblas_version(void) {
  if (!flexiblas_avail()) return Rf_allocVector(INTSXP, 0);

  SEXP ret = PROTECT(Rf_allocVector(INTSXP, 3));
  int *v = INTEGER(ret);

  flexiblas_get_version(&v[0], &v[1], &v[2]);

  UNPROTECT(1);
  return ret;
}
