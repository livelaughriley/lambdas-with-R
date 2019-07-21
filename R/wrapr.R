#
# wrapr.R
# 2019-07-15 12:24:06
#
#
# Practice with the `wrapr` package
# https://github.com/winvector/wrapr
#

library(wrapr)
library(microbenchmark)

# assign global vars ------------------------------------------------------

# assign vectors
vec_a <- 1:100
vec_b <- 4:103


# simple math -------------------------------------------------------------


# using lambda() function
add_func <- lambda(a, b, a + b)
add_func(vec_a, vec_b)

# using brace interface
add_func <- a~b := { a + b }
add_func(vec_a, vec_b)



# substitution with `let` and `%.>%` --------------------------------------

# base R
base_func <- function(a, b) {
    x <- a
    y <- b
    x %*% y
}
base_func(vec_a, vec_b)

# wrapr
let_func <- function(a, b) {
    let(c(x = quote(a), y = quote(b)),
        expr = {
            x %*% y
        }
    )
}
let_func(vec_a, vec_b)


# comparing speed of base R and wrapr functions

set.seed(1)

mx_a <- matrix(
    runif(10000 * 1000),
    nrow = 1000,
    ncol = 1000
)

mx_b <- matrix(
    runif(1000 * 100),
    nrow = 1000,
    ncol = 100
)

results <- microbenchmark(
    "base_func" = {
        base_func(mx_a, mx_b)
    },
    "let_func" = {
        let_func(mx_a, mx_b)
    },
    times = 100
)

results