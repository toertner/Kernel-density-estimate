# Kernel-density-estimate

A Matlab script (kDense.m) to find out whether expression levels of two proteins are independent of each other or correlated. 
The kernel density estimate of the observed distribution is compared against the distribution expected from random pairs
(100 Monte Carlo samples) to identify statistically overrepresented regions by Z-score.

The script expects in the workspace a two-column matrix named "A" with intensity value pairs (cFos, deltaFosB immunofluorescence) 
from many neurons. Example data (granule cells, dentate gyrus, mouse) are provided ("mydata.mat"). To ananlyze your own measurements, use Matlab's Import Data function to load the contents of an Excel file to the workspace (output type: numeric matrix).

The function "cFos.m" is a simple simulation of cFos suppression by deltaFosB. Please note that time constants are not necessarily realistic.

Created by Thomas Oertner, 2022
