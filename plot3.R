library(dplyr)

temppc <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temppc, mode="wb")
unzip(temppc, "household_power_consumption.txt")
unlink(temppc)
hhpowerconsumption.df <- read.table("household_power_consumption.txt", sep=";", header=TRUE)
str(hhpowerconsumption.df)
# 'data.frame':	2075259 obs. of  9 variables:

#You may find it useful to convert the Date and Time variables to Date/Time classes in R using the strptime() and as.Date() functions.
hhpowerconsumption.df$Time <- strptime(paste(hhpowerconsumption.df$Date, hhpowerconsumption.df$Time), "%d/%m/%Y %H:%M:%S")
hhpowerconsumption.df$Date <- as.Date(hhpowerconsumption.df$Date,  format = "%d/%m/%Y")

#We will only be using data from the dates 2007-02-01 and 2007-02-02. 
#One alternative is to read the data from just those dates rather than reading in the entire dataset and subsetting to those dates.
hhpowerconsumption2Day.df <- hhpowerconsumption.df %>%
  filter(Date == as.Date('2007-02-01') | Date == as.Date('2007-02-02'))
str(hhpowerconsumption2Day.df)
# 'data.frame':	2880 obs. of  9 variables:

# change values to numeric for plotting
hhpowerconsumption2Day.df$Global_active_power <- as.numeric(hhpowerconsumption2Day.df$Global_active_power)
hhpowerconsumption2Day.df$Sub_metering_1 <-  as.numeric(hhpowerconsumption2Day.df$Sub_metering_1)
hhpowerconsumption2Day.df$Sub_metering_2 <-  as.numeric(hhpowerconsumption2Day.df$Sub_metering_2)
hhpowerconsumption2Day.df$Sub_metering_3 <-  as.numeric(hhpowerconsumption2Day.df$Sub_metering_3)

# validate that the data hasn't been blown away after changing to numeric (i.e., mean val is greater than 0, etc.)
summary(hhpowerconsumption2Day.df)

with(hhpowerconsumption2Day.df, plot(Time, Sub_metering_1, type = "l", col="black", xlab="", ylab="Energy sub metering"))
with(hhpowerconsumption2Day.df, points(Time, Sub_metering_2, type = "l", col="red"))
with(hhpowerconsumption2Day.df, points(Time, Sub_metering_3, type = "l", col="blue"))
legend("topright", lty = c(1, 1), col = c("black","blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Copy plot to a PNG file with a width of 480 pixels and a height of 480 pixels.
dev.copy(png, file = "plot3.png", width = 480, height = 480)

## Close the PNG device
dev.off()

## delete file as it totally messed up my push into master
file.remove("household_power_consumption.txt")