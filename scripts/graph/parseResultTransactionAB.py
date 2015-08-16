import json
from pylab import *
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import host_subplot
import os
import gzip
import numpy as np
import pylab
import csv

# Get value from param
file_path = sys.argv[1]
file_ouput = sys.argv[2]
# Create list
tcpMeans = list()
udpMeans = list()
label_x= list()

# Read the file and add the value to lists.
def graph(filep):

	filec = open(filep,"rb")
	data = csv.reader( filec, delimiter=',')
        for line in data:
          if line[0] != "Test Name":
          	label= line[0].strip("tcp_").split("_")

          	label_x.append("both link \n bw: " + label[0] + "mbit/s rtt: " + str(int(label[1]) * 2) + "ms")
          	if line[0].startswith("tcp"):
             	  tcpMeans.append(float(line[2]))
          	else:
             	  udpMeans.append(float(line[2]))
	filec.close()



graph(file_path)

N = len(tcpMeans)
# the x locations for the groups
ind = np.arange(N)
# the width of the bars: can also be len(x) sequence
width = 0.25
p1 = plt.bar(ind + 0.25, tcpMeans,width, color='r')
p2 = plt.bar(ind + 0.5, udpMeans, width, color='y')

plt.ylabel('Transaction per second')
plt.title('Transaction per second UDP and TCP')
plt.xticks(ind-width,  label_x, rotation=45  )
plt.yticks(np.arange(0,max(udpMeans),200))
plt.legend( (p1[0], p2[0]), ('TCP', 'UDP'), loc=1, borderaxespad=0.)
plt.grid()
plt.tight_layout()

plt.savefig(file_ouput, format='PDF')
