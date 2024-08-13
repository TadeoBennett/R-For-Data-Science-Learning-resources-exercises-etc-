library(tidyverse)
install.packages("hexbin")
install.packages("usethis")

ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_hex()
ggsave("diamonds.png")

write_csv(diamonds, "data/diamonds.csv")


