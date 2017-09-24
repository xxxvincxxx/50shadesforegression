# author: Vincenzo Grasso
# vincenzo.grass@gmail.com

# Load libraries
x<-c( 'tidyr',
     'ggplot2',
     'lubridate',
     'stringr',
     'dplyr')
try(lapply(x, require, character.only = TRUE), silent = T)

# Load dataset
df <- read.csv('/home/vincenzograsso/Desktop/forecast-task/dataset.csv')

# compute useful date measures
df %>%
    mutate(datetime_local = ymd_hms(datetime_local)) %>%
    mutate(day = floor_date(datetime_local, unit='day')) %>%
    mutate(time_bin = as.numeric(format(datetime_local, format='%H')) +
           as.numeric(format(datetime_local, format='%M'))/60) -> df

# aggregate, plot - per day
df %>%
    filter(open) %>%
    group_by(day) %>% 
    summarize(orders = sum(orders, na.rm=TRUE)) %>%
    ggplot(aes(day, orders)) + geom_line() + geom_smooth(method = "lm")


# aggregate and plot - per time_bin
df %>%
    filter(open) %>%
    group_by(time_bin) %>% 
    summarize(orders = sum(orders, na.rm=TRUE)) %>%
    ggplot(aes(time_bin, orders, group = 1)) + geom_line()

# visualize closure points
df %>%
    filter(open) %>%
    group_by(day, closed) %>% 
    summarize(orders = sum(orders, na.rm=TRUE)) %>%
    ggplot(aes(day, orders, colour=closed)) + geom_point() 

# declare the transformation function for pseudologarithm
signedlog10 = function(x) {
ifelse(abs(x) <= 1, 0, sign(x)*log10(abs(x)))
}

# aggregate, transform, plot
df %>%
    filter(open) %>%
    group_by(day, closed) %>% 
    summarize(orders = sum(signedlog10(orders), na.rm=TRUE)) %>%
    ggplot(aes(day, signedlog10(orders), colour=closed)) + geom_point() + ggtitle("Order transformed with Signed Log")

# declare arbitrary constant log transformation 
log_const = function(x, undo=FALSE){
    constant <- 0.3
    if(undo==FALSE){
    return(log(x + constant))
    } else {
    return(exp(x - constant))
}
}

# aggregate, plot
df %>%
    filter(open) %>%
    group_by(day, closed) %>% 
    summarize(orders = sum(log_const(orders), na.rm=TRUE)) %>%
    ggplot(aes(day, log_const(orders), colour=closed)) + geom_point()  + ggtitle("Order transformed with Log + arbitrary constant")


#######################################################################
# model fitting

# create a holiday dummy
df$holiday_dummies <- as.factor(ifelse(is.na(df$holiday_name),'0',df$holiday_name))
# check levels
unique(df$holiday_dummies)

# create a training dataset restricting to opening hours
df %>%
    filter(open) -> training_df

# simple linear model version I
model_1 <- lm(log_const(orders) ~ 
              day +
              time_bin +
              holiday_dummies 
            ,data=training_df, na.action = na.exclude)

summary(model_1)

# Print RMSE for model 1 
summary(model_1)$sigma

# simple linear model version II
model_2 <- lm(log_const(orders) ~ 
              day +
              time_bin +
              time_bin*day +
             holiday_dummies 
            ,data=training_df, na.action = na.exclude)

summary(model_2)

# RMSE for model 2 
summary(model_2)$sigma

# This is a dirty way to create prediction. I created a csv containing days and timebins 
# for the week to forecast and I readjusted the type of variables (dummies to factor, day to POSIXct)
# in order to use the predict() command using the model_2 object.

forecast_df <- read.csv('/home/vincenzograsso/Desktop/forecast-task/forecast_df.csv')

# readjust the types
forecast_df$holiday_dummies <- as.factor(forecast_df$holiday_dummies)
forecast_df$day <- as.POSIXct(forecast_df$day)
#str(df)

# generate predictions

forecast_df$forecast <- round(log_const(predict(model_2, newdata = forecast_df), undo=TRUE),0 )