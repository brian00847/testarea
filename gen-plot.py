#!/usr/bin/python3

import datetime
from matplotlib.dates import DayLocator, HourLocator, DateFormatter, drange
import matplotlib.pyplot as plt
from numpy import arange

import csv, datetime

INDEX_DATE = 0
INDEX_WEIGHT = 11

KG_TO_LB = 2.2

def read_csv(csvfile):
    mydata = []
    with open(csvfile, newline='') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
        irow = 0
        for row in spamreader:
            #print(', '.join(row))
            #print('irow {}'.format(irow))
            if irow > 0:
                csv_date = row[INDEX_DATE]
                weight_kg = row[INDEX_WEIGHT]
                #print('[{}]'.format(weight_kg))
                
                weight_lb = 0.0
                if weight_kg:
                    weight_lb = float(weight_kg) * KG_TO_LB
                elif mydata: 
                    weight_lb = mydata[-1][1]
                else:
                    weight_lb = 220.0

#make date
                y, m, d = [ int(x) for x in csv_date.split('-') ]
                dt = datetime.date(y, m, d)

                mydata.append((dt, weight_lb))

            irow += 1
    return mydata


#https://matplotlib.org/examples/pylab_examples/date_demo_convert.html
def create_plot(csvdata):
    fig, ax = plt.subplots()
    #ax.plot_date(dates, y*y)
    #return None

# this is superfluous, since the autoscaler should get it right, but
# use date2num and num2date to convert between dates and floats if
# you want; both date2num and num2date convert an instance or sequence
    date0 = csvdata[0][0]
    date1 = csvdata[-1][0]
    ax.set_xlim(date0, date1)

    weights = [ w[0] for w in csvdata ]
    dates = [ w[1] for w in csvdata ]
    #ax.set_xlim(dates[0], dates[-1])
    ax.plot_date(weights, dates)

# The hour locator takes the hour or sequence of hours you want to
# tick, not the base multiple

    #ax.xaxis.set_major_locator(DayLocator())
    #ax.xaxis.set_minor_locator(HourLocator(arange(0, 25, 6)))
    ax.xaxis.set_major_formatter(DateFormatter('%Y-%m-%d'))

    ax.fmt_xdata = DateFormatter('%Y-%m-%d %H:%M:%S')
    fig.autofmt_xdate()

    plt.show()

if __name__ == '__main__':
    csvfile = 'daily_summaries.csv'
    weights = read_csv(csvfile)

    #truncate to 2018
    truncated_weights = [ w for w in weights if w[0].year >= 2018 ]

    #create_plot(weights)
    create_plot(truncated_weights)
