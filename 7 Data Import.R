library(tidyverse)



# HANDLING CSV FILES -------------------

# read_csv
students <- read_csv("data/students.csv")
dim(students)
glimpse(students)
students
# When you run read_csv(), it prints out a message telling you the number of rows and columns of data, the delimiter that was used, and the column specifications (names of columns organized by the type of data the column contains). It also prints out some information about retrieving the full column specification and how to quiet this message. This message is an integral part of readr.


# In the favourite.food column, there are a bunch of food items, and then the character string N/A, which should have been a real NA that R will recognize as “not available”. This is something we can address using the na argument. By default, read_csv() only recognizes empty strings ("") in this dataset as NAs, and we want it to also recognize the character string "N/A".



students_2 <- read_csv("data/students.csv", na = c("N/A", ""))
students_2
# this automatically reads cells in the csv with "N/A" and give it the N/A type so R recognizes it as no value.



# the first two columns names are surrounded with backticks. This breaks R's rules for variable names. Here's how to change them:
students_2 |>
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )


#An alternative approach is to use janitor::clean_names() to use some heuristics to turn them all into snake case at once.
library(janitor)
students |> 
  janitor::clean_names()
  
# A tibble: 6 × 5
#  student_id full_name        favourite_food     meal_plan           age  
#       <dbl> <chr>            <chr>              <chr>               <chr>
#1          1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    
#2          2 Barclay Lynn     French fries       Lunch only          5    
#3          3 Jayendra Lyne    N/A                Breakfast and lunch 7    
#4          4 Leon Rossini     Anchovies          Lunch only          NA   
#5          5 Chidiegwu Dunkel Pizza              Breakfast and lunch five 
#6          6 Güvenç Attila    Ice cream          Lunch only          6    



#Another common task after reading in data is to consider variable types. For example, meal_plan is a categorical variable with a known set of possible values, which in R should be represented as a factor
library(janitor)
students |> 
  janitor::clean_names() |>
  mutate(meal_plan = factor(meal_plan))

#Note that the values in the meal_plan variable have stayed the same, but the type of variable denoted underneath the variable name has changed from character (<chr>) to factor (<fct>).





#Before you analyze these data, you’ll probably want to fix the age column. Currently, age is a character variable because one of the observations is typed out as five instead of a numeric 5

students <- students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )

students
  



#7.2.2 Other arguments -----------------------------------------------------
#There are a couple of other important arguments that we need to mention, and they’ll be easier to demonstrate if we first show you a handy trick: read_csv() can read text strings that you’ve created and formatted like a CSV file:
read_csv(
  "a, b, c
  1, 2, 3,
  4, 5, 6"
)


#Usually, read_csv() uses the first line of the data for the column names, which is a very common convention. But it’s not uncommon for a few lines of metadata to be included at the top of the file. You can use skip = n to skip the first n lines or use comment = "#" to drop all lines that start with (e.g.) #:
#using the skip 
read_csv(
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  skip = 2
)

#using the comment
read_csv(
  "#The first line of metadata
  #The second line of metadata
  x,y,z
  1,2,3",
  comment = "#"
)


#In other cases, the data might not have column names. You can use col_names = FALSE to tell read_csv() not to treat the first row as headings and instead label them sequentially from X1 to Xn:
read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE
)


#Alternatively, you can pass col_names a character vector which will be used as the column names:
read_csv(
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z")
)




# 7.2.3 Other file types ------------------------------------------------------

#Once you’ve mastered read_csv(), using readr’s other functions is straightforward; it’s just a matter of knowing #which function to reach for:

#read_csv2() reads semicolon-separated files. These use ; instead of , to separate fields and are common in #countries that use , as the decimal marker.

#read_tsv() reads tab-delimited files.

#read_delim() reads in files with any delimiter, attempting to automatically guess the delimiter if you don’t specify it.

#read_fwf() reads fixed-width files. You can specify fields by their widths with fwf_widths() or by their positions with fwf_positions().

#read_table() reads a common variation of fixed-width files where columns are separated by white space.

#read_log() reads Apache-style log files.






# 7.2.4 Exercises --------------------------------------------------------------

#1.What function would you use to read a file where fields were separated with “|”?
#ans: I would use the read_delim() function because I can specify whatever delimiter to use.

#2.Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?
#ans: there are many that they both have in common
?read_csv
read_csv(
  file,
  col_names = TRUE,
  col_types = NULL,
  col_select = NULL,
  id = NULL,
  locale = default_locale(),
  na = c("", "NA"),
  quoted_na = TRUE,
  quote = "\"",
  comment = "",
  trim_ws = TRUE,
  skip = 0,
  n_max = Inf,
  guess_max = min(1000, n_max),
  name_repair = "unique",
  num_threads = readr_threads(),
  progress = show_progress(),
  show_col_types = should_show_types(),
  skip_empty_rows = TRUE,
  lazy = should_read_lazy()
)

?read_tsv
read_tsv(
  file,
  col_names = TRUE,
  col_types = NULL,
  col_select = NULL,
  id = NULL,
  locale = default_locale(),
  na = c("", "NA"),
  quoted_na = TRUE,
  quote = "\"",
  comment = "",
  trim_ws = TRUE,
  skip = 0,
  n_max = Inf,
  guess_max = min(1000, n_max),
  progress = show_progress(),
  name_repair = "unique",
  num_threads = readr_threads(),
  show_col_types = should_show_types(),
  skip_empty_rows = TRUE,
  lazy = should_read_lazy()
)



#3.What are the most important arguments to read_fwf()?
?read_fwf

#file
#col_positions
#col_types
#skip
#n_max
#trim_ws
#col_names

data <- read_fwf(
  file = "path/to/your/file.txt",
  col_positions = fwf_widths(c(5, 7, 10)),
  col_names = c("ID", "Name", "Value"),
  col_types = "cid",
  skip = 1,
  n_max = 100
)



#4. Sometimes strings in a CSV file contain commas. To prevent them from causing problems, they need to be surrounded by a quoting character, like " or '. By default, read_csv() assumes that the quoting character will be ". To read the following text into a data frame, what argument to read_csv() do you need to specify?
?read_csv
"x,y\n1,'a,b'"
#ans: quote("'")


#5. Identify what is wrong with each of the following inline CSV files. What happens when you run the code?
read_csv("a,b\n1,2,3\n4,5,6")
read_csv(
  "a,b
  1,2,3
  4,5,6"
) # ------ incorrect column counts so it'll have a parsing issue. When ran, the numbers 2,3 and 5,6 are joined to form one number.



#read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv(
  "a,b,c
  1,2
  1,2,3,4"
)# ------  parsing issue due to mismatched column and row counts. When ran, the first row is missing a cell in the c column. Also, values 3 and 4 is joined.



#read_csv("a,b\n\"1")
read_csv(
  "a,b
  \"1"
)# ------ parsing issue. When ran, a and b are headers but there is just one row. 1 is a value in the a column and a missing value occupies the cell under b.



#read_csv("a,b\n1,2\na,b")
read_csv(
  "a,b
  1,2
  a,b"
)# no issues. There will be two rows with two columns. Column headers are a and b. And the two rows contain 1,2 and a,b in each cell respectively.



#read_csv("a;b\n1;3")
read_csv(
  "a;b\n
  1;3"
)# no issues. It'll just be one occupied row with one column. 





#Practice referring to non-syntactic names in the following data frame by:

#Extracting the variable called 1.
#Plotting a scatterplot of 1 vs. 2.
#Creating a new column called 3, which is 2 divided by 1.
#Renaming the columns to one, two, and three.
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying

#1. Extracting....
annoying[,1]

# Plotting....
ggplot(
  annoying,
  aes(`1`,`2`)
) +
  geom_point() +
  labs(x = "1", y = "2", title = "Scatter Plot of 1 vs 2")

# Creating a new column...
annoying <- annoying |>
  mutate(`3` = `2` / `1`)
annoying #check 

# Renaming....
annoying <- annoying |>
  rename(
    "one" = `1`,
    "two" = `2`,
    "three" = `3`
  )

annoying #check



# 7.3 Controlling column types ------------------------------------------------
#A CSV file doesn’t contain any information about the type of each variable (i.e. whether it’s a logical, number, string, etc.), so readr will try to guess the type. This section describes how the guessing process works, how to resolve some common problems that cause it to fail, and, if needed, how to supply the column types yourself. Finally, we’ll mention a few general strategies that are useful if readr is failing catastrophically and you need to get more insight into the structure of your file.


## 7.3.1 Guessing types ----
#readr uses a heuristic to figure out the column types. For each column, it pulls the values of 1,0002 rows spaced evenly from the first row to the last, ignoring missing values. It then works through the following questions:

#Does it contain only F, T, FALSE, or TRUE (ignoring case)? If so, it’s a logical.
#Does it contain only numbers (e.g., 1, -4.5, 5e6, Inf)? If so, it’s a number.
#Does it match the ISO8601 standard? If so, it’s a date or date-time.
#Otherwise, it must be a string.

#You can see that behavior in action in this simple example:

read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")
#> # A tibble: 3 × 4
#>   logical numeric date       string
#>   <lgl>     <dbl> <date>     <chr> 
#> 1 TRUE        1   2021-01-15 abc   
#> 2 FALSE       4.5 2021-02-15 def   
#> 3 TRUE      Inf   2021-02-16 ghi





## 7.3.2 Missing values, column types, and problems
#The most common way column detection fails is that a column contains unexpected values, and you get a character column instead of a more specific type. One of the most common causes for this is a missing value, recorded using something other than the NA that readr expects.

simple_csv <- "
  x
  10
  .
  20
  30"

#If we read the above without any additional arguments, x becomes a character column:
read_csv(simple_csv) #check

#the dot is a missing value. If there's thousands of row with a few missing values represented by the dot, then we'll need to tell readr that x is a numeric column to learn where it fails. Therefore, use col_types argument,, which takes a named list where the names match the column names in the CSV file:
df <- read_csv(
  simple_csv, 
  col_types = list(x = col_double())
)

#Now read_csv() reports that there was a problem, and tells us we can find out more with problems():
problems(df)
# A tibble: 1 × 5
#   row   col expected actual file                                                         
#  <int> <int> <chr>    <chr>  <chr>                                                        
#1    3     1 a double .      C:/Users/tadeo/AppData/Local/Temp/RtmpYZFYLI/file618847506216


#This tells us that there was a problem in row 3, col 1 where readr expected a double but got a .. That suggests this dataset uses . for missing values. So then we set na = ".", the automatic guessing succeeds, giving us the numeric column that we want:
read_csv(simple_csv, na = ".")




# 7.3.3 Column types --------------------------------------------------------
#readr provides a total of nine column types for you to use

#col_logical() and col_double() read logicals and real numbers. They’re relatively rarely needed (except as above), since readr will usually guess them for you.
#col_integer() reads integers. We seldom distinguish integers and doubles in this book because they’re functionally equivalent, but reading integers explicitly can occasionally be useful because they occupy half the memory of doubles.
#col_character() reads strings. This can be useful to specify explicitly when you have a column that is a numeric identifier, i.e., long series of digits that identifies an object but doesn’t make sense to apply mathematical operations to. Examples include phone numbers, social security numbers, credit card numbers, etc.
#col_factor(), col_date(), and col_datetime() create factors, dates, and date-times respectively; you’ll learn more about those when we get to those data types in Chapter 16 and Chapter 17.
#col_number() is a permissive numeric parser that will ignore non-numeric components, and is particularly useful for currencies. You’ll learn more about it in Chapter 13.
#col_skip() skips a column so it’s not included in the result, which can be useful for speeding up reading the data if you have a large CSV file and you only want to use some of the columns.



#It’s also possible to override the default column by switching from list() to cols() and specifying .default:

another_csv <- "
x,y,z
1,2,3"
another_csv

read_csv(
  another_csv, 
  col_types = cols(.default = col_character())
)


read_csv(
  another_csv,
  col_types = cols_only(x = col_character())
)



# 7.4 Reading data from multiple files --------------------------------------
#For files that may have data spread across multiple files . With read_csv() you can read it all at once and stack them on top of each other in a single data frame.

sales_files <- c(
  "data/01-sales.csv",
  "data/02-sales.csv",
  "data/03-sales.csv"
)
sales_files  #saves a vector fo the file locations

read_csv(sales_files, id = "file")   #uses the vector with the file locations to stack all the files into one dataframe.



# Having many files to read in becomes cumbersome when having to type all the names. Instead use list.files() to find the files by matching a pattern.
sales_files <- list.files("data", pattern = "sales\\.csv$", full.names = TRUE)
sales_files
#> [1] "data/01-sales.csv" "data/02-sales.csv" "data/03-sales.csv"







# 7.5 Writing to a file ----------------------------------------------------
#readr also comes with two useful functions for writing data back to disk: write_csv() and write_tsv(). The most important arguments to these functions are x (the data frame to save) and file (the location to save it). You can also specify how missing values are written with na, and if you want to append to an existing file.

write_csv(students, "data/student_writing.csv")




#IMPORTANT: Now let’s read that csv file back in. Note that the variable type information that you just set up is lost when you save to CSV because you’re starting over with reading from a plain text file again:
students
#> # A tibble: 6 × 5
#>   student_id full_name        favourite_food     meal_plan             age
#>        <dbl> <chr>            <chr>              <fct>               <dbl>
#> 1          1 Sunil Huffmann   Strawberry yoghurt Lunch only              4
#> 2          2 Barclay Lynn     French fries       Lunch only              5
#> 3          3 Jayendra Lyne    <NA>               Breakfast and lunch     7
#> 4          4 Leon Rossini     Anchovies          Lunch only             NA
#> 5          5 Chidiegwu Dunkel Pizza              Breakfast and lunch     5
#> 6          6 Güvenç Attila    Ice cream          Lunch only              6
write_csv(students, "data/students-2.csv")
read_csv("data/students-2.csv")
#> # A tibble: 6 × 5
#>   student_id full_name        favourite_food     meal_plan             age
#>        <dbl> <chr>            <chr>              <chr>               <dbl>
#> 1          1 Sunil Huffmann   Strawberry yoghurt Lunch only              4
#> 2          2 Barclay Lynn     French fries       Lunch only              5
#> 3          3 Jayendra Lyne    <NA>               Breakfast and lunch     7
#> 4          4 Leon Rossini     Anchovies          Lunch only             NA
#> 5          5 Chidiegwu Dunkel Pizza              Breakfast and lunch     5
#> 6          6 Güvenç Attila    Ice cream          Lunch only              6




#This makes CSVs a little unreliable for caching interim results—you need to recreate the column specification every time you load in. There are two main alternatives:

#write_rds() and read_rds() are uniform wrappers around the base functions readRDS() and saveRDS(). These store data in R’s custom binary format called RDS. This means that when you reload the object, you are loading the exact same R object that you stored.

write_rds(students, "data/students.rds")
read_rds("data/students.rds")



#The arrow package allows you to read and write parquet files, a fast binary file format that can be shared across programming languages. We’ll return to arrow in more depth in Chapter 22.

install.packages("arrow")
library(arrow)
write_parquet(students, "data/students.parquet")

#Parquet tends to be much faster than RDS and is usable outside of R, but does require the arrow package.






# 7.6 Data entry --------------------------------------------------------------
#Sometimes you’ll need to assemble a tibble “by hand” doing a little data entry in your R script. There are two useful functions to help you do this which differ in whether you layout the tibble by columns or by rows. tibble() works by column:

#BY COLUMN
tibble(
  x = c(1, 2, 5), 
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)


#BY ROW
tribble(
  ~x, ~y, ~z, ~`Date of Birth`,
  1, "h", 0.08, as.Date("2024-08-01"),
  2, "m", 0.83, as.Date("2023-08-01"),
  5, "g", 0.60, as.Date("2022-08-01")
)














