% Code By: Bernardo Pinto
% This function calculates the rate of change of voltage across the membrane capacitor driven  with variable capacitance.
% This function takes in 3 input arguments:
%     R: a scalar representing the series resistance in ohms
%     Vc: a scalar representing the voltage across the capacitor
%     t: a scalar representing the current time
% 
% It also uses 2 global variables:
% 
%     C0: a scalar representing the initial capacitance in Farads
%     w: a scalar representing the angular frequency of the applied sinusoidal signal
% 
% The function calculates the voltage Vo at the current time t using the equation Vo = cos(w*t). Then, it calculates the temperature-dependent capacitance C_T using the Temperature_changing function and the current time t.
% 
% Finally, it calculates the time derivative of the voltage across the capacitor, dVc, using the equation dVc = (Vo - Vc)/(R*C_T).
% This represents the rate of change of the voltage across the capacitor at a given time, which is determined by the voltage applied to the capacitor, the resistance in series with the capacitor, and the capacitance of the capacitor. 
% The function returns dVc as its output.
% 

function [dVc]=solve_Vc(R,Vc,t)
global C0
global w

Vo=cos(w*t);
C_T=C0*(1+0.01*Temperature_changing(t));
dVc=(Vo-Vc)/(R*C_T);


