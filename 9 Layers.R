library(tidyverse)

mpg
?mpg

# Left
# fig1
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# Right
# fig2
ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()
#> Warning: The shape palette can deal with a maximum of 6 discrete values because more
#> than 6 becomes difficult to discriminate
#> ℹ you have requested 7 values. Consider specifying shapes manually if you
#>   need that many have them.
#> Warning: Removed 62 rows containing missing values or values outside the scale range
#> (`geom_point()`).



# We can map class to size or alpha aesthetics as well, which control the size and the transparency of the points, respectively.
# Left
# fig3
ggplot(mpg, aes(x = displ, y = hwy, size = class)) +
  geom_point()
#> Warning: Using size for a discrete variable is not advised.

# Right
# fig4
ggplot(mpg, aes(x = displ, y = hwy, alpha = class)) +
  geom_point()
#> Warning: Using alpha for a discrete variable is not advised.




# IMPORTANT: Both of these(above) produce warnings as well: Using alpha for a discrete variable is not advised.
# Mapping an unordered discrete (categorical) variable (class) to an ordered aesthetic (size or alpha) is generally not a good idea because it implies a ranking that does not in fact exist.

# Once you map an aesthetic, ggplot2 takes care of the rest. It selects a reasonable scale to use with the aesthetic, and it constructs a legend that explains the mapping between levels and values. For x and y aesthetics, ggplot2 does not create a legend, but it creates an axis line with tick marks and a label. The axis line provides the same information as a legend; it explains the mapping between locations and values.


# You can also set the visual properties of your geom manually as an argument of your geom function (outside of aes()) instead of relying on a variable mapping to determine the appearance. For example, we can make all of the points in our plot blue:
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "blue")
# the color here does not convey information about a variable, just changes the appearance. PICK A VALUE THAT MAKES SENSE FOR THAT AESTHETIC




# 9.2.1 Exercises ----------------------------------------------------------
# Create a scatterplot of hwy vs. displ where the points are pink filled in triangles.
# fig5
ggplot(
  mpg,
  aes(hwy, displ)
) +
  geom_point(
    color = "pink", # Set the color of the points to pink
    fill = "pink", # Set the fill color to pink
    shape = 24 # Set the shape of the points (e.g., 24 for a FILLED triangle)
  )


# Why did the following code not result in a plot with blue points?
# ans: The reason why the color is not changing is because the when I use aes(color = "blue"), ggplot interprets "blue" as a categorical variable, not as an actual color. As a result, it doesn't apply the blue color to the points
# fig6
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, color = "blue"))



# What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
# ans: controls the width of the border (or outline) of shapes that have both a fill and an outline. This aesthetic is specifically applicable to point shapes that have both a fill and color aesthetic, which include shapes 21 through 25.
# fig6
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy),
    shape = 21, # Circle with both fill and outline
    color = "red", # Outline color
    fill = "black", # Fill color
    stroke = 2
  ) # Thickness of the outline



# What happens if you map an aesthetic to something other than a variable name, like aes(color = displ < 5)? Note, you’ll also need to specify x and y.
# ans: is being evaluated in the global environment, where displ doesn't exist as an object.
mpg
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy),
    shape = 21, # Circle with both fill and outline
    color = displ < 5, # Outline color
    fill = "black", # Fill color
    stroke = 2
  ) # Thickness of the outline

# To correctly map the color based on the displ variable, you need to use the aes() function within geom_point(). This will ensure that displ is correctly evaluated within the context of the mpg dataset.
# fig7
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, color = displ < 4),
    shape = 21, # Circle with both fill and outline
    fill = "orange", # Fill color
    stroke = 2
  ) # Thickness of the outline









# 9.3 Geometric objects --------------------------------------------------------


# Left - point geoms
# fig8
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

# Right - smooth geom
# fig9
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()
#> `geom_smooth()` using method = 'loess' and formula = 'y ~ x'






# Every geom function in ggplot2 takes a mapping argument, either defined locally in the geom layer or globally in the ggplot() layer. However, not every aesthetic works with every geom. You could set the shape of a point, but you couldn’t set the “shape” of a line. If you try, ggplot2 will silently ignore that aesthetic mapping. On the other hand, you could set the linetype of a line. geom_smooth() will draw a different line, with a different linetype, for each unique value of the variable that you map to linetype.

# Left - geom smooth draws a different line
# fig10
ggplot(mpg, aes(x = displ, y = hwy, shape = drv)) +
  geom_smooth()

# Right - geom smooth draws using different line types
# fig11
ggplot(mpg, aes(x = displ, y = hwy, linetype = drv)) +
  geom_smooth()






# Here, geom_smooth() separates the cars into three lines based on their drv value, which describes a car’s drive train. One line describes all of the points that have a 4 value, one line describes all of the points that have an f value, and one line describes all of the points that have an r value. Here, 4 stands for four-wheel drive, f for front-wheel drive, and r for rear-wheel drive.

# If this sounds strange, we can make it clearer by overlaying the lines on top of the raw data and then coloring everything according to drv.

# fig12
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(aes(linetype = drv))






# Many geoms, like geom_smooth(), use a single geometric object to display multiple rows of data. For these geoms, you can set the group aesthetic to a categorical variable to draw multiple objects. ggplot2 will draw a separate object for each unique value of the grouping variable. In practice, ggplot2 will automatically group the data for these geoms whenever you map an aesthetic to a discrete variable (as in the linetype example). It is convenient to rely on this feature because the group aesthetic by itself does not add a legend or distinguishing features to the geoms.
# Left
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()

# Middle
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv))

# Right
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)





# If you place mappings in a geom function, ggplot2 will treat them as local mappings for the layer. It will use these mappings to extend or overwrite the global mappings for that layer only. This makes it possible to display different aesthetics in different layers.

# fig13 - styles the points but not the line
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()




# You can use the same idea to specify different data for each layer. Here, we use red points as well as open circles to highlight two-seater cars. The local data argument in geom_point() overrides the global data argument in ggplot() for that layer only.

# fig14
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    color = "red"
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    shape = "circle open", size = 3, color = "red"
  ) +
  geom_point(
    data = mpg |> filter(class == "midsize"),
    shape = 15, size = 2, color = "blue"
  ) +
  geom_point(
    data = mpg |> filter(class == "minivan"),
    shape = 15, size = 2, color = "pink"
  )
?mpg

mpg |>
  pull(class) |>
  unique()



# Geoms are the fundamental building blocks of ggplot2. You can completely transform the look of your plot by changing its geom, and different geoms can reveal different features of your data. For example, the histogram and density plot below reveal that the distribution of highway mileage is bimodal and right skewed while the boxplot reveals two potential outliers.

# Left
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2)

# Middle
ggplot(mpg, aes(x = hwy)) +
  geom_density()

# Right
ggplot(mpg, aes(x = hwy)) +
  geom_boxplot()




# LINK TO SEE ALL AVAILABLE GEOMS IN GGPLOT2: https://ggplot2.tidyverse.org/reference/
# For example, try the ggridges package: https://wilkelab.org/ggridges/
install.packages("ggridges")
library(ggridges)

# fig15
ggplot(mpg, aes(x = hwy, y = drv, fill = drv, color = drv)) +
  geom_density_ridges(alpha = 0.5, show.legend = FALSE)
#> Picking joint bandwidth of 1.28




# 9.3.1 Exercises
# What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
# ans: I would use geom_line. An area chart may also provide a great informational visual. Also, instead of a histogram, I'd use a frequency polygon.


# Earlier in this chapter we used show.legend without explaining it:
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = TRUE)
# What does show.legend = FALSE do here? What happens if you remove it? Why do you think we used it earlier?
# ans: it hides any the labels of the plots aesthetics such as the color, shape, size, etc.


# What does the se argument to geom_smooth() do?
# ans: Display confidence interval around smooth? (TRUE by default, see level to control.). its that grey thing around the line
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = TRUE, se = TRUE)
?geom_smooth


# Recreate the R code necessary to generate the following graphs. Note that wherever a categorical variable is used in the plot, it’s drv.
# Link to exercise plot examples to recreate: https://r4ds.hadley.nz/layers#exercises-1
# tackling them in a row-wise direction

# plot1
#fig16
ggplot(mpg, aes(displ, hwy)) +
  geom_point(shape = 16) +
  geom_smooth(se = FALSE)
ggsave(filename = "Exercise Graphs/9 Layers/9.3.1/Fig16 - Plot1.png")

# plot2
ggplot(mpg, aes(displ, hwy)) +
  geom_smooth(se = FALSE) +
  geom_smooth(aes(group = drv), se = FALSE) +
  geom_point(shape = 16, size = 4)
ggsave(filename = "Exercise Graphs/9 Layers/9.3.1/Fig17 - Plot2.png")
?mpg
?geom_smooth

# plot3
ggplot(mpg, aes(displ, hwy, color = drv)) +
  geom_point(
    shape = 16,
    size = 5
  ) +
  geom_smooth(se = FALSE)
ggsave(filename = "Exercise Graphs/9 Layers/9.3.1/Fig18 - Plot3.png")

# plot4
ggplot(mpg, aes(displ, hwy)) +
  geom_point(
    mapping = aes(color = drv),
    shape = 16,
    size = 5
  ) +
  geom_smooth(se = FALSE, size = 3)
ggsave(filename = "Exercise Graphs/9 Layers/9.3.1/Fig19 - Plot4.png")

# plot5
ggplot(mpg, aes(displ, hwy)) +
  geom_point(
    mapping = aes(color = drv),
    shape = 16,
    size = 5
  ) +
  geom_smooth(
    aes(linetype = drv),
    se = FALSE,
    size = 2
  )
ggsave(filename = "Exercise Graphs/9 Layers/9.3.1/Fig20 - Plot5.png")

# plot6
ggplot(mpg, aes(displ, hwy)) +
  geom_point(
    mapping = aes(fill = drv),  # Fill color based on drv
    shape = 21,                 # Shape with a fill and stroke
    size = 4,
    color = "white",            # Stroke color (outline) set to white
    stroke = 2,                  # Stroke width
  ) +
ggsave(filename = "Exercise Graphs/9 Layers/9.3.1/Fig21 - Plot6.png")





# 9.4 Facets -------------------------------------------------------------
#In Chapter 1 you learned about faceting with facet_wrap(), which splits a plot into subplots that each display one subset of the data based on a categorical variable.
?mpg
#fig22
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~cyl)



#To facet your plot with the combination of two variables, switch from facet_wrap() to facet_grid(). The first argument of facet_grid() is also a formula, but now it’s a double sided formula: rows ~ cols.
#fig23
ggplot(
  mpg,
  aes(displ, hwy)
) +
  geom_point() +
  facet_grid(drv ~ cyl)


#By default each of the facets share the same scale and range for x and y axes. This is useful when you want to compare data across facets but it can be limiting when you want to visualize the relationship within each facet better. Setting the scales argument in a faceting function to "free_x" will allow for different scales of x-axis across columns, "free_y" will allow for different scales on y-axis across rows, and "free" will allow both.
#fig24
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free")





# 9.4.1 Exercises -------------------------------------------------------------
#What happens if you facet on a continuous variable?
#ans: The continous variable is divided into intervals and the points are displayed inside those intervals
?mpg
mpg
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(~hwy)
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(~displ)


# COME BACK TO THIS PROBLEM
#What do the empty cells in the plot above with facet_grid(drv ~ cyl) mean? Run the following code. How do they relate to the resulting plot?
#ans:
ggplot(mpg) + 
  geom_point(aes(x = drv, y = cyl))





#What plots does the following code make? What does . do?
#ans: facet_grid(drv ~ .) means that the data is split into rows based on the drv variable. The . on the right side of the formula indicates that there are no columns to facet by.
#facet_grid(. ~ cyl) means that the data is split into columns based on the cyl variable. The . on the left side of the formula indicates that there are no rows to facet by.
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)


ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)



# 4 exercises
































