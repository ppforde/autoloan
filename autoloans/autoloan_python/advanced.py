import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

rate = 4.7

term_list = np.linspace(start=24, stop=72, num=5, dtype='int8').reshape(5, 1)

loan_amount = np.arange(25000, 30000, 1000)

monthly_payment = np.pmt(rate=rate/100/12, nper=term_list, pv=-loan_amount).round(2)

df = pd.DataFrame(monthly_payment)

df.index = term_list.ravel()

df.columns = loan_amount

xf = df.reset_index()\
    .melt(id_vars='index', value_name='MONTHLY', var_name='TERM')\
    .assign(INTEREST=rate, DATE=pd.datetime.now())\
    .rename(columns={"index": "LOAN"})

print(xf)

plt.hist(xf.MONTHLY, color='purple', alpha=.7)
plt.title("Monthly Payments")
plt.show();

xf.to_excel('loans.xlsx', sheet_name='autoloans', index=None)

print("\nTotal records: {} & total payments: {:,.2f}".format(len(xf), xf.MONTHLY.sum()))
