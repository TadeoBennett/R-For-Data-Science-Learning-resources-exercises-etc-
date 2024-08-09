install.packages("nycflights13")
library(tidyverse)
library(nycflights13)

?flights

flights

#VERBS (FUNCTIONS)
#THE dplyr library 


#ROWS ---------------------------------------------------------------------
#important verbs that operate on rows of dataset are: 
#1. filter() changes which rows are present, and not the order.
#2. arrange()  changes the rows' order but not which are present.
#3.distinct() which finds rows with unique values, can also modify colums.



#FILTER() --------------------------------------------
#filter() allows you to keep rows based on the values of the columns1. The first argument is the data frame. The second and subsequent arguments are the conditions that must be true to keep the row.
flights |>
  filter(dep_delay > 120)

#conditional types => ==, !=, > , <, >=, <=, &, and, or, |
flights =>
  filter(month ==1 & day ==1) #flights that departed on Jan 1

# Flights that departed in January or February
flights |> 
  filter(month == 1 | month == 2)

# A shorter way to select flights that departed in January or February
flights|>
  filter(month %in% c(1,2))


#Saving the results of a dplyr function using the assignment operator <-
jan1 <- flights |>
  filter(month == 1 & day ==1)




#ARRANGE() ------------------------------------------
#If you provide more than one column name, each additional column will be used to break ties in the values of preceding columns.
flights |> 
  arrange(year, month, day, dep_time)

#descending order
flights |> 
  arrange(desc(dep_delay))


#DISTINCT() -----------------------------------------
#distinct() finds all the unique rows in a dataset, so in a technical sense, it primarily operates on the rows. Most of the time, however, you’ll want the distinct combination of some variables, so you can also optionally supply column names:
flights

flights |> 
  distinct()

# Find all unique origin and destination pairs
flights |>
  distinct(origin, dest)

#Alternatively, if you want to the keep other columns when filtering for unique rows, you can use the .keep_all = TRUE option.
flights |>
  distinct(origin, dest, .keep_all = TRUE)

#NOTE: distinct() will find the first occurrence of a unique row in the dataset and discard the rest.
#If you want to find the number of occurrences instead, you’re better off swapping distinct() for count(), and with the sort = TRUE argument you can arrange them in descending order of number of occurrences.
view(flights|>
  count(origin, dest, sort = TRUE))  # returns the unique rows by first grouping all the ones that are the same and creating a column with the count of how many times it was repeated.





#Exercise 3.2.5 Exercises ---------------------------------------------
#1.In a single pipeline for each condition, find all flights that meet the condition:
  #Had an arrival delay of two or more hours
  #Flew to Houston (IAH or HOU)
  #Were operated by United, American, or Delta
  #Departed in summer (July, August, and September)
  #Arrived more than two hours late, but didn’t leave late
  #Were delayed by at least an hour, but made up over 30 minutes in flight
tech = flights |>
  filter(
    arr_delay >= 120,             # Had an arrival delay of two or more hours
    dest %in% c("IAH", "HOU"),    # Flew to Houston (IAH or HOU)
    carrier %in% c("UA", "AA", "DL"),  # Were operated by United, American, or Delta
    month %in% c(7, 8, 9),         # Departed in summer (July, August, and September)
    arr_delay > 120,              # Arrived more than two hours late
    #dep_delay <= 0,               # Didn’t leave late (WONT WORK BECAUSE UP TO THIS POINT, ALL FLIGHTS WERE DELAYED FOR MORE THAN 12O MINUTES)
    dep_delay >= 60,              # Delayed by at least an hour
    arr_delay - dep_delay > 30    # Made up over 30 minutes in flight
  )
  tech                             #testing the value
flights
unique(flights$month)


#Sort flights to find the flights with longest departure delays. Find the flights that left earliest in the morning.
flights|>
  arrange(
  desc(dep_delay)
  )#finds flights with the longest departure delays by sorting in descending order the dep_delay values.


flights|>
  arrange(dep_time) #sorts flights by dep_time. Lets us see which flights left the earliest


#COME BACK TO THIS PROBLEM
#Sort flights to find the fastest flights. (Hint: Try including a math calculation inside of your function.)



#Was there a flight on every day of 2013?
flights|>
  count(
    month,
    day
  )


#Which flights traveled the farthest distance? Which traveled the least distance?



#Does it matter what order you used filter() and arrange() if you’re using both? Why/why not? Think about the results and how much work the functions would have to do.
#ans=> It is easier on larger datasets to have it be filtered before being arranged.



#END OF EXERCISE ------------------------------------------------------


#COLUMNS ------------------------------------------------------------

#There are four important verbs that affect the columns without changing the rows: mutate() creates new columns that are derived from the existing columns, select() changes which columns are present, rename() changes the names of the columns, and relocate() changes the positions of the columns.

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )


#By default, mutate() adds new columns on the right hand side of your dataset, which makes it difficult to see what’s happening here. We can use the .before argument to instead add the variables to the left hand side2:
#USING .BEFORE
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )#the . (dot) is to signal that it is an ARGUMENT to the function, not a variable

#USING .AFTER
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )       #here .after is being used to insert this new column after the "day" column


#Alternatively, you can control which variables are kept with the .keep argument. A particularly useful argument is "used" which specifies that we only keep the columns that were involved or created in the mutate() step. For example, the following output will contain only the variables dep_delay, arr_delay, air_time, gain, hours, and gain_per_hour.
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )




#SELECT() ------------------------------------------------------------

#Select columns by name:
flights |> 
  select(year, month, day)

#Select all columns between year and day (inclusive):
flights |> 
  select(year:day)

#Select all columns except those from year to day (inclusive):
flights |> 
  select(!year:day)

#Select all columns that are characters:
flights|>
  select(where(is.character))




















