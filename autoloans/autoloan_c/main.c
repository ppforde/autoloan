# include <stdio.h>  // input/output
# include <math.h>   // math
# include <ctype.h>  // character manipulation
# include <string.h> // string manipulation
# include <stdlib.h> // used for malloc() function
# include <time.h>   // datetime operations
 
double autoLoan(int presentValue, double interestRate, int numberPeriods);
 
const char* statusUpdate(double monthlyPayment);
 
int main()
{
 
    FILE *fh;
    int numberPeriods[5] = {24, 36, 48, 60, 72};
    float interestRate = 4.7;
    int countall = 0;
    float sumall = 0.0;
 
    time_t t = time(NULL);
    struct tm *tm = localtime(&t);
 
    fh = fopen("../loans.csv", "w");
    if (fh == NULL)
    {
        puts("Failed to create file");
        return (1);
    }
    else
    {
        char header[] = "LOAN,INTEREST,TERM,MONTHLY,STATUS,DATE\n";
        fputs(header, fh);
    }
 
    int presentValue = 25000;
    int i;
 
    while (presentValue < 30000)
    {
        for (i = 0; i < 5; i++)
        {
            double monthlyPayment = autoLoan(presentValue, interestRate, numberPeriods[i]);
 
            const char* paymentStatus = statusUpdate(monthlyPayment);
 
            printf("%d, %.1f, %d, %.2f, %s, %s", presentValue, interestRate, numberPeriods[i], monthlyPayment, paymentStatus, asctime(tm));
 
            fprintf(fh, "%d,%.1f,%d,%.2f,%s,%s", presentValue, interestRate, numberPeriods[i], monthlyPayment, paymentStatus, asctime(tm));
 
            countall ++;
            sumall = sumall + monthlyPayment;
        }
        presentValue += 1000;
    }
    fclose(fh);
    printf("\nTotal records: %d & total payments: %.2f\n", countall, sumall);
 
    return (0);
}
 
double autoLoan(int presentValue, double interestRate, int numberPeriods)
{
    interestRate = interestRate / 100 / 12;
    return (interestRate * presentValue / (1 - pow(1 + interestRate, -numberPeriods)));
}
 
const char* statusUpdate(double monthlyPayment)
{
    if (monthlyPayment < 500.0) {
       return "low";
    } else if (monthlyPayment > 600.0) {
        return "high";
    } else {
        return "ok";
    }  
}
 
// sudo apt install gcc
// gcc  main.c -o main -lm
// ./main
