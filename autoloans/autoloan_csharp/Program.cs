using System;
using System.IO;

/*
How to create a C# program
dotnet new consol -o myApp
cd myApp
*/

namespace autoLoan
{
    class Program
    {
        static void Main(string[] args)
        {
            DateTime currentDate = DateTime.Now;

            double interestRate = 4.7;

            int[] numberOfPeriodsArray = { 24, 36, 48, 60, 72 };

            // WRITE a file with STREAMWRITER
            //string textFilePath = @"C:\Users\gathe\Developers\CS\loans.csv";
            //string textFilePath = @"..\loans.csv";
            string textFilePath = @"loans.csv";

            StreamWriter sw = File.CreateText(textFilePath);

            sw.WriteLine("LOAN,INTEREST,TERM,MONTHLY,DATE");

            int presentValue = 25000;

            while (presentValue < 30000)
            {

                for (int i = 0; i < numberOfPeriodsArray.Length; i++)
                {
                    int numberOfPeriods = numberOfPeriodsArray[i];
                    double monthlyPayment = Math.Round(AutoLoan(presentValue, interestRate, numberOfPeriods), 2);

                    sw.Write(presentValue);
                    sw.Write(",");
                    sw.Write(interestRate);
                    sw.Write(",");
                    sw.Write(numberOfPeriods);
                    sw.Write(",");
                    sw.Write(monthlyPayment);
                    sw.Write(",");
                    sw.Write(currentDate);
                    sw.WriteLine();
                }
                presentValue += 1000;
            }
            sw.Close();
        }
        static double AutoLoan(int presentValue, double interestRate, int numberOfPeriods)
        {
            interestRate = interestRate / 100 / 12;
            return interestRate * presentValue / (1 - Math.Pow(1 + interestRate, -numberOfPeriods));
        }
    }
}

/*
How to run a C# program
dotnet new console -o autoloan_cs
cd autoloan_cs
dotnet run
*/