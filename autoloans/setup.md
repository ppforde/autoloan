
## Setup

```bash
timedatectl set-local-rtc 1 --adjust-system-clock

sudo lshw

sudo apt update

sudo apt upgrade

sudo apt install curl

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo apt install ./google-chrome-stable_current_amd64.deb

```

## Anaconda

```bash

gtv=2023.03-1

echo #gtv

wget https://repo.anaconda.com/archive/Anaconda3-$gtv-Linux-x86_64.sh

bash ~/Anaconda3-$gtv-Linux-x86_64.sh

exit

anaconda-navigator

pip install --upgrade jupyterlab

pip install polars

pip install duckdb

pip install pynongo

pip install psycopg

pip install folium

pip install geopy

pip install streamlit

# for additional environment

conda create -n py39 python=3.9 anaconda

conda env list

conda activate py39
```

## Javascript

```bash
sudo apt install nodejs

sudo apt install npm

```

## Java

```bash
sudo apt install default-jdk

which java

java --version

pip install pyspark
```

## Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# To configure your current shell, run:

source $HOME/.cargo/env
```

## Julia

### Julia Installation

```bash

gtc=1.9
gtv=1.9.3

echo $gtv

wget https://julialang-s3.julialang.org/bin/linux/x64/$gtc/julia-$gtv-linux-x86_64.tar.gz

tar -xvf julia-$gtv-linux-x86_64.tar.gz

sudo mv julia-$gtv/ /usr/lib/

sudo ln -s /usr/lib/julia-$gtv/bin/julia /usr/bin/julia

julia -version

julia

```

### Julia Packages
```julia

using Pkg

Pkg.add("IJulia")

packages = ["Plots", "CSV", "SQLite", "Glob", "HTTP", "GZip", "ZipFile", "VegaLite", "VegaDatasets", "DataFrames", "DataFramesMeta", "IndexedTables", "Lathe", "StatsPlots", "XLSX", "Gadfly", "RDatasets", "Compose", "Colors", "ColorSchemes", "Distributions", "Query", "PyCall", "Conda"]

for p in packages Pkg.add(p) end

using IJulia; notebook()
```

## Postgres

### Postgres Installation

```bash
sudo apt-get -y install postgresql-14 postgresql-plpython3-14

pip install psycopg2

sudo su postgres

psql

```

### Postgres Databases

```sql
\du

ALTER USER postgres WITH PASSWORD '<password>';

CREATE USER <username> WITH PASSWORD '<password>';

ALTER USER <username> WITH SUPERUSER;

\du

\l

CREATE DATABASE auto_loans;

CREATE DATABASE baby_names;

CREATE DATABASE crappy_gifts;

CREATE DATABASE imdb_data;

CREATE DATABASE solar_power;

CREATE DATABASE census_usa;

CREATE DATABASE fdic_data;

CREATE EXTENSION plpython3u;

\l

# select database
\c auto_loans

# list tables
\dt

# describe table
\d terms

# load and execute a script
\i path_to_sql_file

\q

exit
```


## VS Code

```bash
sudo snap install --classic code

# Code Runner
# Rainglow
# Rainbow CSV
# Live Server
# Markdown All in One
# HTML Boilerplate
```


## Python 

### Python Test Script
```python
import argparse
from datetime import datetime, timedelta
from urllib import request
from tabulate import tabulate

parser = argparse.ArgumentParser()
parser.add_argument('symbol', type=str, help="Enter SYMBOL for the stock (i.e. F)")
parser.add_argument('price', type=int, help="Enter closing PRICE (i.e. 20)")
parser.add_argument('days', type=int, help="Enter delta range in DAYS (i.e. 90)")

args = parser.parse_args()

def yahoo_stock():

    symbol = args.symbol
    days = args.days
    price = args.price

    file = f"{args.symbol}.csv"
    startdate = int((datetime.now() - timedelta(days)-datetime(1970,1,1)).total_seconds())
    enddate = int((datetime.now() - datetime(1970,1,1)).total_seconds())
    url = f"https://query1.finance.yahoo.com/v7/finance/download/{symbol}?period1={startdate}&period2={enddate}&interval=1d&events=history&includeAdjustedClose=true"
    request.urlretrieve(url, file)

    with open(file, mode="r") as f:
        header = f.readline().strip().split(",")
        rows = [line.strip().split(",") for line in f.readlines()]

        data = [dict(zip(header, row)) for row in rows]
        q = [d for d in data if eval(d['Close']) > price]
        print(f"Yahoo Finance stock results for: {symbol}\n")

        # Tabulate is a seperate package outside of the Python standard libary
        # However it is included in many Jupyter Notebook environments (such as Google Colab)
        print(tabulate(q, headers="keys", tablefmt="psql", floatfmt=".2f"))

if __name__ == "__main__":
    yahoo_stock()
```

### Python CLI

```bash
python yahoo_stock.py -h

python yahoo_stock.py AMD 90 45
```

### Python Notebooks

#### Pandas

```python 
from datetime import datetime, timedelta
import pandas as pd

pd.options.display.float_format = "{:,.2f}".format
pd.options.display.max_columns = 100
pd.options.display.max_rows = 100
pd.options.display.precision = 2
pd.options.display.max_colwidth = 80

from bokeh.plotting import figure, show, output_notebook
from bokeh.models import (HoverTool, ColumnarDataSource, ColumnDataSource, NumeralTickFormatter, DatetimeTickFormatter, BoxAnnotation)
from bokeh.layouts import gridplot, row, column

def yahoo_stock(symbol:str, days:int):

    startdate = int((datetime.now() - timedelta(days)-datetime(1970,1,1)).total_seconds())
    enddate = int((datetime.now() - datetime(1970,1,1)).total_seconds())
    url = f"https://query1.finance.yahoo.com/v7/finance/download/{symbol}?period1={startdate}&period2={enddate}&interval=1d&events=history&includeAdjustedClose=true"

    df = pd.read_csv(url, parse_dates=['Date'])

    df['Dates'] = df['Date'].astype(str)
    df['Volume'] = df['Volume'] / 1e6
    df['Avg'] = df['Close'].mean()
    df['Rolling'] = df.Close.rolling(days//2).mean()

    source = ColumnDataSource(df)

    p1 = figure(title=f"Close ($) for {symbol}", x_axis_type="datetime", plot_width=450, plot_height=300)

    p1.line(x="Date", y="Close", source=source, line_width=1, color="green")
    p1.line(x="Date", y="Avg", source=source, line_width=2, color="gray", line_dash="dashed")
    p1.line(x="Date", y="Rolling", source=source, line_width=2, color="red", line_dash="dotdash") #solid, dashed, dotted, dotdash, dashdot

    p1.yaxis[0].formatter = NumeralTickFormatter(format="$,0")
    p1.add_tools(HoverTool(tooltips=[("Date", "@Dates"), ("Close", "$@Close{,.2f}"), ("Volume", "@Volume{,}M")]))

    p2 = figure(title=f"Volume (M) for {symbol}", x_axis_type="linear", plot_width=450, plot_height=300)
    p2.circle(x="Volume", y="Close", source=source, alpha=.4, color="purple")
    p2.xaxis[0].formatter = NumeralTickFormatter(format=",")
    p2.yaxis[0].formatter = NumeralTickFormatter(format="$,0")

    gp = gridplot([[p1, p2]])

    output_notebook()

    show(gp)	

yahoo_stock("AMD", 150)
```

#### Pyspark

```python

import urllib.request
import re

URL = 'https://datasets.imdbws.com/'

with urllib.request.urlopen(URL) as f:
    web_data = f.read().decode('utf-8')

for d in re.findall(pattern="(https.*\.gz)>", string=web_data):
    print(d)

from pyspark.sql import SparkSession, Row
from pyspark.context import SparkContext
from pyspark.sql.functions import *
from pyspark.sql.types import *

spark = SparkSession.builder.appName("IMDB").getOrCreate()
print(spark)

sc = spark.sparkContext

!wget https://datasets.imdbws.com/title.basics.tsv.gz

!gzip -df title.basics.tsv.gz

!ls -la *.tsv

!head title.basics.tsv

!wc -l title.basics.tsv

def imdb_spark(fp):
    df = spark.read.format("csv")\
    .option("header","true")\
    .option("sep","\t")\
    .option("encoding","utf-8")\
    .option("quote", "")\
    .option("nullValue","\\N")\
    .option("inferSchema","true")\
    .load(fp)

    return df
	
fp = 'title.basics.tsv'

df = imdb_spark(fp)

df.count()

df.printSchema()


```