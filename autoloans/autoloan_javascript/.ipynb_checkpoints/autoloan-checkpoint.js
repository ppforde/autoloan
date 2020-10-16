var fs = require('fs')
var http = require('http')
 
function autoLoan(presentValue, numberPeriods, interestRate) {
    var interestRate = interestRate / 100 / 12
    return interestRate * presentValue / (1 - (1 + interestRate) ** -numberPeriods)
}
 
function statusUpdate(monthlyPayment) {
    if (monthlyPayment < 500.0) {
        return "low"
     } else if (monthlyPayment > 600.0) {
         return "high"
     } else {
         return "ok"
     }
}
 
var data = []
 
var numberPeriodsArray = [24, 36, 48, 60, 72]
 
var presentValue = 25000
 
let countall = 0
 
let sumall = 0
 
const interestRate = 4.7
 
const currentDate = new Date()
 
while (presentValue < 30000) {
 
    for (numberPeriods of numberPeriodsArray) {
 
        let monthlyPayment = autoLoan(presentValue, numberPeriods, interestRate)
 
        let paymentStatus = statusUpdate(monthlyPayment)
 
        /*
 
        // Demonstrate nested JSON
                var salesperson = {
                    FNAME: "Gregg",
                    LNAME: "Atherley",
                    AGE: 49,
                    LOCATION: "New York",
                    BONUS: bonus
                }
        */
 
        // Add SALES to demonstrate nested JSON
 
        var payment = {
            LOAN: presentValue,
            INTEREST: interestRate,
            TERM: numberPeriods,
            MONTHLY: Math.round(monthlyPayment * 100) / 100,
            STATUS: paymentStatus,
            DATE: currentDate,
        }
        data.push(payment)
 
        countall++
        sumall = sumall + payment.MONTHLY
 
        console.log(payment)
        console.log()
    }
 
    presentValue += 1000
}
 
jsonData = JSON.stringify(data)
 
console.log("\nTotal records: %d and total payments: %f", countall, sumall)
 
// send JSON to file
fs.writeFile('../loans.json', jsonData, err => {
    if (err) {
        console.log('Error writing file', err)
    } else {
        console.log('Success writing file')
    }
})
fs.close
 
// send JSON to server
http.createServer(function (req, res) {
    res.writeHead(200, { 'Content-Type': 'json' })
    res.write(jsonData)
    res.end()
}).listen(3000)
 
 
 
//node autoloan
