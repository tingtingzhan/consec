
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
#' @examples
#' 29.3 |>
#'  cmod(e2 = teaspoon, n = 4L)
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
    
  z <- array(NA_integer_, dim = c(n1, n2), dimnames = list(NULL, nm2))
  
  for (i in seq_len(n2)) {
    if (i == 1L) {
      m <- e1 |> 
        mod_(e2 = e2[i], ...)
      z[,i] <- m # drops attr
    } else {
      m <- m |>
        attr(which = 'mod', exact = TRUE) |> 
        mod_(e2 = e2[i], ...)
      z[,i] <- m # drops attr
    }
  }
  
  rm(m)
  
  if (!all(id)) {
    if (any(z[,!id] %notin% c(0, 1, NA_integer_))) stop()
  }
  
  ifelse(
    test = z > 0, 
    yes = ifelse(
      test = grepl(pattern = '^[a-z|A-Z]', x = nm2),
      yes = z,
      no = ''
    ) |>
      paste0(nm2), 
    no = NA_character_
  ) |>
    array(dim = dim(z)) |>
    apply(MARGIN = 1L, FUN = \(i) {
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
#' @param tol \link[base]{double} scalar, default value is `.Machine$double.eps`
#' 
#' @param ... additional parameters, currently not in use
#' 
#' @examples
#' teaspoon |> allow_multiple()
#' teaspoon2 |> allow_multiple()
#' floz |> allow_multiple()
#' 
#' c(day = 60*24, hour = 60, min = 1) |> allow_multiple()
#' @export
allow_multiple <- \(x, tol = .Machine$double.eps, ...) {
  
  n <- length(x)
  if (n < 2L) stop()
  if (anyNA(x)) stop()
  
  nm <- names(x)
  if (!length(nm) || anyNA(nm) || !all(nzchar(nm))) stop()
  
  z <- logical(length = n)
  names(z) <- nm
  z[1L] <- TRUE # first unit always TRUE
  
  for (i in 2:n) {
    z[i] <- (x[i-1L] - 2*x[i] > tol)
  }
  
  az <- nm |>
    grepl(pattern = '^[a-z|A-Z]', x = _)
  if (any((!az) & z)) {
    stop('Unit start with non-alphabet AND allow-multiple')
  }
  #attr(z, which = 'az') <- az
  
  return(z)
  
}

