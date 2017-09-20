# Foodora Forecasting Teaser Task

We would like you to try to create a forecast for the number of orders in a French city. No worries, we're fully aware -- painfully aware even -- that doing this well is a multi-day if not multi-week project. What we would like to see, however, is how you work; what kind of code you write, how you explore a dataset and how you move from raw data to model to forecast.

We are particularly interested in how you deal with dirty data. As already discussed in the interview, one way in which the order numbers we provide a forecast for are dirty is they are often lower than they otherwise would be because our logistics system is at capacity and we have to stop taking orders. This shows up in our historical order data as dips or outright zero orders. Since we log when we're open for business, we know which order data is affected by these closures.

The data is contained in dataset.csv and contains the following variables:
- datetime_local: the datetime at the beginning of the half-hourly time interval over which the orders are summed
- orders: sum of the orders in the half-hourly time interval
- open: whether the time interval fell within our opening hours
- closed: FALSE if we were taking orders at the time, TRUE if the website displayed a message like "We're currently too busy, please come back another time"
- holiday_name: the name of the national holiday if the day was a national holiday, NA otherwise

The dataset contains data from 2016-02-01 till 2016-09-18.

Please send us a R script/RMarkdown document in which you:

- plot the data
- deal with times on which we were closed in whatever way you see fit
- fit a model to this data. What criterion do you think is most appropriate to evaluate this model?
- create a forecast for the entire week from 2016-09-19 till 2016-09-25