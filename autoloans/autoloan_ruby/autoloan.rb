interest_rate = 4.7
 
number_periods_array = [24,36,48,60,72]
 
present_value = 25000
 
current_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
 
 
def auto_loan_func(present_value, number_periods, interest_rate)
    interest_rate = interest_rate/100/12
    return ((interest_rate * present_value) / (1-(1+interest_rate)**-number_periods)).round(2)
end
 
def payment_status(payment)
    if payment > 600
        return "high"
    elsif payment < 500
        return "low"
    else
        return "ok"
    end
end
 
file = File.new("../loans.csv", "w")
file.puts "LOAN,TERM,INTEREST,MONTHLY,STATUS,DATE\n"
 
while present_value < 30000
 
    number_periods_array.each do |number_periods|
        payment = auto_loan_func(present_value, number_periods, interest_rate)
        status = payment_status(payment)
        row = "%0.0f,%0.0f,%0.1f,%0.2f,%s,%s\n" % [present_value, number_periods, interest_rate, payment, status, current_date]
        puts row
        file.puts row
    end
    present_value += 1000
end
 
file.close

# ruby autoloan.rb