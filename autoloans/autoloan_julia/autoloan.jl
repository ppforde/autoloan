using Printf
using Dates
 
interest_rate = 4.7
current_date = Dates.format(now(), "Y-mm-dd HH:MM:SS")
 
countall = Int64[]
sumall = Float64[]
 
io = open("../loans.csv", "w")
 
write(io, "LOAN,TERM,INTEREST,MONTHLY,STATUS,DATE\n")
 
for present_value = 25000:1000:29000, number_periods = 24:12:72
 
    irr = interest_rate / 100 / 12
 
    monthly_payment = round((irr * present_value) / (1 - (1 + irr)^ -number_periods) *100 ) / 100
 
    if monthly_payment < 500
        payment_status = "low"
    elseif monthly_payment > 600
        payment_status = "high"
    else
        payment_status = "ok"
    end
 
    @printf("%d, %d, %.1f, %.2f, %s, %s\n", present_value, number_periods, interest_rate, monthly_payment, payment_status, current_date)
 
    write(io, "$present_value,$number_periods,$interest_rate,$monthly_payment,$payment_status,$current_date\n" )  
 
    push!(countall, 1)
    push!(sumall, monthly_payment)
 
end
 
close(io)
 
@printf("\nTotal records: %d & total payments: %.2f\n", sum(countall), sum(sumall))
