clc
clear all
close all


KTAV=25;
Q=12;
V=2;
Cb_w_sat=1780;
Ct_w_sat=520;
Ch_w_sat=13;
Mn=50*1000;
Mb_n=0.3*Mn;
Mb_n_initial=Mb_n
Mt_n=0.3*Mn;
Mh_n=0.4*Mn;
MW_b=78;
MW_t=92;
MW_h=86;
xb=(Mb_n/MW_b)/((Mb_n/MW_b)+(Mt_n/MW_t)+(Mh_n/MW_h));
xt=(Mt_n/MW_t)/((Mb_n/MW_b)+(Mt_n/MW_t)+(Mh_n/MW_h));
xh=(Mh_n/MW_h)/((Mb_n/MW_b)+(Mt_n/MW_t)+(Mh_n/MW_h));
Cb_w=0
Ct_w=0
Ch_w=0
dt=0.01;
dCb_w=0;
i=1;
t=0;
while Mb_n-0.1*Mb_n_initial>10
    Cb_w_eq=xb*Cb_w_sat;
    dCb_n=KTAV*(Cb_w_eq-Cb_w)
    dCb_flow=-(Q*Cb_w/V)
    dCb_w=KTAV*(Cb_w_eq-Cb_w)-(Q*Cb_w/V)
    Cb_w_t=dCb_w*dt+Cb_w
    Mb_n_t=-dCb_n*dt*V+Mb_n
    Cb_w=Cb_w_t
    Mb_n=Mb_n_t
    pCb_w(i)=Cb_w;
    
    Ct_w_eq=xt*Ct_w_sat;
    dCt_n=KTAV*(Ct_w_eq-Ct_w);
    dCt_flow=-(Q*Ct_w/V);
    dCt_w=KTAV*(Ct_w_eq-Ct_w)-(Q*Ct_w/V);
    Ct_w_t=dCt_w*dt+Ct_w;
    Mt_n_t=-dCt_n*dt*V+Mt_n;
    Ct_w=Ct_w_t;
    Mt_n=Mt_n_t;
    
    Ch_w_eq=xh*Ch_w_sat;
    dCh_n=KTAV*(Ch_w_eq-Ch_w);
    dCh_flow=-(Q*Ch_w/V);
    dCh_w=KTAV*(Ch_w_eq-Ch_w)-(Q*Ch_w/V);
    Ch_w_t=dCh_w*dt+Ch_w;
    Mh_n_t=-dCh_n*dt*V+Mh_n;
    Ch_w=Ch_w_t;
    Mh_n=Mh_n_t;
    
    xb=(Mb_n/MW_b)/((Mb_n/MW_b)+(Mt_n/MW_t)+(Mh_n/MW_h));
    xt=(Mt_n/MW_t)/((Mb_n/MW_b)+(Mt_n/MW_t)+(Mh_n/MW_h));
    xh=(Mh_n/MW_h)/((Mb_n/MW_b)+(Mt_n/MW_t)+(Mh_n/MW_h));
    
    pt(i)=t;
    t=t+dt
    i=i+1
end

plot(pt,pCb_w)
xlabel('Time (days)')
ylabel('Benzene Concentration in NAPL (mg/mL)')
title('Decrease of Benzene Concentration in NAPL Over Time')
