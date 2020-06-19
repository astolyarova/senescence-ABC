# senescence-ABC

Files `vert_prior.csv` and `insects_prior.csv` contain pre-calculated summary statistics for the prior simulations.
In the simulations, the fitness of the allele currently occupying an amino acid sites changes linearly with rate *k*. 
Positive values of *k* correspond to entrenchment (the allele becomes more preferable with time), and negative values
of *k* correspond to senescence (the allele becomes less preferable with time). We used two prior models. In the first one (model1), all alleles experiance entrenchment or senescence. In the second one (model2), only the fraction *f* of the sites
experience entrenchment or senescence, while the rest evolves on the static fitness landscape.
For more details on the method, see preprint at https://www.biorxiv.org/content/10.1101/794743v2

The simulations were performed with `SELVa` (available at https://github.com/bazykinlab/SELVa). 
The summary statistics calculated from the real genomic data are in `vert_data.csv` and `insects_data.csv`.

The datasets with different dN/dS (omega) are designated as follows:
* m1 - omega < 1 (negative selection)
* m2 - omega = 1 (neutral sites)
* m3 - omega = 1 (positive selection)

The script `senescence_ABC.R` uses the prior distribution to perform approximate Bayesian computations (ABC) to compare
the prior models and to infer parameters for the data. The output are the posterior probability distributions for the parameters *k* (rate of
the change of the current allele fitness) and *f* (the fraction of alleles under senescence or entrenchment).
The data provided here will reproduce Fig. 5 from the preprint above.

The libraries required:
* `abc`
* `dplyr`
* `ggplot2` (for the plots)
