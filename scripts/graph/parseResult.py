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

# Get value from param
folder = sys.argv[2]
file_ouput = sys.argv[3]

extention = ".flent"

# Make the CDF plot 
def cdfplotdata(data_in, _xlabel = 'x', _ylabel = r'P(X$\leq$x)',
        _title = 'CDF',
        _name = 'Ping', _lw = 2, _fs = 'x-large', _fs_legend='medium',
        _ls = '-', _loc = 2):
    "Plot the cdf of a data array"
    data = pylab.array(data_in, copy=True)
    data.sort()
    l = len(data)
    cdf = pylab.arange(l)/(l - 1.0)
    plt.plot(data, cdf, 'k', lw = _lw, drawstyle = 'steps',
            label = _name, ls = _ls)
    plt.xlabel(_xlabel, size = _fs)
    plt.ylabel(_ylabel, size = _fs)
    plt.title(_title, size = _fs)
    font = FontProperties(size = _fs_legend)
    plt.legend(loc = _loc, prop = font)
    plt.show()


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
	r_debit = []
	files_r = []

	fig_size = plt.rcParams["figure.figsize"]
	fig_size[0] = 14 # width
	fig_size[1] = 8 # heigth
	plt.rcParams["figure.figsize"] = fig_size
	host = host_subplot(111)
	host.set_ylabel("Mbit/s")

	files_r = parse_files(folder)
        for filename in files_r:
                if extention == ".flent":
                  f = open(filename,"rb")
                else:
		  f = gzip.open( filename,"rb")
		data = json.load(f)
		f.close()
		d = ([f for f in data['results']['TCP download'] if f is not None])
	 	d = d[10:-10]
		p = ([f for f in data['results']['Ping (ms) ICMP'] if f is not None])
		r_debit.append(d)
		label = "bw: " +  filename.split("-")[-2].split("_")[0] + "mbit/s rtt: " + str(int(filename.split("-")[-1].split("_")[0])*2) + "ms"
		ticklabels.append("link 1 " + label + "\n" + "link 2 " + label)
	# draw boxplot and set colors
	bp1 = host.boxplot(r_debit, positions=np.array(xrange(len(r_debit)))*2.0, sym='', widths=0.4)
	color1 = '#60AAAA'
	set_box_color(bp1, color1) 
	# draw temporary red and blue lines and use them to create a legend
	plt.plot([], c=color1, label='Throughput')
	plt.legend()
        best_m= 0
        for i in r_debit:
             if max(i) > best_m:
                best_m = max(i)
	plt.yticks(xrange(0, int(60),5 ))
	plt.xticks(xrange(0, len(ticklabels)*2,2 ), ticklabels, rotation=45)
	plt.xlim(-1, len(ticklabels)*2)
	plt.ylim(-1)
	plt.grid()
	plt.tight_layout()

	plt.title(folder.split("/")[-2])
	plt.savefig(file_ouput, format='PDF')

#Generate the CDF of the ping
def cdf_ping(folder):
	r_ping = []
	files_r = parse_files(folder)

	for filename in files_r:
		f = gzip.open(filename,"rb")
		data = json.load(f)
		f.close()
	 	p = ([f for f in data['results']['Ping (ms) ICMP'] if f is not None])
		r_ping.append(p)
	for result in r_ping:
		result.sort()
		d = numpy.array(result)
		cdf = cdfplotdata(d)


# Main
if sys.argv[1] == "plotbox":
   plot_box_debit(folder)
if sys.argv[1] == "cdf":
   cdf_ping(folder)
