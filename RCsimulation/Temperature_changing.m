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
   

