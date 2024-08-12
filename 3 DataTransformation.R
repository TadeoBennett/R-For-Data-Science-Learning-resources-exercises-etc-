install.packages("nycflights13")
install.packages("tidyverse")
library(tidyverse)
library(nycflights13)

?flights

glimpse(flights)

# VERBS (FUNCTIONS)
# THE dplyr library


# ROWS ---------------------------------------------------------------------
# important verbs that operate on rows of dataset are:
# 1. filter() changes which rows are present, and not the order.
# 2. arrange()  changes the rows' order but not which are present.
# 3.distinct() which finds rows with unique values, can also modify colums.



# FILTER() --------------------------------------------
# filter() allows you to keep rows based on the values of the columns1. The first argument is the data frame. The second and subsequent arguments are the conditions that must be true to keep the row.
flights |>
  filter(dep_delay > 120)

# conditional types : ==, !=, > , <, >=, <=, &, and, or, |
flights |>
  filter(month == 1 & day == 1) # flights that departed on Jan 1

# Flights that departed in January or February
flights |>
  filter(month == 1 | month == 2)

# A shorter way to select flights that departed in January or February
flights |>
  filter(month %in% c(1, 2))


# Saving the results of a dplyr function using the assignment operator <-
jan1 <- flights |>
  filter(month == 1 & day == 1)




# ARRANGE() ------------------------------------------
# If you provide more than one column name, each additional column will be used to break ties in the values of preceding columns.
flights |>
  arrange(year, month, day, dep_time)

# descending order
flights |>
  arrange(desc(dep_delay))


# DISTINCT() -----------------------------------------
# distinct() finds all the unique rows in a dataset, so in a technical sense, it primarily operates on the rows. Most of the time, however, you’ll want the distinct combination of some variables, so you can also optionally supply column names:
flights

flights |>
  distinct()

# Find all unique origin and destination pairs
flights |>
  distinct(origin, dest)

# Alternatively, if you want to the keep other columns when filtering for unique rows, you can use the .keep_all = TRUE option.
flights |>
  distinct(origin, dest, .keep_all = TRUE)

# NOTE: distinct() will find the first occurrence of a unique row in the dataset and discard the rest.
# If you want to find the number of occurrences instead, you’re better off swapping distinct() for count(), and with the sort = TRUE argument you can arrange them in descending order of number of occurrences.
view(flights |>
  count(origin, dest, sort = TRUE)) # returns the unique rows by first grouping all the ones that are the same and creating a column with the count of how many times it was repeated.





# Exercise 3.2.5 Exercises ---------------------------------------------
# 1.In a single pipeline for each condition, find all flights that meet the condition:
# Had an arrival delay of two or more hours
# Flew to Houston (IAH or HOU)
# Were operated by United, American, or Delta
# Departed in summer (July, August, and September)
# Arrived more than two hours late, but didn’t leave late
# Were delayed by at least an hour, but made up over 30 minutes in flight
tech <- flights |>
  filter(
    arr_delay >= 120, # Had an arrival delay of two or more hours
    dest %in% c("IAH", "HOU"), # Flew to Houston (IAH or HOU)
    carrier %in% c("UA", "AA", "DL"), # Were operated by United, American, or Delta
    month %in% c(7, 8, 9), # Departed in summer (July, August, and September)
    arr_delay > 120, # Arrived more than two hours late
    # dep_delay <= 0,               # Didn’t leave late (WONT WORK BECAUSE UP TO THIS POINT, ALL FLIGHTS WERE DELAYED FOR MORE THAN 12O MINUTES)
    dep_delay >= 60, # Delayed by at least an hour
    arr_delay - dep_delay > 30 # Made up over 30 minutes in flight
  )
tech # testing the value
flights
unique(flights$month)


# Sort flights to find the flights with longest departure delays. Find the flights that left earliest in the morning.
flights |>
  arrange(
    desc(dep_delay)
  ) # finds flights with the longest departure delays by sorting in descending order the dep_delay values.


flights |>
  arrange(dep_time) # sorts flights by dep_time. Lets us see which flights left the earliest


# COME BACK TO THIS PROBLEM
# Sort flights to find the fastest flights. (Hint: Try including a math calculation inside of your function.)



# Was there a flight on every day of 2013?
flights |>
  count(
    month,
    day
  )


# Which flights traveled the farthest distance? Which traveled the least distance?



# Does it matter what order you used filter() and arrange() if you’re using both? Why/why not? Think about the results and how much work the functions would have to do.
# ans: It is easier on larger datasets to have it be filtered before being arranged.



# END OF EXERCISE ------------------------------------------------------


# COLUMNS ------------------------------------------------------------

# There are four important verbs that affect the columns without changing the rows: mutate() creates new columns that are derived from the existing columns, select() changes which columns are present, rename() changes the names of the columns, and relocate() changes the positions of the columns.

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )


# By default, mutate() adds new columns on the right hand side of your dataset, which makes it difficult to see what’s happening here. We can use the .before argument to instead add the variables to the left hand side2:
# USING .BEFORE
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  ) # the . (dot) is to signal that it is an ARGUMENT to the function, not a variable

# USING .AFTER
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  ) # here .after is being used to insert this new column after the "day" column


# Alternatively, you can control which variables are kept with the .keep argument. A particularly useful argument is "used" which specifies that we only keep the columns that were involved or created in the mutate() step. For example, the following output will contain only the variables dep_delay, arr_delay, air_time, gain, hours, and gain_per_hour.
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )




# SELECT() ------------------------------------------------------------

# Select columns by name:
flights |>
  select(year, month, day)

# Select all columns between year and day (inclusive):
flights |>
  select(year:day)

# Select all columns except those from year to day (inclusive):
flights |>
  select(!year:day)

# Select all columns that are characters:
flights |>
  select(where(is.character))


# There are a number of helper functions you can use within select():

# starts_with("abc"): matches names that begin with “abc”.
# ends_with("xyz"): matches names that end with “xyz”.
# contains("ijk"): matches names that contain “ijk”.
# num_range("x", 1:3): matches x1, x2 and x3.




# You can rename variables as you select() them by using =. The new name appears on the left hand side of the =, and the old variable appears on the right hand side:
# returns just one row
flights |>
  select(tail_num = tailnum)
?flights

# rename() - renames one column, and returns all the rest of rows
flights |>
  rename(tail_num = tailnum)


# TO AUTOMATICALLY NAME AND FIX VARIABLES WITH CONSISTENCY, USE janitor::clean_names()


# relocate()
# Use relocate() to move variables around. You might want to collect related variables together or move important variables to the front. By default relocate() moves variables to the front:
flights |>
  relocate(time_hour, air_time)

# you can then use .before and .after to specify where to put them just like in mutate
view(
  flights |>
    relocate(year:dep_time, .after = time_hour)
) # moves columns from year to dep_time to after time_hour


flights |>
  relocate(starts_with("arr"), .before = dep_time)






# 3.3.5 Exercises ----------------------------------------------------------
# Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
# ans: the dep_delay is the difference of the dep_time and the sched_dep_time
flights |>
  select(
    dep_time, sched_dep_time, dep_delay
  )


# Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
flights |>
  select(dep_time, dep_delay, arr_time, arr_delay) # using select
flights |>
  distinct(dep_time, dep_delay, arr_time, arr_delay) # using distinct
flights[, c("dep_time", "dep_delay", "arr_time", "arr_delay")] # using base R
flights |>
  select(matches("^(dep_time|dep_delay|arr_time|arr_delay)$")) # using regexp
flights |>
  select(any_of(c("dep_time", "dep_delay", "arr_time", "arr_delay"))) # using any_of(), as mentioned below and then researched




# What happens if you specify the name of the same variable multiple times in a select() call?
# ans: the variable is ignored in the output
flights |>
  select(dep_time, arr_delay, arr_delay)



# What does the any_of() function do? Why might it be helpful in conjunction with this vector?
# ans:These selection helpers select variables contained in a character vector. They are especially useful for programming with selecting functions. So the vector below can be used in the select function to look for and return matching columns with no errors or warnings if a variable name was not found in the dataframe.
?any_of()
variables <- c("year", "month", "day", "dep_delay", "arr_delay")



# Does the result of running the following code surprise you? How do the select helpers deal with upper and lower case by default? How can you change that default?
flights
flights |> select(contains("TIME"))



# Rename air_time to air_time_min to indicate units of measurement and move it to the beginning of the data frame.
?flights
flights |>
  rename(air_time_min = air_time) |> # use the pipeline again to further add functions to edit the columns
  relocate(air_time_min, .before = 1)






# why doesn’t the following work, and what does the error mean?
# ans: because as you pass through your pipelines, just as in filter, you are breaking the dataframe down and returning a new dataframe. In this case, just the tailnum column was selected, hence the dataframe in memory at this point has just that column. Therefore, there is no other columns(arr_delay) in the datafram to arrange by.
flights |>
  select(tailnum) |>
  arrange(arr_delay)
#> Error in `arrange()`:
#> ℹ In argument: `..1 = arr_delay`.
#> Caused by error:
#> ! object 'arr_delay' not found



# END OF EXERCISE -------------------------------------------------------



# 3.4 The pipe -------------

# its real power arises when you start to combine multiple verbs. For example, imagine that you wanted to find the fastest flights to Houston’s IAH airport: you need to combine filter(), mutate(), select(), and arrange():

flights |>
  filter(dest == "IAH") |>
  mutate(speed = distance / air_time * 60) |>
  select(year:day, dep_time, carrier, flight, speed) |>
  arrange(desc(speed))
#> # A tibble: 7,198 × 7
#>    year month   day dep_time carrier flight speed
#>   <int> <int> <int>    <int> <chr>    <int> <dbl>
#> 1  2013     7     9      707 UA         226  522.
#> 2  2013     8    27     1850 UA        1128  521.
#> 3  2013     8    28      902 UA        1711  519.
#> 4  2013     8    28     2122 UA        1022  519.
#> 5  2013     6    11     1628 UA        1178  515.
#> 6  2013     8    27     1017 UA         333  515.
#> # ℹ 7,192 more rows


# If we didn't have the pipe, we'd have to nest these functions:
arrange(
  select(
    mutate(
      filter(
        flights,
        dest == "IAH"
      ),
      speed = distance / air_time * 60
    ),
    year:day, dep_time, carrier, flight, speed
  ),
  desc(speed)
)
# or a bunch of intermediate objects
flights1 <- filter(flights, dest == "IAH")
flights2 <- mutate(flights1, speed = distance / air_time * 60)
flights3 <- select(flights2, year:day, dep_time, carrier, flight, speed)
arrange(flights3, desc(speed))




# 3.5.1 group_by()  --------------------------------
flights |>
  group_by(month)
# group_by() doesn’t change the data but, if you look closely at the output, you’ll notice that the output indicates that it is “grouped by” month (Groups: month [12]). This means subsequent operations will now work “by month”. group_by() adds this grouped feature (referred to as class) to the data frame, which changes the behavior of the subsequent verbs applied to the data.


# 3.5.2 summarize()
flights |>
  group_by(month) |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE) # we use the na.rm value to ignore the NA values in our dataframe gotten from missing values in the column
  )


# the n() summary function lets us count the number of rows in each group
flights |>
  group_by(month) |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    num = n()
  )



# 3.5.3 The slice_ functions -----------------
flights |>
  slice_head(n = 1) # takes the first row from each group.

flights |>
  slice_tail(n = 1) # takes the last row in each group.

flights |>
  slice_min(air_time, n = 1) # takes the row with the smallest value of column x.

flights |>
  slice_max(air_time, n = 1) # takes the row with the largest value of column x.

flights |>
  slice_sample(n = 1) # takes one random row.

# You can vary n to select more than one row, or instead of n =, you can use prop = 0.1 to select (e.g.) 10% of the rows in each group. For example, the following code finds the flights that are most delayed upon arrival at each destination:
flights |>
  slice_min(air_time, prop = 0.001)




flights |>
  group_by(dest) |>
  slice_max(arr_delay, n = 1) |>
  relocate(dest)
#> # A tibble: 108 × 19
#> # Groups:   dest [105]
#>   dest   year month   day dep_time sched_dep_time dep_delay arr_time
#>   <chr> <int> <int> <int>    <int>          <int>     <dbl>    <int>
#> 1 ABQ    2013     7    22     2145           2007        98      132
#> 2 ACK    2013     7    23     1139            800       219     1250
#> 3 ALB    2013     1    25      123           2000       323      229
#> 4 ANC    2013     8    17     1740           1625        75     2042
#> 5 ATL    2013     7    22     2257            759       898      121
#> 6 AUS    2013     7    10     2056           1505       351     2347
#> # ℹ 102 more rows
#> # ℹ 11 more variables: sched_arr_time <int>, arr_delay <dbl>, …

# Note that there are 105 destinations but we get 108 rows here. What’s up? slice_min() and slice_max() keep tied values so n = 1 means give us all rows with the highest value. If you want exactly one row per group you can set with_ties = FALSE.
# This is similar to computing the max delay with summarize(), but you get the whole corresponding row (or rows if there’s a tie) instead of the single summary statistic.
flights |>
  group_by(dest) |>
  slice_max(arr_delay, n = 1, with_ties = FALSE) |>
  relocate(dest)



# 3.5.4 Grouping by multiple variables --------------


# 3.5.4 Grouping by multiple variables ---------------------------
# You can create groups using more than one variable. For example, we could make a group for each date.
daily <- flights |>
  group_by(year, month, day)
daily
# When you summarize a tibble grouped by more than one variable, each summary peels off the last group


daily_flights <- daily |>
  summarize(n = n())
daily_flights
#> `summarise()` has grouped okeep()#> `summarise()` has grouped output by 'year', 'month'. You can override using
#> the `.groups` argument.
# If you’re happy with this behavior, you can explicitly request it in order to suppress the message:
daily_flights <- daily |>
  summarize(
    n = n(),
    .groups = "drop_last"
  )
daily_flights





# 3.5.5 Ungrouping --------------------------------------------------

daily |>
  ungroup()
#> # A tibble: 336,776 × 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
#> 1  2013     1     1      517            515         2      830            819
#> 2  2013     1     1      533            529         4      850            830
#> 3  2013     1     1      542            540         2      923            850
#> 4  2013     1     1      544            545        -1     1004           1022
#> 5  2013     1     1      554            600        -6      812            837
#> 6  2013     1     1      554            558        -4      740            728
#> # ℹ 336,770 more rows
#> # ℹ 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>, …

# SUMMARIZING AN UNGROUPED DATAFRAME (IT GETS TREATED LIKE ON GROUP)
daily |>
  ungroup() |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), flights = n()
  )



# 3.5.6 .by -----------------------------------------------------
# dplyr 1.1.0 includes a new, experimental, syntax for per-operation grouping, the .by argument. group_by() and ungroup() aren’t going away, but you can now also use the .by argument to group within a single operation:
# NOTE THAT BEFORE IT WAS DOING GROUP_BY AND THEN SUMMARIZE. NOW ITS JUST summarize() AND .by IS AN ARGUMENT IN THAT FUNCTION
flights |>
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = month
  )

# Or if you want to group by multiple variables:
flights |>
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = c(origin, dest)
  )
# .by works with all verbs and has the advantage that you don’t need to use the .groups argument to suppress the grouping message or ungroup() when you’re done.




# 3.5.7 Exercises ------------------------------------------------------

# Which carrier has the worst average delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights |> group_by(carrier, dest) |> summarize(n()))
# ans:Yes we disentangle bad carriers from bad airports by identifying either bad trends, or bad averages. Further tests can done to learn the delays between origins and their destinations, along with related flight carriers. Perhaps more flights and carriers are on average delayed when coming from and going to certain airports. Or certain carriers have an all round bad delay average when going to all airports.
flights |>
  group_by(carrier) |>
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
  ) |>
  mutate(
    total_delay = avg_dep_delay + avg_arr_delay
  ) |>
  arrange(desc(avg_arr_delay)) |> # Sort by worst average arrival delay
  mutate(
    n = n()
  )

flights |>
  group_by(carrier, dest) |>
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    n = n() # Number of flights for this carrier-dest pair
  ) |>
  arrange(desc(avg_arr_delay)) # Sort by worst average arrival delay



# Find the flights that are most delayed upon departure from each destination.
flights |>
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = c(flight, dest)
  ) |>
  arrange(desc(avg_dep_delay))




# How do delays vary over the course of the day. Illustrate your answer with a plot.
# ans:#It increase overtime in the morning before 5am. Peak delay times are around 2:30 am.
library(ggplot2)
?flights

dep_delay_perday <- flights |>
  select(day, dep_delay, arr_delay, carrier, origin, dest) |>
  group_by(day)

dep_delay_perday

dep_delay_perday_clean <- dep_delay_perday |>
  filter(!is.na(dep_delay), !is.na(arr_delay))

dep_delay_perday_clean

ggplot(
  dep_delay_perday,
  aes(dep_delay, arr_delay)
) +
  geom_point(
    mapping = aes(color = carrier)
  ) +
  geom_smooth(method = "lm", na.rm = TRUE)


# using chatgpt
# Extract the Hour of Departure
flights_with_hour <- flights %>%
  mutate(hour = floor(dep_time / 100)) # Extract the hour from dep_time (assuming dep_time is in HHMM format)

## Calculate Average Delays by Hour
delays_by_hour <- flights_with_hour %>%
  group_by(hour) %>%
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    n = n() # Number of flights in each hour
  )

# Plot the Results
ggplot(delays_by_hour, aes(x = hour)) +
  geom_line(aes(y = avg_dep_delay, color = "Departure Delay")) +
  geom_line(aes(y = avg_arr_delay, color = "Arrival Delay")) +
  labs(
    title = "Average Delays by Hour of the Day",
    x = "Hour of the Day",
    y = "Average Delay (minutes)"
  ) +
  scale_color_manual(name = "Delay Type", values = c("Departure Delay" = "blue", "Arrival Delay" = "red"))





# What happens if you supply a negative n to slice_min() and friends?
# it basically does the opposite of what its supposed to do and sort of removes the count of the rows provided in the argument.
# in the slice_tail, if a negative number is provided, the positive value of that number is the number of rows that gets removed from the head of the tibble. the opposite happens for slice_head
# in the slice_head, if a negative number is provided, the positive value of that number is the number of rows that gets removed from the tail of the tibble.
# for min it looks for the max and removes the number of rows specified in the function. Results are still provided in asc order.
# for max it looks for min and doesn't count the number of rows specified in the function.Results are still provided in desc order.
#
flights
dim(flights)
tail(flights)

tail(flights |>
  slice_head(n = -1))

flights |>
  slice_tail(n = -2) # removes the header rows

flights |>
  slice_min(air_time, n = -1)

flights |>
  slice_max(air_time, n = -1)

flights |>
  slice_sample(n = -1)


data <- tibble(
  x = c(5, 2, 9, 4, 7)
)

# in order: 2,4,5,7,9

data |> slice_min(x, n = 2) # 2,4
data |> slice_min(x, n = -2) # 2,4,5

data |> slice_max(x, n = 2) # 9,7
data |> slice_max(x, n = -2) # 9,7,5



# Explain what count() does in terms of the dplyr verbs you just learned. What does the sort argument to count() do?
# count() lets you quickly count the unique values of one or more variables. The sort argument, If TRUE, will show the largest groups at the top.
?count

flights |>
  group_by(carrier) |>
  count(name = "Number of rows with carrier", sort = TRUE)

total_rows_direct <- nrow(flights)
print(total_rows_direct)





# Suppose we have the following tiny data frame:

df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)
df

# Write down what you think the output will look like, then check if you were correct, and describe what group_by() does.
# it will return all rows as is. It just sets up the data for grouped operations for unique values in the y column
df |>
  group_by(y)


# Write down what you think the output will look like, then check if you were correct, and describe what arrange() does. Also comment on how it’s different from the group_by() in part (a).
# it will order the rows by the y column alphabetically. It is not grouped
df |>
  arrange(y)


# Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does.
# it sets up groups of the unique values in the y column and finds the average using each groups x-row values. the pipeline tacks on the operation of finding the mean after grouping
df |>
  group_by(y) |>
  summarize(mean_x = mean(x))


# Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does. Then, comment on what the message says.
# It will group first by the y column, then by the z column. Next, it will find the average of x's rows for each grouped column, add it to a new column called mean_x, then return a tibble.
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))
# my provided description is not enough I believe. I asked chatgpt for a better description:
# Groups the data by each unique combination of y and z, meaning that each group is defined by every distinct pair of values in y and z. It then calculates the mean of x for each of these groups, creates a new column mean_x to store these means, and returns a tibble where each row represents a unique combination of y and z with the corresponding average value of x.



# Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does. How is the output different from the one in part (d)?
# ANS:My guess is that it will only display the x averages that were grouped by the y and z columns. The pipeline first groups the y and z columns and then all levels of groupings are dropped because of the second function attached by the pipeline.
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "drop")
# I was wrong. It does not drop the columns just the groupings. So just like how when writing "df |> group_by(y)" does nothing but groups the columns, this code removes that grouping. The look of the tibble is unaffected.



# Write down what you think the outputs will look like, then check if you were correct, and describe what each pipeline does. How are the outputs of the two pipelines different?
# The code below groups the y and z columns by their unique values. With the groupings it performs an average on the rows with the x values related to those groupings. It then creates the mean_x columns and add the mean of the x values in the rows of the appropriate groupings.
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))


# The code below groups the y and z columns by their unique values.It then creates a new column called mean_x with the averages of the grouped x rows
df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))




# 3.6 Case study: aggregates and sample size ------------------------------------
# Whenever you do any aggregation, it’s always a good idea to include a count (n()). That way, you can ensure that you’re not drawing conclusions based on very small amounts of data. We’ll demonstrate this with some baseball data from the Lahman package. Specifically, we will compare what proportion of times a player gets a hit (H) vs. the number of times they try to put the ball in play (AB):
install.packages("Lahman")
library("Lahman")
batters <- Lahman::Batting |>
  group_by(playerID) |>
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE), n = sum(AB, na.rm = TRUE)
  )
batters


batters |>
  filter(n > 100) |>
  ggplot(aes(x = n, y = performance)) +
  geom_point(alpha = 1 / 10) +
  geom_smooth(se = FALSE)


# Note the handy pattern for combining ggplot2 and dplyr. You just have to remember to switch from |>, for dataset processing, to + for adding layers to your plot.

# This also has important implications for ranking. If you naively sort on desc(performance), the people with the best batting averages are clearly the ones who tried to put the ball in play very few times and happened to get a hit, they’re not necessarily the most skilled players:

batters |>
  arrange(desc(performance))
#> # A tibble: 20,469 × 3
#>   playerID  performance     n
#>   <chr>           <dbl> <int>
#> 1 abramge01           1     1
#> 2 alberan01           1     1
#> 3 banisje01           1     1
#> 4 bartocl01           1     1
#> 5 bassdo01            1     1
#> 6 birasst01           1     2
#> # ℹ 20,463 more rows

# You can find a good explanation of this problem and how to overcome it at http://varianceexplained.org/r/empirical_bayes_baseball/ and https://www.evanmiller.org/how-not-to-sort-by-average-rating.html.
