
library(tidyverse)
library(ggplot2)

install.packages("ggthemes")

install.packages("palmerpenguins")
library(palmerpenguins)

install.packages("ggthemes")
library(ggthemes)

glimpse(penguins)
view(penguins)

#preparing the graph to analyze flipper length and the mass of a penguin
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color=species, shape=species))+
  geom_smooth(method = "lm")+
  labs(
    title = "Relationship of Penguin Body Mass and Flipper Length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper Lenth (mm)", y = "Body mass (g)",
    color = "Species", shape="Species"
  )+
  scale_color_colorblind()
#> Warning: Removed 2 rows containing missing values or values outside the scale range
#> (`geom_point()`).


#1.2.5 Exercises -------------------------------------------------
#How many rows are in penguins? How many columns? = 344 rows and 8 columns

#What does the bill_depth_mm variable in the penguins data frame describe? Read the help for ?penguins to find out. = a number denoting bill depth (millimeters)



#Make a scatterplot of bill_depth_mm vs. bill_length_mm. That is, make a scatterplot with bill_depth_mm on the y-axis and bill_length_mm on the x-axis. Describe the relationship between these two variables.
ggplot(
  data = penguins,
  mapping = aes(x = bill_length_mm, y = bill_depth_mm)
)+
  geom_point(mapping = aes(color=species, shape=species))+
  labs(
    title = "Relationship of Penguin Bill Depth and Bill Length",
    x = "Bill Length (mm)", y = "Bill Depth (mm)"
  )+
  scale_color_colorblind()
#the observed difference is that both Chinstrap penguins and Gentoo penguins hover at around the same bill lengths but have different bill depths. The Chinstrap penguins have more bill depths. On the other hand, Adelie penguins and Chinstrap have around the same Bill depths but Chinstrap penguins have greater bill lengths.
  ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )+
  geom_point(mapping = aes(color=species))
  
  

#What happens if you make a scatterplot of species vs. bill_depth_mm? What might be a better choice of geom?
  ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = species)
  )+
    geom_point(mapping = aes(color=species))
#all dots are displayed horizontally in one line and not scattered. A better choice of geom is the box plot or jitter geom:
  #The boxplot compactly displays the distribution of a continuous variable. It visualises five summary statistics (the median, two hinges and two whiskers), and all "outlying" points individually.
  ggplot(penguins, aes(x = species, y = flipper_length_mm)) +
    geom_boxplot() +
    xlab("Penguin Species") +
    ylab("Flipper Length (mm)") +
    theme_minimal()
#The jitter geom is a convenient shortcut for geom_point(position = "jitter"). It adds a small amount of random variation to the location of each point, and is a useful way of handling overplotting caused by discreteness in smaller datasets.
  ggplot(penguins, aes(x = flipper_length_mm, y = species, color = species)) +
    geom_jitter() +
    xlab("Flipper Length (mm)") +
    ylab("Penguin Species") +
    theme_minimal()
  
  
  

#  Why does the following give an error and how would you fix it?
 ggplot(data = penguins) + 
 geom_point()
 #it is missing the x and y plots. Fix is below:
 ggplot(
   data = penguins,
   mapping = aes(x = flipper_length_mm, y = bill_depth_mm)
   ) + 
   geom_point()
 
 
#What does the na.rm argument do in geom_point()? What is the default value of the argument? Create a scatterplot where you successfully use this argument set to TRUE.
 #If FALSE, the default, missing values are removed with a warning. If TRUE, missing values are silently removed. The default is FALSE.
 
 ggplot(
   data = penguins,
   mapping = aes(x = flipper_length_mm, y = body_mass_g)
 ) +
   geom_point(na.rm = TRUE, mapping = aes(color=species, shape=species))+
   geom_smooth(method = "lm")+
   labs(
     title = "Relationship of Penguin Body Mass and Flipper Length",
     subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
     x = "Flipper Lenth (mm)", y = "Body mass (g)",
     color = "Species", shape="Species"
  )
 
 
 
#Add the following caption to the plot you made in the previous exercise: “Data come from the palmerpenguins package.” Hint: Take a look at the documentation for labs().
 ggplot(
   data = penguins,
   mapping = aes(x = flipper_length_mm, y = bill_depth_mm)
 ) + 
   geom_point()+
   labs(
     title = "Data come from the palmerpenguins package."
   )
 
 ggplot(
   data= penguins,
   mapping = aes(x=flipper_length_mm, y = body_mass_g)
 )+
   geom_point(mapping = aes(color=species))+
   geom
 
 
 
 
#Recreate the following visualization. What aesthetic should bill_depth_mm be mapped to? And should it be mapped at the global level or at the geom level?
 ggplot(
   data = penguins,
   mapping = aes(x = flipper_length_mm, y = body_mass_g, color=bill_depth_mm)) +
   geom_point(
     shape=18
   )+
   geom_smooth()
 
 ?shape
 
 
 ggplot(
   penguins, 
   aes(x = flipper_length_mm, y = body_mass_g, color = bill_depth_mm)) +
   geom_point() +  # Add points to the scatter plot
   scale_color_gradient(low = "lightblue", high = "darkblue") +  # Gradient scale for color
   labs(
     x = "Flipper Length (mm)",
     y = "Body Mass (g)",
     color = "Bill Depth (mm)"  # Label for the color legend
   ) +
   theme_minimal()
 
 
 
 ggplot(
   data = penguins,
   mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
 ) +
   geom_point() +
   geom_smooth(se=FALSE) 
 
 
#Will these two graphs look different? Why/why not?
#ans: Yes, from my previous understanding, the attributes set globally are inherited by the geoms
   ggplot(
     data = penguins,
     mapping = aes(x = flipper_length_mm, y = body_mass_g)
   ) +
   geom_point() +
   geom_smooth()
 
 ggplot() +
   geom_point(
     data = penguins,
     mapping = aes(x = flipper_length_mm, y = body_mass_g)
   ) +
   geom_smooth(
     data = penguins,
     mapping = aes(x = flipper_length_mm, y = body_mass_g)
   ) 
 
 #END OF THIS EXERCISE ↑ ----------------------------------------------------------

 
 
#bar graph with categorical data  
ggplot(
  penguins,
  aes(x = fct_infreq(species))
)+
  geom_bar()
 
#histogram with numerical data (continous)
 ggplot(
   penguins,
   aes(x = body_mass_g)
 )+
   geom_histogram(binwidth = 200)
#experimenting with bindwidths for histograms
 ggplot(penguins, aes(x = body_mass_g)) +
   geom_histogram(binwidth = 20)
 ggplot(penguins, aes(x = body_mass_g)) +
   geom_histogram(binwidth = 2000)
 
#Density plot
 ggplot(penguins, aes(x = body_mass_g)) +
   geom_density()
 
 
# 1.4.3 Exercises ------------------------------------------------------------------
#Make a bar plot of species of penguins, where you assign species to the y aesthetic. How is this plot different?
 #the bars are in a different direction (horizontal rather than vertical)
 ggplot(
   penguins,
   aes(y=species)
 )+
   geom_bar()
 

 
 #How are the following two plots different? Which aesthetic, color or fill, is more useful for changing the color of bars?
#ans: my guess was fill. Color is the outline of the bars and fill is the color of the bars
   ggplot(penguins, aes(x = species)) +
   geom_bar(color = "red")
 
 ggplot(penguins, aes(x = species)) +
   geom_bar(fill = "red")
 
 
 
 #What does the bins argument in geom_histogram() do?
 #Number of bins. Overridden by binwidth. Defaults to 30.
 ggplot(penguins, aes(x = body_mass_g)) +
   geom_histogram()
?geom_histogram
 summary(diamonds)
 dim(diamonds)    #gets the number of rows and columns
 names(diamonds)  #see the column names
 
 #Make a histogram of the carat variable in the diamonds dataset that is available when you load the tidyverse package. Experiment with different binwidths. What binwidth reveals the most interesting patterns?
 data("diamonds")
 ?diamonds
 view(diamonds)
 glimpse(diamonds)
 ggplot(
   diamonds, 
   aes(x=carat)
  ) +
  geom_histogram(fill="steelblue", color="black", binwidth = 0.1) +
  ggtitle("Histogram of Price Values")
 #0.1 reveals the most interesting results in my opinion. 0.0.1 does also because it looks like there is a repeating trend.
 
 #create scatterplot of carat vs. price, using cut as color variable
 ggplot(
  diamonds,
  aes(x=carat, y=price, color=cut)
 )+
  geom_point()
 
 
 #END OF THIS EXERCISE ↑ ----------------------------------------------------------
 
 
#an alternative of a histogram
 ggplot(penguins, aes(x = body_mass_g)) +
   geom_freqpoly()
?geom_freqpoly 
 
 
# a box plot
 ggplot(penguins, aes(x = species, y = body_mass_g)) +
   geom_boxplot()

#a geom density graph
ggplot(
  penguins,
  aes(x = body_mass_g, color=species)
) +
  geom_density(linewidth=0.75)
 

ggplot(
  penguins, 
  aes(x=body_mass_g, color=species, fill=species)
)+
  geom_density(alpha=0.2)
 

#note: having the two categories stacked like this creates a stacked-bar plot
ggplot(
  penguins,
  aes(x = island, fill=species)
)+
  geom_bar()
 
 
#using fill in a bar geom to get a relative frequency plot (setting postion to "fill")
ggplot(
  penguins,
  aes(x = island, fill=species)
) +
  geom_bar(position = "fill")
 
 
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
 
 
 #three or more variables (done by mapping additional categories to aesthetics)
 ggplot(
   penguins,
   aes(x=flipper_length_mm, y=body_mass_g)
 )+
   geom_point(aes(color=island, shape=species))
 
 
 #ADDING TOO MANY AESTHETIC MAPPINGS makes it cluttered and difficult to make sense of.
 #splitting the plot into facets(subplots) that each display one subset of data.
 #we use facet_wrap() but REMEMBER THAT THE PARAMETER MUST BE CATEGORICAL
 
 ggplot(
   penguins,
   aes(x=flipper_length_mm, y=body_mass_g)
 )+
   geom_point(
     aes(color=species, shape=island)
   )+
   facet_wrap(
     ~island
   )
 
 
 
 
 
 # 1.5.5 Exercises ------------------------------------------------------------------
#The mpg data frame that is bundled with the ggplot2 package contains 234 observations collected by the US Environmental Protection Agency on 38 car models. Which variables in mpg are categorical? Which variables are numerical? (Hint: Type ?mpg to read the documentation for the dataset.) How can you see this information when you run mpg?
?mpg
 view(mpg)
 
 #to see the list of columns(variables in this dataset)
 names(mpg)
 #categorical variables=> manufacturer, trans, driv, fl, class 
 #numerical variables=> model, displ, year, cyl, cty, hwy
 
 #to see the number of rows and columns: 234 rows and 11 columns
 dim(mpg)
 

 
 
#Make a scatterplot of hwy vs. displ using the mpg data frame. Next, map a third, numerical variable to color, then size, then both color and size, then shape. How do these aesthetics behave differently for categorical vs. numerical variables?
 
ggplot(
  mpg,
  aes(x=hwy, y=displ)
) +
  geom_point(
    aes(color=cyl)
  )#color mapped to cyl

ggplot(
  mpg,
  aes(x=hwy, y=displ)
) +
  geom_point(
    aes(size=cty)
  )#size mapped to cty

ggplot(
  mpg,
  aes(x=hwy, y=displ)
) +
  geom_point(
    aes(color=cyl, size=cty)
  )# color mapped to cyl and size mapped to cty

ggplot(
  mpg,
  aes(hwy,displ)
) +
  geom_point(
    aes(shape=cyl)
  ) + 
  scale_shape_binned()# shape mapped to cyl (needs the scale_shape_binned() function)
?aes
 


#In the scatterplot of hwy vs. displ, what happens if you map a third variable to linewidth?
#ans=> we get the following warning message:
#Warning message:
  #In geom_point(aes(linewidth = cyl)) :
  #Ignoring unknown aesthetics: linewidth
ggplot(
  mpg,
  aes(x=hwy, y=displ)
) +
  geom_point(
    aes(linewidth=cyl)
  )


#What happens if you map the same variable to multiple aesthetics?
#ans=> They are all collected into one in the labeling of the plot on the right side, making more variations for the same variable.
ggplot(
  mpg,
  aes(x=hwy, y=displ)
) +
  geom_point(
    aes(shape=drv, color=drv, size=drv)
  )

unique(mpg$trans) #gets the unique values from a column in a dataset


ggplot(mpg, aes(x = displ, y = hwy, color = class, size = class)) + #sets a variable for two aeshetic values
  geom_point() +
  scale_color_brewer(palette = "Set3") +              #sets the colors for the points
  scale_size_manual(values = c(1,2,3,4,5,6,7)) +      #adjusts the size of the shapes
  labs(color = "Car Class", size = "Car Class")      #having the same name collects two labels into one, if they are similar
  


#Make a scatterplot of bill_depth_mm vs. bill_length_mm and color the points by species. What does adding coloring by species reveal about the relationship between these two variables? What about faceting by species?
#its lets us better understand the ration of the bill depth and bill length in the different species of us penguins. It teaches us what relationship the species of a penguin has with is bodily features. 
ggplot(
  penguins,
  aes(bill_depth_mm, bill_length_mm, color=species)
)+
  geom_point()
  

#Why does the following yield two separate legends? How would you fix it to combine the two legends?
#ans=> as previously learned, having aesthetics labeled with the same name, given they are similar, collects them both into one label.
  ggplot(
    data = penguins,
    mapping = aes(
      x = bill_length_mm, y = bill_depth_mm, 
      color = species, shape = species
    )
  ) +
  geom_point() +
  labs(color = "Species", shape="Species")



  
#Create the two following stacked bar plots. Which question can you answer with the first one? Which question can you answer with the second one?
#ans=>With the first graph you can answer what percentage of each penguin species are occupying each island.
#with the second plot you can answer what which species of penguins are found on each island.
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill")


 
 
 #END OF THIS EXERCISE ↑ ----------------------------------------------------------
 
 
 
 
 
 
 
 
 
 