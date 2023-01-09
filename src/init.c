#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .Call calls */
extern SEXP _flexiblas_avail(void);
extern SEXP _flexiblas_current_backend(void);
extern SEXP _flexiblas_get_num_threads(void);
extern SEXP _flexiblas_list(void);
extern SEXP _flexiblas_list_loaded(void);
extern SEXP _flexiblas_load_backend(SEXP);
extern SEXP _flexiblas_set_num_threads(SEXP);
extern SEXP _flexiblas_switch(SEXP);
extern SEXP _flexiblas_version(void);

static const R_CallMethodDef CallEntries[] = {
    {"_flexiblas_avail",           (DL_FUNC) &_flexiblas_avail,           0},
    {"_flexiblas_current_backend", (DL_FUNC) &_flexiblas_current_backend, 0},
    {"_flexiblas_get_num_threads", (DL_FUNC) &_flexiblas_get_num_threads, 0},
    {"_flexiblas_list",            (DL_FUNC) &_flexiblas_list,            0},
    {"_flexiblas_list_loaded",     (DL_FUNC) &_flexiblas_list_loaded,     0},
    {"_flexiblas_load_backend",    (DL_FUNC) &_flexiblas_load_backend,    1},
    {"_flexiblas_set_num_threads", (DL_FUNC) &_flexiblas_set_num_threads, 1},
    {"_flexiblas_switch",          (DL_FUNC) &_flexiblas_switch,          1},
    {"_flexiblas_version",         (DL_FUNC) &_flexiblas_version,         0},
    {NULL, NULL, 0}
};

void R_init_flexiblas(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
