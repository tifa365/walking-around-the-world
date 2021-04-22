install.packages("httr")
library(httr)

x <- GET("http://httpbin.org/status/200")
http_status(x)

status_code(x)