
#' @title Consecutive Modulo
#' 
#' @param e1 \link[base]{numeric} scalar or \link[base]{vector}
#' 
#' @param e2 named \link[base]{numeric} \link[base]{vector}
#' 
#' @param n \link[base]{integer} scalar
#' 
#' @param ... additional parameters of the function [mod_()]
#' 
#' @importFrom stats na.omit
#' @importFrom utils head
#' @export
cmod <- \(e1, e2, n, ...) {
  
  n1 <- length(e1)
  n2 <- length(e2)
  if (!n1 || !n2) return(character())
  
  id <- e2 |>
    allow_multiple(...)
  nm2 <- names(e2)
    
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
  
  
  if (!all(id)) {
    if (any(z[!id,] %notin% c(0, 1, NA_integer_))) stop()
  }
  
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



#' @title Allow Multiple?
#' 
#' @param x \link[base]{numeric} \link[base]{vector}
#' 
#' @param tol ..
#' 
#' @param ... ..
#' 
#' @examples
#' x1 = c(
#'  Cup = 48, '\u2154Cup' = 48*2/3, '\u00bdCup' = 48/2,
#'  '\u2153Cup' = 48/3, '\u00bcCup' = 48/4, 
#'  Tbsp = 3, '2tsp' = 2, '1\u00bdtsp' = 1.5, '1tsp' = 1,
#'  '\u00bdtsp' = .5,
#'  '\u00bctsp' = 1/4,
#'  '\u215btsp' = 1/8)
#' x1 |> allow_multiple()
#' 
#' x2 = c(day = 60*24, hour = 60, min = 1)
#' x2 |> allow_multiple()
#' @export
allow_multiple <- \(x, tol = .Machine$double.eps, ...) {
  
  n <- length(x)
  if (n < 2L) stop()
  if (anyNA(x)) stop()
  
  nm <- names(x)
  if (!length(nm) || anyNA(nm)) stop()
  
  z <- logical(length = n)
  names(z) <- nm
  z[1L] <- TRUE # first unit always TRUE
  
  for (i in 2:n) {
    z[i] <- (x[i-1L] - 2*x[i] > tol)
  }
  
  return(z)
  
}

