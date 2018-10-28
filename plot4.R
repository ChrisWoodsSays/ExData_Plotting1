# File
#   plot4.R
#
# Overview
#   
#   Plots 4 charts in a single collection
#   for 2 days at the beginning of February 2007
#   from Electric Power Consumption Dataset https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
#   at the UCI web site https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption

library(readr)
library(dplyr)
install.packages("sqldf")
library(sqldf)

#######################
# 1. Download Zip Files
#######################

# download zip file containing data if it hasn't already been downloaded
zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "ElectricPowerConsumption.zip"
# zipFile will be unzipped to folder of same name less the .zip extension
dataDest <- gsub(".zip$", "", zipFile)

if (!file.exists(zipFile)) {
    download.file(zipUrl, zipFile, mode = "wb")
}

# unzip zip file containing data if data directory doesn't already exist
if (!file.exists(dataDest)) {
    unzip(zipFile)
}

#######################################################
# 2. Load subset of data so we have just two day period
#    2007-02-01 and 2007-02-02
#######################################################

consumptionDF <- read.csv.sql("household_power_consumption.txt", 
                                         "select *
                                         from file where Date = '1/2/2007' or Date = '2/2/2007'", sep=";")


###############
# 3. Clean Data
################

# Format Date/ Time
consumptionDF = mutate(consumptionDF, DateTimeFormatted = as.POSIXct(paste(Date,Time),format="%d/%m/%Y %H:%M:%S"))

########################
# 4. Charts Side by Side
########################

# Setup grid with 2 rows of 2 columns and
# margins (bottom, left, top, right)
par(mfrow = c(2,2), mar = c(4,5,2,2))

# Active Power Over Time Line Chart (plot 2)
plot(consumptionDF$DateTimeFormatted, consumptionDF$Global_active_power, 
     type = "l",
     ylab="Global Active Power", 
     xlab="")

# Voltage Over Time Line Chart
    plot(consumptionDF$DateTimeFormatted, consumptionDF$Voltage, 
         type = "l",
         xlab="datetime", 
         ylab="Voltage")

# Submetering Over Time Multi Line Chart (plot 3)
    plot(consumptionDF$DateTimeFormatted, consumptionDF$Sub_metering_1,
         ylab = "Energy Sub Metering",
         xlab="",
         type = "n")
    points(consumptionDF$DateTimeFormatted, consumptionDF$Sub_metering_1,
           type = "l")
    points(consumptionDF$DateTimeFormatted, consumptionDF$Sub_metering_2,
           type = "l",
           col = "red")
    points(consumptionDF$DateTimeFormatted, consumptionDF$Sub_metering_3,
           type = "l",
           col = "blue")
    legend("topright", lty = 1, col = c("black", "red", "blue"),
           legend=c("Sub Metering 1", "Sub Metering 2", "Sub Metering 3"))

# Re-active Power Line Chart
with(consumptionDF,
     plot(DateTimeFormatted, Global_reactive_power, 
          type = "l",
          xlab="datetime"))

# Copy plot to png file
dev.copy(png,'plot4.png', width = 480, height = 480)
dev.off()