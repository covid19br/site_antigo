###############################################################################
# Estimating R accounting for uncertainty on the serial interval distribution #
###############################################################################
## - the mean of the SI comes from a Normal(4.8, 0.71), truncated at 3.8 and 6.1
## - the sd of the SI comes from  a Normal(2.3, 0.58), truncated at 1.6 and 3.5
## 
##   day0 : day to start the analysis
##   delay : 7 #number of days
estimate.R0 <- function(novos.casos, day0=8, delay=7, ...){
    config <- make_config(list(si_parametric_distr = "L",
                               mean_si = 4.8, std_mean_si = 0.71,
                               min_mean_si = 3.8, max_mean_si = 6.1,
                               std_si = 2.3, std_std_si = 0.58,
                               min_std_si = 1.6, max_std_si = 3.5,
                               t_start = seq(day0,length(novos.casos)-delay),
                               t_end = seq(delay+day0,length(novos.casos))))
    estimate_R(novos.casos, method = "uncertain_si", config = config)
}
