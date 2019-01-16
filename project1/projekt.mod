set CRDNS;
set SATELITES;

param time {SATELITES} > 0;
param f_min {SATELITES} >= 0;
param f_max {j in SATELITES} >= f_min[j];

param n_min {CRDNS} >= 0;
param n_max {i in CRDNS} >= n_min[i];

param amt {CRDNS,SATELITES} >= 0;

var Dist {j in SATELITES} >= f_min[j], <= f_max[j];

minimize Error:  sum {j in SATELITES} time[j] * Dist[j];

subject to Diet {i in CRDNS}:
   n_min[i] <= sum {j in CRDNS} amt[i,j] * Dist[j] <= n_max[i];
