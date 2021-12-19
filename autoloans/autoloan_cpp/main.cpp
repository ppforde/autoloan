# include <iostream>
# include <ctime>
# include <cstdlib>
# include <iomanip>
# include <fstream>
# include <cmath>
 
using namespace std;
 
double autoLoan(int presentValue, int numberPeriods, double interestRate);
 
string statusUpdate(double monthlyPayment);
 
int main()
{
    int numberPeriodsList[5] = {24, 36, 48, 60, 72};
 
    // Get the length of the array
    int len = *(&numberPeriodsList + 1) - numberPeriodsList;
 
    int presentValue = 25000;
 
    double interestRate = 4.7;
 
    int countall = 0;
 
    double sumall = 0.0;
 
    time_t now = time(0);
    tm *currentDate = localtime(&now);
 
    ofstream outputFileA;
 
    // use to create or overwrite a file
    outputFileA.open("../loans.csv");
 
    cout.setf(ios::fixed);     // turn off exponential notation
    cout.setf(ios::showpoint); // use fixed decimals
 
    // Add header to the file
    outputFileA << "LOAN"
                << ","
                << "INTEREST"
                << ","
                << "TERM"
                << ","
                << "MONTHLY"
                << ","
                << "STATUS"
                << ","
                << "DATE"
                << endl;
 
    while (presentValue < 30000)
    {
        for (int i = 0; i < len; i++)
        {
            //double randNum = 4 + rand() % 100 * .01;
 
            double monthlyPayment = autoLoan(presentValue, numberPeriodsList[i], interestRate);
 
            string paymentStatus = statusUpdate(monthlyPayment);
 
            cout << presentValue << "," << interestRate << "," << numberPeriodsList[i] << "," << monthlyPayment << "," << paymentStatus << ","
                        << asctime(currentDate);
 
            outputFileA << presentValue << "," << interestRate << "," << numberPeriodsList[i] << "," << monthlyPayment << "," << paymentStatus << ","
                        << asctime(currentDate);
 
            countall ++;
            sumall = sumall + monthlyPayment;
 
        }
        presentValue += 1000;
    }
 
    outputFileA.close();
    printf("\nTotal records: %d & total payments: %.2f\n", countall, sumall);
 
    return 0;
}
 
double autoLoan(int presentValue, int numberPeriods, double interestRate)
{
    interestRate = interestRate / 100 / 12;
    return round((interestRate * presentValue / (1 - pow(1 + interestRate, -numberPeriods)))*100)/100;
}
 
string statusUpdate(double monthlyPayment)
{
    if (monthlyPayment < 500.0) {
       return "low";
    } else if (monthlyPayment > 600.0) {
        return "high";
    } else {
        return "ok";
    }   
}
 
// sudo apt  install g++
// g++ main.cpp –o main
// ./main
