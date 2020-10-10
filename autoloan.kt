import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.io.File
 
fun main(args: Array<String>) {
 
    val numberPeriodsList = listOf(24, 36, 48, 60, 72)
 
    val interestRate:Double = 4.7
 
    val dt = LocalDateTime.now()
    val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
    val currentDate = dt.format(formatter)
 
    var presentValue:Int = 25000
 
    var countall:Int = 0
 
    var sumall:Double = 0.0
 
    var rows:String = "LOAN,TERM,INTEREST,MONTHLY,STATUS,DATE\n"
 
    while(presentValue < 30000) {
 
        for (numberPeriods in numberPeriodsList) {
 
            val monthlyPayment = AutoLoan(presentValue, numberPeriods, interestRate)
 
            val paymentStatus = StatusUpdate(monthlyPayment)
 
            val row = String.format("%d,%d,%.1f,%.2f,%s,%s\n",
             presentValue,
             numberPeriods,
             interestRate,
             monthlyPayment,
             paymentStatus,
             currentDate)
 
            print(row)
 
            rows = rows + row
 
            countall++
 
            sumall = sumall + monthlyPayment           
 
        }
 
        presentValue += 1000
    } 
    println("Total records: $countall and total payments: ${Math.round(sumall*100.0)/100.0}")
    println()
 
    File("../loans.csv").writeText(rows)
}
 
fun AutoLoan(presentValue:Int, numberPeriods:Int, interestRate:Double): Double {
    val rate = (interestRate / 100 / 12)    
    return (rate * presentValue / (1 - Math.pow(1 + rate, -numberPeriods.toDouble())))
}
 
fun StatusUpdate(monthlyPayment:Double): String {
    if (monthlyPayment < 500.0) {
       return "low"
    } else if (monthlyPayment > 600.0) {
        return "high"
    } else {
        return "ok"
    }    
}
 
