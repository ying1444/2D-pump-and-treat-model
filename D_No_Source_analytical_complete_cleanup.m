clear
format long
v_darcy=0.0098; %ft/day

porosity=0.3;


X_plume_edge=1105/2; %ft
Y_plume_edge=709/2; %ft
X_hot_edge=10; %ft
Y_hot_edge=5; %ft

No_well =2;

Well_flow=192.5*2;

Q=No_well*Well_flow/(X_plume_edge*Y_plume_edge); %ft^3/day %well pumping rate normalized over capture area
porosity=0.3;
seepage_v=(v_darcy)/porosity;
seepage_Q=Q/porosity; %seepage velocity for advection taken as normalized seepage velocity caused by pumps

C_plume_edge=10*28.3; %concentration at plume edge from ug/L to ug/ft3
C_hot_edge=26340*28.3;

Dy=2; %ft
Dx=(Dy*(X_plume_edge/3)^2/(Y_plume_edge/3)^2); %ft

syms CoA_imaginary_initial t_imaginary_initial
eqns = [
   C_plume_edge==((CoA_imaginary_initial/(4*pi*t_imaginary_initial*sqrt(Dx*Dy)))*exp((-((0-seepage_v*t_imaginary_initial)^2)/(4*t_imaginary_initial*Dx))-(Y_plume_edge^2/(4*t_imaginary_initial*Dy)))),   
     C_hot_edge==((CoA_imaginary_initial/(4*pi*t_imaginary_initial*sqrt(Dx*Dy)))*exp((-((0-seepage_v*t_imaginary_initial)^2)/(4*t_imaginary_initial*Dx))-(Y_hot_edge^2/(4*t_imaginary_initial*Dy)))),
 ];
vars =[CoA_imaginary_initial t_imaginary_initial];
[sol_CoA, sol_t,] = solve(eqns,vars);
eval_sol_CoA=eval(sol_CoA); %imaginary initial point contaminant mass input
eval_sol_t=eval(sol_t); %imaginary time elapsed since contaminant mass input




i=1;
j=1;

dx=30;

dy=20;
dt=100;



    for x=-553:dx:553
    
        for y=-355:dy:355
       
        C_initial(i,j)=((eval_sol_CoA/(4*pi*eval_sol_t*sqrt(Dx*Dy)))*exp((-((x-seepage_v*eval_sol_t)^2)/(4*eval_sol_t*Dx))-(y^2/(4*eval_sol_t*Dy))));
        i=i+1;
        end
    j=j+1;
    i=1;
    end
    
%can input breakpoint right after this to stop code and check out a contour
%plot of initial plume
contourf(C_initial)
colorbar;
i=1;
j=1;
t_increment=1;
F(t_increment) = getframe(gcf);
t_increment=2;
[m,n]=size(C_initial); 
   

set(gca, 'nextplot', 'replacechildren');  
caxis manual; 
caxis([0 7e6]);
    
w = VideoWriter('CompleteAnalytical.avi');
w.FrameRate=30;

        
open(w);
C(:,:,t_increment-1)=C_initial;
F(t_increment) = getframe(gcf);
    
 
  
    while any(any(C(:,:,t_increment-1)>(10*28.3)))>0
        
        for x=-553:dx:553
    
            for y=-355:dy:355
                
       
                C(i,j,t_increment)=((eval_sol_CoA/(4*pi*(eval_sol_t+t_increment*dt)*sqrt(Dx*Dy)))*exp(-((x-seepage_Q*(eval_sol_t+t_increment*dt))^2/(4*Dx*(eval_sol_t+t_increment*dt))+(y^2/(4*Dy*(eval_sol_t+t_increment*dt))))));
                i=i+1;
            end
            i=1;
            j=j+1;
            
        end
    
        contourf(C(:,:,t_increment));
        colorbar;
        title('Removed Source 5 Year Plume (Analytical)')
        xlabel('Y distance (ft)') 
        ylabel('X distance (ft)') 

    drawnow;
   
        F(t_increment) = getframe(gcf);
     
    
        t_increment = t_increment+1;
        j=1;
        
 
    end
writeVideo(w,F)
close(w);
time=t_increment*dt; %days 
 