# Port-Distance-Calculator
A calculator that is able to calculate the route distance between ports.
The basic idea of this calculator is to transfrom the world map to a grid map that would be further transformed to a cost map in the end. So, the land grids are assigned to a very large value and water girds are the oposite. In the end the shortestpPath algorithm is used to travel on the map to find the shortest distance between ports.


The source of the shape file come from the link below.
http://www.naturalearthdata.com/downloads/50m-cultural-vectors/50m-admin-0-countries-2/
