install.packages("gganimate")
install.packages('pak')
pak::pak('thomasp85/gganimate')
install.packages("gifski") #for saving gifs

install.packages("gapminder")
library(gapminder)
library(gganimate)

gapminder

anim <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = "Tadeo testing animation", subtitle = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')

animate(anim, renderer = file_renderer(dir = "data/animation"))
animate(anim, renderer = gifski_renderer("data/animation/anim.gif"))
