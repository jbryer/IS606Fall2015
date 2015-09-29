sat <- rnorm(1000, mean=1500, sd=300)
hist(sat)
act <- rnorm(1000, mean=21, sd=5)
hist(act)

par.orig <- par(mfrow=c(2,1))
hist(sat); hist(act)
par(par.orig)

hist(c(sat, act))

act.z <- (act - mean(act)) / sd(act)
sat.z <- (sat - mean(sat)) / sd(sat)

mean(act.z); sd(act.z)
mean(sat.z); sd(sat.z)

par.orig <- par(mfrow=c(2,1))
hist(sat.z); hist(act.z)
par(par.orig)

# z = (i - mean) / sd
# z * sd = i - mean
# z * sd + mean = i

act.sat <- act.z * 300 + 1500

par.orig <- par(mfrow=c(2,1))
hist(act.sat); hist(act)
par(par.orig)

