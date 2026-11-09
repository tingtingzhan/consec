
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
#' c(NA, 29.3) |>
#'  cmod(e2 = teaspoon, n = 4L)
#'  
#' (Sys.Date() - as.Date('2020-01-01')) |>
#'  as.numeric() |>
#'  cmod(e2 = day, n = 5L)
#' 
#' @importFrom stats na.omit
#' @importFrom utils head
#' @keywords consecutive modulo
#' @export
cmod <- \(e1, e2, n, ...) {
  
  n1 <- length(e1)
  n2 <- length(e2)
  if (!n1 || !n2) return(character())
  
  id <- e2 |>
    allow_multiple(...)
    
  z <- array(NA_integer_, dim = c(n1, n2), dimnames = list(NULL, names(e2)))
  
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
    if (any(z[,!id] %notin% c(0L, 1L, NA_integer_))) stop()
  }
  
  z[which(z == 0L)] <- NA_character_
  
  z |>
    apply(MARGIN = 1L, FUN = \(i) {
      i <- i |> 
        na.omit()
      if (!length(i)) return('') # for human reader
      nm <- names(i)
      ifelse(
        test = grepl(pattern = '^[a-z|A-Z]', x = nm), 
        yes = paste0(i, nm), 
        no = nm
      ) |>
        head(n = n) |>
        paste(collapse = ' ') # !length(i) compatible, actually
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
#' day |> allow_multiple()
#' minute |> allow_multiple()
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

