def auto_loan_func(present_value, number_periods, interest_rate):
	interest_rate = interest_rate/100/12
	return interest_rate * present_value / (1 - (1 + interest_rate)** -number_periods)

q = autoloan_func(25515, 72, 3.19)

print(f"{q:,.2f}")
