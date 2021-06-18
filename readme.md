[![DOI](https://zenodo.org/badge/333422256.svg)](https://zenodo.org/badge/latestdoi/333422256)

This is the (julia) code for the publication:

V. Liakoni *, A. Modirshanechi *, J. Brea, and W. Gerstner
[*Learning in Volatile Environments with the Bayes Factor Surprise*](https://www.mitpressjournals.org/doi/abs/10.1162/neco_a_01352), Neural Computation 33, 269–340 (2021)

\* V.L. and A.M. made equal contribution to this article.

Contact:
[vasiliki.liakoni@epfl.ch](mailto:vasiliki.liakoni@epfl.ch), [alireza.modirshanechi@epfl.ch](mailto:alireza.modirshanechi@epfl.ch)

## Installation

Dependencies:

* Mac or Linux
* [Julia](https://julialang.org) (1.2)

Navigate into the NonstationaryModelLearning/src folder. \
Open a julia terminal, press "]" to enter the package management mode and type

(v1.2) pkg> activate .. \
(NonstationaryModelLearning) pkg> instantiate

All (julia) packages and dependencies will be installed automatically within this environment.

## Usage

julia> using NonstationaryModelLearning

To run the main simulations of the paper, type

julia> NonstationaryModelLearning.runner_compare()

Note that the simulations would take long, so the settings are different from the ones used in the paper. \
Uncomment the marked lines in the run_comparisons.jl file to replicate the paper's simulations. \
Parameters of the environments and of the learning algorithms can also be changed in the same file.

Otherwise, a good place to start with the learning algorithms and the environments is the examples.jl file.

The naming convention of the algorithms are same as used in the paper, \
apart from the Categorical task (section 2.3.2) which is called "Multinomial" in the code.

## Code

* gaussiantask: environment, learning algorithms and optimization functions for the Gaussian estimation task (section 2.3.1)
* multinomialtask: environment, learning algorithms and optimization functions for the Categorical estimation task (section 2.3.2)
* processandplot: results processing and plotting utilities.
* experiment: simulations for experimental predictions (section 2.4)
* parameterDicts: dictionaries with the optimized parameter values for different environments. \
Please refer to src/readme.txt for more information.


## Data and Figures

* doc/data_final: final results used for the paper's figures. \
There are some differences in naming conventions there, and we did not change them so that results are "as is" at publication time. Please refer to doc/data_final/readme.txt for more information.
* doc/figs: latex source code to reproduce the paper's figures.
