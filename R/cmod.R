
#' @title Consecutive Modulo
#' 
#' @param e1 \link[base]{numeric} scalar or \link[base]{vector}
#' 
#' @param e2 named \link[base]{numeric} \link[base]{vector}
#' 
#' @param pattern_allow_multiple (optional) \link[base]{character} scalar, a \link[base]{regex}
#' 
#' @param n \link[base]{integer} scalar
#' 
#' @param ... additional parameters of the function [mod_()]
#' 
#' @importFrom stats na.omit
#' @importFrom utils head
#' @export
cmod <- \(e1, e2, pattern_allow_multiple, n, ...) {
  
  n1 <- length(e1)
  n2 <- length(e2)
  if (!n1 || !n2) return(character())
  
  nm2 <- names(e2)
  if (!length(nm2)) stop()
  
  z <- array(NA_integer_, dim = c(n2, n1), dimnames = list(nm2, NULL))
  
  for (i in seq_len(n2)) {
    if (i == 1L) {
      m <- e1 |> 
        mod_(e2 = e2[i], ...)
      z[i,] <- m # drops attr
    } else {
      m <- m |>
        attr(which = 'mod', exact = TRUE) |> 
        mod_(e2 = e2[i], ...)
      z[i,] <- m # drops attr
    }
  }
  
  rm(m)
  
  if (!missing(pattern_allow_multiple)) {
    id <- nm2 |>
      grepl(pattern = pattern_allow_multiple)
    if (any(z[!id,] %notin% c(0, 1, NA_integer_))) stop()
  } else id <- TRUE # all units allow multiple
  
  ret <- array('', dim = dim(z))
  ret[id,] <- ifelse(z[id,] > 0, yes = paste0(z[id,], nm2[id]), no = NA_character_)
  ret[!id,] <- ifelse(z[!id,], yes = nm2[!id], no = NA_character_)
  
  ret |>
    apply(MARGIN = 2L, FUN = \(i) {
      i |> 
        na.omit() |>
        head(n = n) |>
        paste(collapse = ' ')
    }, simplify = TRUE)
  
}

