import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.io.FileWriter;
import java.io.IOException;
 
public class Main {
 
    public static void main(String[] args) {
 
        // Date Time
        LocalDateTime myDateObj = LocalDateTime.now();
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String currentDate = myDateObj.format(myFormatObj);
 
        int[] numberPeriods = { 24, 36, 48, 60, 72 };
        int presentValue = 25000;
        double interestRate = 4.7;
 
        int countall = 0;
        double sumall = 0;
 
        try {
            FileWriter myWriter = new FileWriter("../loans.csv");
 
            myWriter.write("LOAN,INTEREST,TERM,MONTHLY,STATUS,DATE\n");
 
            while (presentValue < 30000) {
 
                for (int i = 0; i < numberPeriods.length; i++) {
 
                    double monthlyPayment = AutoLoan(presentValue, numberPeriods[i], interestRate);
 
                    String paymentStatus = StatusUpdate(monthlyPayment);
 
                    System.out.printf("%d, %.1f, %d, %.2f, %s, %s\n", presentValue, interestRate, numberPeriods[i], monthlyPayment, paymentStatus, currentDate);
 
                    String s = String.format("%d,%.1f,%d,%.2f,%s,%s\n", presentValue, interestRate, numberPeriods[i], monthlyPayment, paymentStatus, currentDate);
 
                    myWriter.write(s);
 
                    countall ++;
                    sumall = sumall + monthlyPayment;
                }
                presentValue += 1000;
            }
            myWriter.close();
        } catch (IOException e) {
            System.out.println("An error occured");
            e.printStackTrace();
        }        
        System.out.printf("\nTotal records: %d & total payments: %.2f\n", countall, sumall);
    }
 
    static double AutoLoan(int presentValue, int numberPeriods, double interestRate) {
 
        interestRate = interestRate / 100 / 12;
        return interestRate * presentValue / (1 - Math.pow(1 + interestRate, -numberPeriods));
    }
 
    static String StatusUpdate(double monthlyPayment) {
 
        if (monthlyPayment < 500.0) {
            return "low";
         } else if (monthlyPayment > 600.0) {
             return "high";
         } else {
             return "ok";
         } 
    }
}
 
// javac Main.java
// java Main
