import csv
import json
import datetime
from pprint import pprint

def autoloan(present_value, number_periods, interest_rate):
    interest_rate = interest_rate / 100 / 12
    return interest_rate * present_value / (1 - (1 + interest_rate) ** -number_periods)

def status_update(monthly_payment):
    if monthly_payment < 500:
        return "low"
    elif monthly_payment > 600:
        return "high"
    return "ok"


data = []

number_periods_list = [t for t in range(24, 84, 12)]

present_value = 25000

interest_rate = 4.7

countall = 0

sumall = 0

current_date = datetime.datetime.now().strftime(format="%Y-%m-%d %H:%M:%S")

while (present_value < 30000):

    for number_periods in number_periods_list:

        monthly_payment = autoloan(present_value, number_periods, interest_rate)

        payment_status = status_update(monthly_payment)

        payment_dict = {
            'LOAN': present_value,
            'INTEREST': interest_rate,
            'TERM': number_periods,
            'MONTHLY': round(monthly_payment,2),
            'STATUS': payment_status,
            'DATE': current_date,
        }

        data.append(payment_dict)

        pprint(payment_dict, indent=2, width=40)
        print()

        countall += 1
        sumall = sumall + payment_dict['MONTHLY']

    present_value += 1000


# with CSV
with open('loans.csv', mode='w', newline='') as csvfile:
    fieldnames = data[0].keys()
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(data)

# with JSON
with open('loans.json', 'w') as fp:
    json.dump(fp=fp, obj=data, indent=2)

print("\nTotal records: {} & total payments: {:,.2f}".format(countall, sumall))
