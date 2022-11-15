%obtain circuit parameters when C changes continuosly
%define sinusoid
clear all
% close all
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
C0=2e-9; %in F
Rs=1e5; % in ohms
Vrev=140;%Surface potential
V0=0;
alpha=20;%(W/m^3) heat generated by particles, arbitrary
kappa=0.6;%(W) thermal conductivity of water

mem_d=1.5e-5;%(m) distance from the membrane to the melanin
mel_w=5e-7;%(m) width of the melanin slab
A0=5e7;%(W/m^3) heat generated by particles, estimated
a=0.01; %coeff for C change with temperature: 10% per 10 


Tjump_start=10e-2; % in seconds
Tjump_duration=1e-3; % in seconds
pulse_end = Tjump_start+Tjump_duration;


f=500;%frequency of applied signal
w=2*pi*f;%angular frequency
tspan=0:1e-6:0.5; %creates the time points

Vc0=0;

options = odeset('AbsTol',1e-10,'Refine', 20);


[time,Vc] = ode45(@(t,Vc) solve_Vc(Rs,Vc,t), tspan, Vc0,options);

%plot(time,Vc)

Vo=cos(w*time);

%plot(time,Vo)

Temperature = arrayfun(@Temperature_changing, time);
%plot(time,Temperature)

C_T=C0*(1+0.01.*Temperature);



I_cap=C_T(2:end).*(diff(Vc)./diff(time));

H_I=hilbert(I_cap);
H_V=hilbert(Vo);
Impedance=H_V(2:end)./H_I;
Cm=-(1./(w*imag(Impedance)));

figure
plot(time(2:end),Cm)
hold
plot(time,C_T)

axis([Tjump_start-10e-3 Tjump_start+2e-2 C0*0.98 C0*1.1])