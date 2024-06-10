## ----include = FALSE----------------------------------------------------------
can_decrypt <- httr2::secret_has_key('KHIS_KEY')

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  error = TRUE,
  purl = can_decrypt,
  eval = can_decrypt
)
options(tibble.print_min = 5L, tibble.print_max = 5L)

