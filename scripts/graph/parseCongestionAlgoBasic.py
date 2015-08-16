import json
from pylab import *
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import host_subplot
import os
import gzip
import numpy
import pylab
from matplotlib import mlab
from matplotlib.font_manager import FontProperties
import csv

# Get value from param
folder = sys.argv[2]
file_ouput = sys.argv[3]

extention = ".csv"



# function for setting the colors of the box plots pairs
def set_box_color(bp, color):
    plt.setp(bp['boxes'], color=color)
    plt.setp(bp['whiskers'], color=color)
    plt.setp(bp['caps'], color=color)
    #plt.setp(bp['medians'], color=color)

def parse_files(folder):
	files = []

	for dirname, dirnames, filenames in os.walk(folder):
	    # print path to all subdirectories first.
	    filenames.sort()
	    for filename in filenames:
		if filename.endswith(extention):
			files.append(os.path.join(dirname, filename))
	return files

# Generate plot box for composed of Bandwith and Ping boxes
def plot_box_debit(folder):
	ticklabels = []
	r_debit_olia = []
        r_debit_lia = []
  	r_debit_cubic = []
  	r_debit_wvegas = []
	files_r = []

	fig_size = plt.rcParams["figure.figsize"]
	fig_size[0] = 14 # width
	fig_size[1] = 8 # heigth
	plt.rcParams["figure.figsize"] = fig_size
	host = host_subplot(111)
	host.set_ylabel("Mbit/s")

	files_r = parse_files(folder)
        for filename in files_r:
            filec = open(filename,"rb")
            f = csv.reader( filec, delimiter=',')
            d =  []
            # parse csv row and select only the value we want
	    for row in f:
             d.append(float(row[0]))
            d = d[0:-1]
	    filename = filename.replace(folder,"")
	    filename_split = filename.split("-")
	    print(filename) 	
            if  filename_split[0] == "olia":
                r_debit_olia.append([d])
                label = "bw: " + filename_split[1].split("_")[0] + "mbit/s rtt: " + str(int(filename_split[2].split("_")[0])*2) + "ms" 
		ticklabels.append("link 1 " + label + "\n" + "link 2 " + label)
  	    if  filename_split[0] == "cubic":
            	r_debit_cubic.append([d])
            if  filename_split[0] == "lia":
            	r_debit_lia.append([d])
            if  filename_split[0] == "wvegas":
                r_debit_wvegas.append([d])
      
	    
            filec.close()
        print(ticklabels)
        # draw boxplot and set colors
        i = 0
        for i in range(0,3):
	    bp1 = host.boxplot(r_debit_olia[i], positions=np.array(xrange(len(r_debit_olia[i])))*2.0+(2*i)-0.45, sym='', widths=0.25)
	    bp2 = host.boxplot( r_debit_cubic[i], positions=np.array(xrange(len(r_debit_cubic[i])))*2.0+(2*i)-0.15, sym='', widths=0.25)
	    bp3 = host.boxplot( r_debit_lia[i], positions=np.array(xrange(len(r_debit_lia[i])))*2.0+(2*i)+0.15, sym='', widths=0.25)
	    bp4 = host.boxplot( r_debit_wvegas[i], positions=np.array(xrange(len(r_debit_wvegas[i])))*2.0+(2*i)+0.45, sym='', widths=0.25)
	    color1 = 'blue'
	    color2 = 'red'
	    color3 = 'yellow'
	    color4 = 'green'
	    set_box_color(bp1, color1)
	    set_box_color(bp2, color2)
	    set_box_color(bp3, color3)
	    set_box_color(bp4, color4)
            i = i +1
	# draw temporary red and blue lines and use them to create a legend
	plt.plot([], c=color1, label='olia' )
	plt.plot([], c=color2, label='cubic' )
	plt.plot([], c=color3, label='lia' )
	plt.plot([], c=color4, label='wvegas' )
	plt.legend(loc=5)
        best_m= 0
        for i in r_debit_cubic:
             if max(i) > best_m:
                best_m = max(i)
	plt.yticks(xrange(0, int(60), 5))
	plt.xticks(xrange(0, len(ticklabels)*2,2 ), ticklabels)
	plt.xlim(-1, len(ticklabels)*2)
	plt.ylim(-1)
	plt.grid()
	plt.tight_layout()
	plt.title("Congestion algorithms comparison")
	plt.savefig(file_ouput, format='PDF')



# Main
if sys.argv[1] == "plotbox":
   plot_box_debit(folder)
