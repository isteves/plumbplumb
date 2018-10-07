
# Iterating with plumber

Getting your plumber API up and running takes a bit of fiddling around.
Rather than launching swagger each time, and testing your arguments
manually, you can use the following workflow:

1.  Draft your plumber function
2.  Run `start_plumber(path, port)`
3.  Check that it works as expected using `httr`
4.  Fiddle with your plumber function if something is off
5.  Repeat 2-4 until you get it right\!

If you have ready-built plumber functions, you can use test them out
directly in a single RStudio session by opening up a new terminal with
`start_plumber`. I’ve included a two functions (`random_praise` and
`random_data`) in a sample plumber file in the `inst` folder of this
repo. Depending on what seed you set, the output changes:

``` r
# devtools::install_github("isteves/plumbplumb")
library(plumbplumb) 

plumber_path <- system.file("plumber.R", package = "plumbplumb")
start_plumber(plumber_path, port = 8484)

bar <- httr::GET("http://127.0.0.1:8484/random_praise?seed=2")
httr::content(bar, as = "text")

foo <- httr::GET("http://127.0.0.1:8484/random_praise?seed=3")
httr::content(foo, as = "text")
```

Same with the data:

``` r
baz <- httr::GET("http://127.0.0.1:8484/random_data?seed=2")
httr::content(baz)

boo <- httr::GET("http://127.0.0.1:8484/random_data?seed=3")
httr::content(boo)
```
