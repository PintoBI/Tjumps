% This code performs the basic analysis for Capacitance-based Temperature Measurements (CTM). 
% 
%     The code begins by requesting three text files: one for subtraction of the optocapacitive effect when only the Tjump is applied, one for the currents elicited by a sinusoidal voltage pulse during Tjump, and one for the sinusoidal voltage pulse applied. These files are then loaded, and their data stored in the variables subtraction, current, and voltage, respectively.
%     The code then performs some preprocessing on these data sets: it separates the traces from the time data (first column in each file) and computes the mean trace for the "subtraction" data. It also subtracts the mean "subtraction" trace from each "current" traces in order to remove the optocapacitive components. Subsequently, it performs a baseline correction on both the subtracted "current" and "voltage" traces.
%     The code then applies the Hilbert transform to both the subtracted "current" and "voltage" traces to obtain their analytic signals. It then computes the impedance as the ratio of the analytic voltage signal to the analytic current signal. It also computes the instantaneous phase of the analytic voltage signal.
%     The code then iterates over the number of sweeps in the data and fits a linear function to the instantaneous phase of the voltage to obtain the frequency. It then uses this frequency to compute the capacitance at each time point from the imaginary part of the impedance.
%     The code then prompts the user to enter the bath temperature and uses this value to convert the capacitance time series into a temperature time series. It then plots this temperature time series and saves it to a file.

% Tested with provided test data sets on Matlab R2019b 10/Jan/2023.

%Subtraction
% Display a dialog box to select the file
[fileName, filePath] = uigetfile('*.txt', 'Select a subtraction file');

% Load the data from the file
subtraction = importdata(fullfile(filePath, fileName));
subtractiontraces=subtraction.data(:,2:end);
time=subtraction.data(:,1);

% Current
% Display a dialog box to select the file
[fileName, filePath] = uigetfile('*.txt', 'Select a current file',filePath);

% Load the data from the file
current = importdata(fullfile(filePath, fileName));
currentraces=current.data(:,2:end);

% Voltage
% Display a dialog box to select the file
[fileName, filePath] = uigetfile('*.txt', 'Select a voltage file',filePath);

% Load the data from the file
voltage = importdata(fullfile(filePath, fileName));
voltagetraces=voltage.data(:,2:end);
[num_points,num_sweeps]=size(voltagetraces);

%Analysis

substractiontrace=mean(subtractiontraces,2);%obtain a mean trace for the subtraction current 
sub_currentraces=currentraces-substractiontrace;%subtract the mean subtraction trace to the current traces


for i=1:num_sweeps
    basl_1(:,i) = sub_currentraces(:,i) - mean(sub_currentraces(:,i));
    basl_2(:,i) = voltagetraces(:,i) - mean(voltagetraces(:,i));
end

c_h=hilbert(basl_1);%hilbert transform of current 
v_h=hilbert(basl_2);%hilbert transform of voltage
Z=v_h./c_h;%Impedance
v_p =unwrap(angle(v_h));% instantaneous phase voltage

clear i
for i=1:num_sweeps

%Obtain the frequency as the slope of the phase
slop(:,i)=v_p(:,1)./(2.*pi);
frequency_fit=fit(time,slop(:,i),'poly1');

fitCoeffs=coeffvalues(frequency_fit);
Freq(i)=fitCoeffs(1);%frequency
C(:,i)=-1./(Freq(i).*imag(Z(:,i)));%obtain the capacitance with the imaginary part of imnpedance

end

 %Select Bath temperature
 bathT_prompt = 'What is the bath temperature?';
    dlg_Ttitle = 'Initial T';
    num_lines=1;
    default_T = {'19'};
    Tb=inputdlg(bathT_prompt,dlg_Ttitle,num_lines,default_T);
   
Cmean=mean(transpose(C(:,1:i)));%obtain average of all pulses
Ave_C=mean(Cmean(300:1500));%calculating the mean C before the Tjump
Norma_C=(Cmean/Ave_C); %Normalizing Capacitance
Temperature=((Norma_C-1)*110*(1/(0.011*str2double(Tb)+0.7910)))+str2double(Tb); %converting Capacitance in Temperature

%ploting the results
figure %making new figure
plot(time*1000,Temperature,'k-') %Ploting Temperature in black color
ax = gca; 
ax.FontSize = 14;
title('Mean Tjump-induced Temperature','FontSize',14,'FontWeight','bold')
xlabel('Time (ms)','FontSize',16,'FontWeight','bold')
t_axis='Temperature ';
unit_axis='  (^{o}C)';
str1=strcat(t_axis,unit_axis);%either str1 or str2 work
str2='Temperature (^{o}C)';
ylabel(str2,'FontSize',16,'FontWeight','bold')

% exporting the results
outh=horzcat(time*1000,transpose(Temperature));
writematrix([outh],append(filePath,'temperature.txt'),'Delimiter','tab')

