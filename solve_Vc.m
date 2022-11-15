function [dVc]=solve_Vc(R,Vc,t,I)
global C0
global w

Vo=cos(w*t);
C_T=C0*(1+0.01*Temperature_changing(t));
dVc=(Vo-Vc)/(R*C_T);


