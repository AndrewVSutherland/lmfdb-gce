# output as png image
set terminal png

# save file to "benchmark.png"
set output "benchmark0.png"

# This sets the aspect ratio of the graph
set size 1, 1

# The graph title
set title "Apache Benchmark"

# Where to place the legend/key
#set key left top

# Draw gridlines oriented on the y axis
set grid y

# Specify that the x-series data is time data
set xdata time

# Specify the *input* format of the time data
set timefmt "%s"

# Specify the *output* format for the x-axis tick labels

set format x "%H:%M"

# Label the x-axis
set xlabel "Time, h:min"

# Label the y-axis
set ylabel "Response time, ms"

# Tell gnuplot to use tabs as the delimiter instead of spaces (default)
set datafile separator '\t'

# Plot the data
plot "all.tsv" using 2:5 with points notitle

