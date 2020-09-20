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

v <- flexiblas_version()
l <- flexiblas_list()
ll <- flexiblas_list_loaded()
cur <- flexiblas_current_backend()
nt <- flexiblas_get_num_threads()

expect_true(is.logical(flexiblas_avail()))
expect_true(inherits(v, "package_version"))

if (flexiblas_avail()) {
  expect_false(is.na(v$major))
  expect_false(is.na(v$minor))
  expect_false(is.na(v$patch))
  expect_false(is.na(cur))
  expect_false(is.na(nt))

  expect_true(length(l) > 0)
  expect_true(length(ll) == 1)

  flexiblas_set_num_threads(nt - 1)
  expect_equal(flexiblas_get_num_threads(), nt - 1)
} else {
  expect_true(is.na(v$major))
  expect_true(is.na(v$minor))
  expect_true(is.na(v$patch))
  expect_true(is.na(cur))
  expect_true(is.na(nt))

  expect_true(length(l) == 0)
  expect_true(length(ll) == 0)
}

idx <- flexiblas_load_backend(l)
ll <- flexiblas_list_loaded()
s <- character(0)
for (i in seq_along(idx)) {
  flexiblas_switch(idx[i])
  s[i] <- flexiblas_current_backend()
}

expect_equal(l, ll[idx])
expect_equal(s, l)
