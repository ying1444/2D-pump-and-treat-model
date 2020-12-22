
clear

X_plume_edge=1105/2; %ft %plume edge dist from center in X
Y_plume_edge=709/2; %ft %plume edge dist from center in Y

X_hot_edge=10; %ft %max concentration area dist from center in X
Y_hot_edge=5; %ft %max concentration area dist from center in Y

No_well =2; %number of wells
Well_flow=2*192.5; %flow rate per well from gpm to ft3/day

v_darcy=0.0098; %ft/day %aqifer flow rate
Q=No_well*Well_flow/(X_plume_edge*Y_plume_edge); %ft^3/day %well pumping rate normalized over capture area
porosity=0.3;
seepage_v=(v_darcy)/porosity;
Aquifer_thickness=66;
vol_tank=160;%L

density_TCE = 1.61*1000; %g/L
MW_TCE = 131.4; %g/mol
diffusion_TCE=0.0303; %cm2/hr
K_TCE=0.0259; %cm/hr
long_dispersivity= 0.32*((Y_plume_edge*2)^0.83);
trans_dispersivity = 0.3*long_dispersivity;
C_TCE_sat=1100; %mg/L

density_ben = 0.876*1000; %g/L
MW_ben = 78.11; %g/mol
diffusion_ben=0.0666; %cm2/hr
K_ben=0.013; %cm/hr
long_dispersivity= 0.32*((Y_plume_edge*2)^0.83);
trans_dispersivity = 0.3*long_dispersivity;
C_ben_sat=1780; %mg/L

density_NAPL=density_TCE*0.72+density_ben*0.27;

V_trans=1.64*1.64*Aquifer_thickness;
Mass_total_NAPL= density_NAPL*vol_tank
mass_ben=0.27*Mass_total_NAPL;
mass_TCE=0.73*Mass_total_NAPL;
dt=1;
t_increment=1;
i=1;
j=1;
xb=(mass_ben/MW_ben)/((mass_ben/MW_ben)+(mass_TCE/MW_TCE));
xt=(mass_TCE/MW_TCE)/((mass_ben/MW_ben)+(mass_TCE/MW_TCE));
C(i,j,t_increment)=1
C_ben(i,j,t_increment)=C(i,j,t_increment)*0.27

C_TCE(i,j,t_increment)=C(i,j,t_increment)*0.73
AV=1/Aquifer_thickness;

    C_ben_eq=xb*C_ben_sat;
    dC_ben=K_ben*AV*(C_ben_eq-C_ben(i,j,t_increment))
  
    
    C_ben(i,j,t_increment+1)=dC_ben*dt+C_ben(i,j,t_increment)
    mass_ben(t_increment+1)=-dC_ben*dt*V_trans+mass_ben(t_increment)
    
    C_TCE_eq=xb*C_TCE_sat;
    dC_TCE=K_TCE*AV*(C_TCE_eq-C_TCE(i,j,t_increment))
  
    
    C_TCE(i,j,t_increment+1)=dC_ben*dt+C_TCE(i,j,t_increment)
    mass_TCE(t_increment+1)=-dC_TCE*dt*V_trans+mass_TCE(t_increment)


    
%{
    
    xb=(Mb_n/MW_b)/((Mb_n/MW_b)+(Mt_n/MW_t)+(Mh_n/MW_h));
    xt=(Mt_n/MW_t)/((Mb_n/MW_b)+(Mt_n/MW_t)+(Mh_n/MW_h));
    xh=(Mh_n/MW_h)/((Mb_n/MW_b)+(Mt_n/MW_t)+(Mh_n/MW_h));
    
    pt(i)=t;
    t=t+dt
    i=i+1

%}


