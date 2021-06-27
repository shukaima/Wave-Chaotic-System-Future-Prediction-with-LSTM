plot(real(S11(:,1)));
xlabel(['realization no.']);
ylabel(['Re(S_{11})']);
%%
clc
step=120;
corr(real(S11(1:step,1)),real(S11(step+1:step*2,1)))
corr(real(S11(1+step:step*2,1)),real(S11(step*2+1:step*3,1)))
corr(real(S11(1+step*2:step*3,1)),real(S11(step*3+1:step*4,1)))
corr(real(S11(1+step*3:step*4,1)),real(S11(step*4+1:step*5,1)))
%%
step=160;
for i=1:5
    ctl(i)=corr(real(S11(1+step*(i-1):step*i,1)),real(S11(step*i+1:step*(i+1),1)));
end
mean(ctl)
%%
step=160;
clear ctl
for i=1:5
    ctl(i)=corr2(real(S11(1+step*(i-1):step*i,1)),real(S11(step*i+1:step*(i+1),1)));
end
mean(ctl)