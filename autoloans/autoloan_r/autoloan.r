autoloan.func <- function(present.value, number.periods, interest.rate) {
  interest.rate = interest.rate / 100 / 12
  round(interest.rate * present.value / (1-(1 + interest.rate) **-number.periods),2)
}
 
 
#### Using Vector ####
present.value = 25000
term.vector = seq(from = 24, to = 72, by = 12)
interest.rate = 4.7
 
df <-data.frame()
 
df
 
while (present.value < 30000) {
 
  for (number.periods in term.vector) {
 
    xf <- data.frame(
      loan=present.value,
      term=number.periods,
      interest=interest.rate
      )
 
    df <- rbind(xf, df)
  }
 
  present.value = present.value + 1000
}
 
df
 
df$monthly <- with(df, mapply(autoloan.func, loan, term, interest))
 
df$status <- with(df, ifelse(monthly < 500, "low", ifelse(monthly> 600, "high","ok")))
 
df$date <- Sys.time()
 
df
 
hist(df$monthly, col="lightblue", border="navy", main="Auto Loans")
 
colnames(df) <- toupper(colnames(df))
 
write.csv(df, file = "/home/gda/Developers/R/loans.csv", row.names = F)
 
# Clear Environment (Data, Values, Functions)
rm(list = ls())
 
#### Using Matrix ####
 
irate <- matrix(4.7, nrow = 5, ncol = 5)
 
nper <- seq(from = 24, to = 72, by = 12)
nper <- matrix(nper, nrow = 5, ncol = 5)
nper
 
pval <- seq(from = 25000, to = 29000, by = 1000)
pval <- matrix(pval, nrow = 5, ncol = 5)
pval <- t(pval)
pval
 
autoloan.func <- function(pval, nper, irate) {
  irate = irate / 100 / 12
  round(irate * pval / (1-(1 + irate) **-nper),2)
}
 
pmt <- autoloan.func(pval, nper, irate)
pmt
 
row.names(pmt) <- nper[,1]
colnames(pmt) <- pval[1,]
pmt
 
heatmap(pmt)
 
boxplot(pmt, col='darkblue', border='grey', main="Auto Loan Payments")
 
hist(pmt, col='darkblue', border='grey', main="Auto Loan Payments")
