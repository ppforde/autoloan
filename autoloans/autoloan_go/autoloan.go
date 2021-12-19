package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"time"
)

/* Functions */

// autoLoan calculates a monthly loan payment
func autoLoan(loanAmount float64, termLength float64, interestRate float64) float64 {
	interestRate = interestRate / 100 / 12
	return (interestRate * loanAmount / (1 - math.Pow(1+interestRate, -termLength)))
}

// statusUpdate groups the payment streams
func statusUpdate(monthlyPayment float64) string {

	if monthlyPayment < 500.0 {
		return "low"
	} else if monthlyPayment > 600.0 {
		return "high"
	} else {
		return "ok"
	}
}

func main() {

	termList := []float64{24.0, 36.0, 48.0, 60.0, 72.0}

	loanAmount := 25000.0

	// Mon Jan 2 15:04:05 MST 2006
	dt := time.Now()
	currentDate := dt.Format("2006-01-02 15:04:05")

	const interestRate float64 = 4.7

	countall := 0

	sumall := 0.0

	// Create a file
	file, err := os.Create("../loans.csv")

	// Output any errors
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	file.WriteString("LOAN,TERM,INTEREST,MONTHLY,STATUS,DATE\n")

	for loanAmount < 30000 {

		for _, term := range termList {

			monthlyPayment := autoLoan(loanAmount, term, interestRate)

			paymentStatus := statusUpdate(monthlyPayment)

			/*
			   loanStr := strconv.FormatFloat(loanAmount, 'f', 0, 64)
			   termStr := strconv.FormatFloat(term, 'f', 0, 64)
			   intStr := strconv.FormatFloat(interestRate, 'f', 1, 64)
			   payStr := strconv.FormatFloat(payment, 'f', 2, 64)

			   // Create a joined string
			   s := []string{loanStr, termStr, intStr, payStr, currentDate}

			   // Print a the joined string
			   fmt.Printf(strings.Join(s, ",") + "\n")

			   // Write a string to the file
			   //file.WriteString(strings.Join(s, ",") + "\n")
			*/

			s := fmt.Sprintf("%.0f,%.0f,%.1f,%.2f,%s,%s\n", loanAmount, term, interestRate, monthlyPayment, paymentStatus, currentDate)

			fmt.Printf(s)

			file.WriteString(s)

			countall++

			sumall = sumall + monthlyPayment
		}
		loanAmount += 1000
	}
	fmt.Printf("\nTotal records: %d & total payments: %.2f\n", countall, sumall)
}

// mkdir autoloan_go
// cd autoloan_go
// go mod init autoloan
// go run .
