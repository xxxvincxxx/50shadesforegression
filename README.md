# Forecasting Task

* Create a forecast for the number of orders in a French city. 

* The provided orders are dirty, they are often lower than they otherwise would be because our logistics system is at capacity and we have to stop taking orders. 

* This shows up in our historical order data as dips or outright zero orders. 

* Since there is a log for when business is open, which order data is affected by these closures is known.

The data is contained in dataset.csv and contains the following variables:

- datetime_local: the datetime at the beginning of the half-hourly time interval over which the orders are summed
- orders: sum of the orders in the half-hourly time interval
- open: whether the time interval fell within our opening hours
- closed: FALSE if we were taking orders at the time, TRUE if the website displayed a message like "We're currently too busy, please come back another time"
- holiday_name: the name of the national holiday if the day was a national holiday, NA otherwise

The dataset contains data from 2016-02-01 till 2016-09-18.

## To do:

- plot the data
- deal with times on which we were closed in whatever way you see fit
    + Transformations 
    + Outlier detection
- fit a model to this data.
    + Linear Regression 
    + Time Series model forecast
    + Multiple models at once 
- Evaluate the model
- Create forecast from 2016-09-19 till 2016-09-25
