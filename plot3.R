##1. Read power consumption data

#First, read header and first row to get column names and start date and time
power_cons_data_row1 <- read.table("household_power_consumption.txt",
                                   header = TRUE,
                                   sep = ";",
                                   nrows = 1)

#Calculate number of rows to skip to get to Feb 1, 2007 from start date and time
skipped_rows = difftime(as.POSIXct("2007-2-1 00:01:00"),
                        as.POSIXct(paste(power_cons_data_row1[1,1], power_cons_data_row1[1,2]), tz = "", "%d/%m/%Y %H:%M:%S"),
                        units="mins")

#Calculate number of row to read to get data from start of Feb 1, 2007 to end of Feb 2, 2007
read_rows = difftime(as.POSIXct("2007-2-3 00:00:00"),
                     as.POSIXct("2007-2-1 00:00:00"),
                     units="mins")

#Read data from desired rows 
power_cons_data <- read.table("household_power_consumption.txt",
                              header = FALSE,
                              sep = ";",
                              col.names = names(power_cons_data_row1),
                              na.strings = "?",
                              skip = skipped_rows,
                              nrows = read_rows)

#Combine date and time columns into a single datetime column
power_cons_data$datetime <- paste(power_cons_data$Date, power_cons_data$Time)

#Format datetime column as POSIXlt
power_cons_data$datetime <- strptime(power_cons_data$datetime, "%d/%m/%Y %H:%M:%S")

##2. Generate Plot 3

png(file = "plot3.png")

plot(power_cons_data$datetime,
     power_cons_data$Sub_metering_1,
     xlab = "",
     ylab = "Energy sub metering",
     type = "n")

lines(power_cons_data$datetime, power_cons_data$Sub_metering_1, col = "black")
lines(power_cons_data$datetime, power_cons_data$Sub_metering_2, col = "red")
lines(power_cons_data$datetime, power_cons_data$Sub_metering_3, col = "blue")

legend("topright",
       lty = 1,
       col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()