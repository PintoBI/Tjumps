%Code By: Bernardo Pinto

%This code simulates the temperature dependence of the membrane capacitance of a membrane circuit. 
% The variables defined at the beginning of the script specify the initial capacitance and the series resistance for a capacitor and resistor in series circuit, as well as the parameters for the heat generation and transfer in the system. 
% The time points for the temperature jump and the duration of the pulse are also defined.
% 
% This code sets up and solves numerically a system of differential equations to model the electrical circuit of the membrane, and then plotting the result.
% Here is a brief description of what each block of code does:
% 
%- Several global variables are defined: C0, w, A0, kappa, alpha,mem_d,mel_w, Tjump_start, and pulse_end. These are needed for simulating the temperature jump and voltage across the capacitor.
%     C0, Rs, Vrev, alpha, kappa, mem_d, mel_w, and A0 are given specific values taken from usual cell values, ref #1 or chosen to give the required Tjump
%     A sinusoidal voltage function is defined with a frequency of f and an angular frequency of w. The time points for evaluating the function are stored in tspan.
%     The ODE solver ode45 is used to solve the differential equation defined in the function solve_Vc with initial condition Vc0 and time points tspan. The result is stored in the variables time and Vc.
%     The function Temperature_changing is applied element-wise to time to obtain an array of temperatures that defines the Tjump.
%     C_T is defined as C0 multiplied by a factor that increases linearly with temperature.
%     The capacitive current I_cap is calculated as the element-wise derivative of Vc divided by the element-wise derivative of time.
%     The hilbert transform of I_cap is calculated and stored in H_I, and the hilbert transform of Vo is calculated and stored in H_V.
%     The impedance is calculated as the element-wise ratio of H_V and H_I and stored in Impedance.
%     The capacitance Cm is calculated as the negative reciprocal of the product of the imaginary part of Impedance and angular frequency.
%     A figure is created and Cm and C_T are plotted against time for comparison. The y-axis limits are set to zoom in on the Tjump region.

global C0
global w
global A0  
global kappa
global alpha
global mem_d
global mel_w
global Tjump_start
global pulse_end  

%TIME is IN SECONDS
C0=2e-9; % initial capacitance in F
Rs=1e5; % series resistance in ohms
alpha=0.143e-6;%(m^2/s) thermal difussivity of water
kappa=0.6;%(W) thermal conductivity of water

mem_d=1e-5;%(m) distance from the membrane to the melanin, estimated
mel_w=1e-6;%(m) width of the melanin slab, estimated
A0=7e11;%(W/m^3) heat generated by particles, arbitrary




Tjump_start=10e-2; % in seconds
Tjump_duration=1e-3; % in seconds
pulse_end = Tjump_start+Tjump_duration;

%define sinusoid
f=500;%frequency of applied signal
w=2*pi*f;%angular frequency
tspan=0:1e-6:0.5; %creates the time points


options = odeset('AbsTol',1e-10,'Refine', 20);

Vc0=0;
[time,Vc] = ode45(@(t,Vc) solve_Vc(Rs,Vc,t), tspan, Vc0,options);

%plot(time,Vc)

Vo=cos(w*time);

%plot(time,Vo)

Temperature = arrayfun(@Temperature_changing, time);
%plot(time,Temperature)

C_T=C0*(1+0.01.*Temperature);%1 percent increase of capacitance with each ºC


I_cap=C_T(2:end).*(diff(Vc)./diff(time));

H_I=hilbert(I_cap);
H_V=hilbert(Vo);
Impedance=H_V(2:end)./H_I;
Cm=-(1./(w*imag(Impedance)));

figure
plot(time(2:end)*1000,Cm)
hold on
plot(time*1000,C_T)
hold off

ax = gca; 
set(gca,'box','off')
set(gca, 'color', 'none','FontSize',12,'FontWeight','bold','FontName','Arial');
legend('Capacitance by Hilbert','Change in Capacitance','location','best','FontSize',12,'box','off','FontWeight','bold','FontName','Arial')
%set(gcf,'units','inches','position',[0,0,2.5,1.875])
xlabel('Time (ms)')
axis([(Tjump_start-10e-3)*1000 (Tjump_start+2e-2)*1000 C0*0.98 C0*1.1])
ylabel('Capacitance (nF)')
