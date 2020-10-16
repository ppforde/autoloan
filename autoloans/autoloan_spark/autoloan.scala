import Array._
import Math._
import java.util.Calendar
import java.text.SimpleDateFormat
import java.io._

object Main {
   def main(args: Array[String]) {
        var numberPeriods = Array(24, 36, 48, 60, 72)
        var form = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        var c = Calendar.getInstance()      
        var dateTime = form.format(c.getTime())
        
        var presentValue = 25000
        var interestRate = 4.7

        var countall = 0
        var sumall = 0.0

        var writer = new PrintWriter(new File("../loans.csv"))

        writer.write("LOAN,INTEREST,TERM,MONTHLY,STATUS,DATE\n")

        while (presentValue < 30000) {

            for ( period <- numberPeriods ) {

                var monthlyPayment = autoloan(presentValue, period, interestRate)

                var paymentStatus = statusUpdate(monthlyPayment)

                println(s"$presentValue, $interestRate, $period, $monthlyPayment, $paymentStatus, $dateTime")

                writer.write(s"$presentValue,$interestRate,$period,$monthlyPayment,$paymentStatus,$dateTime\n")

                countall += 1

                sumall = sumall + monthlyPayment 
            }
            presentValue += 1000
        }
        writer.close()

        println(s"\nTotal records:$countall & total payments:$sumall")
    }

    def autoloan( presentValue:Int, numberPeriods:Int, interestRate:Double) : Double = {
        var rate:Double = interestRate/100/12
        var payment:Double = (rate * presentValue / (1 - Math.pow(1 + rate, -numberPeriods)))
        return (Math.round(payment * 100.0) / 100.0)
    }

    def statusUpdate( monthlyPayment:Double) : String = {

        if (monthlyPayment < 500.0) {
            return "low"
        } else if (monthlyPayment > 600.0) {
            return "high"
        } else {
            return "ok"
        }
    }
}


/*

//cmd
scalac Main.scala
scala Main/

//spark
:load /home/gda/Documents/GIT/autoloans/autoloan_spark/autoloan.scala

*/
