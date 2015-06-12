# Opening a file

earnings_function <- function(x) {
  
  earnings <- read.csv(x, stringsAsFactors=FALSE)
  
  # How many rows? 
  
  nrow(earnings)
  
  # Look at the first five rows in the Console
  head(earnings)
  
  # Investigate the structure of the dataframe
  str(earnings)
  
  #Change column to number format (first you have to strip out the $)
  #The $ is a special character
  
  earnings$TOTAL.EARNINGS <- gsub("\\$", "", earnings$TOTAL.EARNINGS)
  earnings$TOTAL.EARNINGS <- gsub("\\,", "", earnings$TOTAL.EARNINGS)
  earnings$TOTAL.EARNINGS <- as.numeric(earnings$TOTAL.EARNINGS)
  
  #Sort by column TOTAL.EARNINGS
  
  earnings <- earnings[order(-earnings$TOTAL.EARNINGS),]
  earnings <- earnings[order(earnings$TOTAL.EARNINGS),]
  
  #Create new column with a formula (Convert OT column into numeric first)
  earnings$OVERTIME <- gsub("\\$", "", earnings$OVERTIME)
  earnings$OVERTIME <- gsub("\\,", "", earnings$OVERTIME)
  earnings$OVERTIME <- as.numeric(earnings$OVERTIME)
  
  #FORMULA TIME
  earnings$Total.minus.OT <- earnings$TOTAL.EARNINGS - earnings$OVERTIME
  
  #Filter out a column (in R, it's called "subset")
  fire_dept <- subset(earnings, DEPARTMENT=="Boston Fire Department")
  
  #Calculations on columns
  earnings_total <- sum(earnings$TOTAL.EARNINGS)
  earnings_avg <- mean(earnings$TOTAL.EARNINGS)
  earnings_median <- median(earnings$TOTAL.EARNINGS)
  
  ##DATA TO COLUMNS IN R
  #Create new column based on NAME column by deleting after comma
  earnings$Last.Name <- sub(",.*","",earnings$NAME)
  earnings$First.Name <- sub(".*,","",earnings$NAME)
  
  #Create column based on First.Name column by deleting before space
  earnings$Middle <- sub(".* ","", earnings$First.Name)
  
  #Modify First.Name column by deleting after space
  earnings$First.Name <- sub(" .*","",earnings$First.Name)
  
  #Simple Pivot table to count number of employees per Department
  Department_Workers <- data.frame(table(earnings$DEPARTMENT))
  
  #Sort it
  Department_Workers <- Department_Workers[order(-Department_Workers$Freq),]
  
  #Rename Columns
  colnames(Department_Workers) <- c("Department", "Employees")
  
  #Advanced calculations
  income <- tapply(earnings$TOTAL.EARNINGS, earnings$DEPARTMENT, sum)
  
  #Convert the table into a dataframe
  income <- data.frame(income)
  
  #Create a column based on row names
  income$Department <- rownames(income)
  
  #Need the column of rown ames to merge it with the department workers count
  merged <- merge(Department_Workers, income, by="Department")
  
  #Sort it one more time by income
  merged <- merged[order(-merged$income),]
  
  #Save it as a csv
  
  filename <- paste(x, "_analyzed.csv", sep="")
  
  write.csv(merged, filename)
  
}