
library(readr)
m21_bincounts <- read_csv("m21_bincounts.csv")


library(dplyr)

# calculate hits, misses, correct rejections and false alarms
m21_bincounts <- m21_bincounts |> mutate(hits = (bin1 + bin13 ),
                                         misses = (bin2 + bin14),
                                         correctRejections = (bin7 + bin19),
                                         falseAlarms = (bin8 + bin20 ),
                                         totalTrials = (bin1 + bin13 + bin8 + bin20))


# calculate hit rate and false alarm rate

m21_bincounts <- m21_bincounts |> mutate(hit_rate = hits/totalTrials, fa_rate = falseAlarms/totalTrials)


# calculate zscores for hit rate and false alarm rate

# z-score function

zscore <- function(x) {(x - mean(x))/sd(x)}

m21_bincounts <- m21_bincounts |> mutate(hit_rate_z = c(zscore(hit_rate)),
                                         fa_rate_z = c(zscore(fa_rate)))

# calculate dprime
m21_bincounts <- m21_bincounts |> mutate(d_prime_raw = hit_rate - fa_rate, 
                                         d_prime = hit_rate_z - fa_rate_z)

# determine sensitivity category
m21_bincounts <- m21_bincounts |> mutate(sensitivity = if_else(d_prime > 0, "Sensitive", "Insensitive"))

# write file to disk
write_csv(m21_bincounts,"m21_bincounts_dprime.csv")
