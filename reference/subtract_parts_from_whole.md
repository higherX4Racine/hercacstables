# Computes a remainder values from measures of some subgroups and one all-group

Computes a remainder values from measures of some subgroups and one
all-group

## Usage

``` r
subtract_parts_from_whole(
  .data_frame,
  grouping_column,
  value_column,
  whole_name,
  part_names,
  remainder_name
)
```

## Arguments

- .data_frame:

  \<dataframe\> the input data

- grouping_column:

  \<chr\> the name of the column that defines the grouping

- value_column:

  \<chr\> the name of the column that holds the values

- whole_name:

  \<chr\> the level of the grouping that signifies the total

- part_names:

  \<chr\[\]\> the other levels of the grouping

- remainder_name:

  \<chr\> the new name for the difference between whole and parts

## Value

a new data frame with the same number of columns but extra rows and a
new group level
