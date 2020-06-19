require('abc')
require('dplyr')
require('ggplot2')

prior = read.table('vert_prior.csv',header=T,stringsAsFactors = F)
data = read.table('vert_data.csv',header=T,stringsAsFactors = F)

do_abc_mpr = function(dt,prior) {
  omega1 = dt[1]
  dstat = dt[2:3]
  pr = filter(prior,omega==as.character(omega1))
  prior_stat = select(pr,s1,s2)
  mpr=postpr(dstat, as.character(pr$model), prior_stat, tol=.01, method = 'mnlogistic')$pred[2]
  return(mpr)
  }

do_abc_est = function(dt,prior,model) {
  omega1 = dt[1]
  dstat = dt[2:3]
  pr = filter(prior,omega==as.character(omega1))
  prior_stat = select(pr[pr$model==model,],s1,s2)
  prior_param = select(pr[pr$model==model,],k,f)
  post = abc(target=dstat, param=prior_param,sumstat=prior_stat, tol=0.01,method="ridge",transf = 'none')
  post = post$adj.values
  return(data.frame(post))
}

mpr_m1 = do_abc_mpr(filter(data,omega=='m1'),prior)
mpr_m2 = do_abc_mpr(filter(data,omega=='m2'),prior)
mpr_m3 = do_abc_mpr(filter(data,omega=='m3'),prior)

model_pr = data.frame(mpr=c(mpr_m1,mpr_m2,mpr_m3))
model_pr$omega = c('m1','m2','m3')

ggplot(model_pr) + geom_col(aes(omega,1,fill='model1'),size=.2,color='black') + 
  geom_col(aes(omega,mpr,fill='model2'),size=.2,color='black') +
  theme_light() + xlab('dN/dS') +
  ylab('posterior probability') + 
  scale_fill_manual(values=c('gray90','grey60'),
                    labels=c('model1','model2'),name='')

est_m1 = do_abc_est(filter(data,omega=='m1'),prior,'model2')
est_m2 = do_abc_est(filter(data,omega=='m2'),prior,'model2')
est_m3 = do_abc_est(filter(data,omega=='m3'),prior,'model2')

est_m1$omega = 'm1'
est_m2$omega = 'm2'
est_m3$omega = 'm3'
param_pr = rbind(est_m1,est_m2,est_m3)

ggplot(param_pr, aes(f,k)) + facet_wrap(~omega,nrow = 1) + 
  stat_density2d(aes(alpha=..level.., fill=..level..), size=2,
                 bins=10, geom="polygon") +
  scale_fill_gradient(low = "yellow", high = "red") +
  scale_alpha(range = c(0.00, 0.5), guide = FALSE) +
  geom_density2d(colour="black", bins=5,alpha=0.3) +
  geom_point(size=.5) + geom_hline(yintercept = 0) +
  guides(alpha=FALSE) + #ylim(c(-100, 100)) + xlim(c(0, 1)) +
  coord_cartesian(xlim=c(0,1),ylim=c(-100,100),clip="off") +
  theme_bw() + theme(legend.position="none",panel.spacing = unit(1, "lines"),plot.margin = unit(c(1,1,1,1), "lines")) + 
  scale_x_continuous(breaks=c(0,0.5,1),labels = c(0,0.5,1),limits = c(0,1),expand = c(0,0)) +
  scale_y_continuous(expand = c(0,0)) + 
  xlab(expression(paste('fraction of senescing/entrenched alleles')))+
  ylab(expression(italic(k)))
