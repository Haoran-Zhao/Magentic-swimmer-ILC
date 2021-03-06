function[sys, x0, str, ts]=testthrust(t, x, u, flag)
%estimated data...to be updated

R=5.05*0.3048; 
Omega=870/60*2*pi ; 

rho =1.29;  
a=6.0 ; 
B=2; 
c=0.354*0.3048;
Ib=0.86754;
g=9.81 ;
e =0; 
mb=0.3;
Mb=(mb*R^2)/(2)*(1-e/R)^2*g ;
K=100;

switch flag,

  case 0
    [sys,x0,str,ts]=mdlInitializeSizes(t,x,u,B,rho,a,e,c,Ib,R,g,Omega,K,Mb);

    case 3
    sys=mdlOutputs(t,x,u,B,rho,a,e,c,Ib,R,g,Omega,K,Mb);
    
    case {1, 2, 4, 9}
    sys=[];

  otherwise
    error(['Unhandled flag =', num2str(flag)]);

end


function [sys,x0,str,ts]=mdlInitializeSizes(t,x,u,B,rho,a,e,c,Ib,R,g,Omega,K,Mb)

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

x0  = [];
str = [];
ts  = [-1 0];


function sys=mdlOutputs(t,x,u,B,rho,a,e,c,Ib,R,g,Omega,K,Mb)

%inputs:
theta_col=[1 0 0]*u;
vi0=[0 1 0]*u;
T_old=[0 0 1]*u;
beta_1s=0;
beta_1c=0;
theta_twist=4.864e-4;
bu=0;bv=0;bw=0;p=0;q=0;

A=pi*R^2;

vi=vi0;


w_r=bw+beta_1c*bu-beta_1s*bv;
w_b=w_r+(2/3)*Omega*R*(theta_col+0.75*theta_twist);

vi2=vi^2;

for ii=1:5
    T_MR=(w_b-sqrt(vi2))*(rho*Omega*R*a*B*c*R)/4;
    v2=bu^2+bv^2+w_r*(w_r-2*vi);
    vi2=sqrt((v2/2)^2+(T_MR/(2*rho*A))^2)-v2/2;
    vi=sqrt(vi2);
end


%Outputs:
sys=T_MR;



   