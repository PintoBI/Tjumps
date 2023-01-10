% Code By: Bernardo Pinto
% This code defines the function Temperature_changing that calculates the time-varying change in temperature at a given time T. 
% The temperature change is calculated based on three different cases:
% 
%     If T is less than the time at which the temperature jump (Tjump_start) occurs, the temperature is set to zero.
%     If T is greater than Tjump_start but less than or equal to the end of the pulse (pulse_end), the temperature is calculated using an equation involving the parameters A0, alpha, kappa, mem_d, and mel_w. This equation represents a mathematical model for the temperature increase due to a pulse of heat being applied to the system.
%     If T is greater than pulse_end, the temperature is calculated as the temperature at Tjump_start, minus a factor. This equation represents a mathematical model for the temperature increase after the heat pulse is applied to the system.
%     If none of the above conditions are met, the temperature is set to zero.
% 
% The function Temperature_changing takes a single input argument T, and returns a single output T_timecourse, which represents the temperature at time T. The function uses several global variables that are defined elsewhere in the code.

function [T_timecourse]= Temperature_changing (T)

global A0
global kappa
global alpha
global mem_d
global mel_w
global Tjump_start
global pulse_end 
  
    if (T<Tjump_start)

    T_timecourse=0;
    
    elseif (T>Tjump_start)&&(T<=pulse_end)
     
    T_timecourse=((A0*alpha/kappa)*((sqrt(((T-Tjump_start))/(alpha*pi))*((mem_d*exp(-(mem_d^2)/(4*alpha*((T-Tjump_start)))))-((mem_d-mel_w)*exp(-((mem_d-mel_w)^2)/(4*alpha*((T-Tjump_start)))))))+(((T-Tjump_start))+(((mem_d-mel_w)^2))/(2*alpha))*erfc((mem_d-mel_w)/(2*sqrt(alpha*((T-Tjump_start)))))-(((T-Tjump_start))+(((mem_d)^2))/(2*alpha))*erfc((mem_d)/(2*sqrt(alpha*((T-Tjump_start)))))));    
   
    elseif(T>pulse_end)
    
    T_timecourse=((A0*alpha/kappa)*((sqrt(((T-Tjump_start))/(alpha*pi))*((mem_d*exp(-(mem_d^2)/(4*alpha*((T-Tjump_start)))))-((mem_d-mel_w)*exp(-((mem_d-mel_w)^2)/(4*alpha*((T-Tjump_start)))))))+(((T-Tjump_start))+(((mem_d-mel_w)^2))/(2*alpha))*erfc((mem_d-mel_w)/(2*sqrt(alpha*((T-Tjump_start)))))-(((T-Tjump_start))+(((mem_d)^2))/(2*alpha))*erfc((mem_d)/(2*sqrt(alpha*((T-Tjump_start)))))))-((A0*alpha/kappa)*((sqrt(((T-pulse_end))/(alpha*pi))*((mem_d*exp(-(mem_d^2)/(4*alpha*((T-pulse_end)))))-((mem_d-mel_w)*exp(-((mem_d-mel_w)^2)/(4*alpha*((T-pulse_end)))))))+(((T-pulse_end))+(((mem_d-mel_w)^2))/(2*alpha))*erfc((mem_d-mel_w)/(2*sqrt(alpha*((T-pulse_end)))))-(((T-pulse_end))+(((mem_d)^2))/(2*alpha))*erfc((mem_d)/(2*sqrt(alpha*((T-pulse_end)))))));
   
    else
        
    T_timecourse=0;
    end
   

