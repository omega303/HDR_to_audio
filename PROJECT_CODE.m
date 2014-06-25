% HDR to AUDIO Signals RESCALING AND RANGE DENSITY FUNCTION CODE
clc;
close all;
clear all;

% ------------------------------------------------------------------------
% IDENTIFYING THE MYDAQ DEVICE
%  daq.getDevices
% CREATING A NEW SESSION
% s = daq.createSession('ni');
% ---------------------------FOR CHANNEL 1---------------------------------
% ADDING AN ANALOG VOLTAGE INPUT CHANNEL
% ch0 = s.addAnalogInputChannel('myDAQ1', 'ai0', 'Voltage');
%PUTTING AN ANTI-ALIASING FILTER - BUTTERWORTH FILTER  

% --------------------Test signal without the MyDAQ-----------------------
f = 500;
fs = 20e3;
t = 0:1/fs:1;
ch0  = (2*0.125).*sin(2*pi*f.*t);
ch1  = (18*2*0.125).*sin(2*pi*f.*t);

for R = 1:fs+1
        if (ch1(R)> 2)
            ch1(R) = 2;
        elseif (ch1(R)< -2)
            ch1(R) = -2;            
        end
end   

% Qauntisation of the Test Signal
partition = [-2:.0000610 :1.999939]; % Length 65535, to represent 2^16=65536 intervals
codebook = [-1.9999695:0.0000610:2.0000305]; % Length 65536, one entry for each interval
[index1,quants1] = quantiz(ch0,partition,codebook); % Quantize.
[index2,quants2] = quantiz(ch1,partition,codebook); % Quantize 

% partition = [-2:.25 :1.75]; % Length 65535, to represent 2^16=65536 intervals
% codebook = [-1.75:.25:2.25]; % Length 65536, one entry for each interval
% [index1,quants1] = quantiz(ch0,partition,codebook); % Quantize.
% [index2,quants2] = quantiz(ch1,partition,codebook); % Quantiz

% ------------------------------------------------------------------------
% fnorm = [0 fs/2]/(2*fs);  
[b1,a1] = butter(10,0.5,'low');  %Butterworth filter order 10
Y1 = filtfilt(b1,a1,quants1);      %filter1 implementation

% ---------------------------FOR CHANNEL 2--------------------------------
% ch1 = s.addAnalogInputChannel('myDAQ1', 'ai1', 'Voltage');

%PUTTING AN ANTI-ALIASING FILTER - BUTTERWORTH FILTER 

[b2,a2] = butter(10,0.50,'low');  %Butterworth filter order 10 put 's' to change to analog filter
Y2 = filtfilt(b2,a2,quants2);      %filter2 implementation

% SETTING DEVICE AND CHANNEL PROPERTIES
%  s.Rate = 20e3; 
%  s.Channels.Range = [-2 2];
%  s.DurationInSeconds = 0.5;

 
%----------------- Rescaling the quantised signal -------------------------

g1 = 2; % the signal is a sine wave with an amptide of 0.25 V with an offset of 0.5V
g_delta = 18; 
Y2_new = Y2./(g_delta.*g1);
Y1_new = Y1./g1;

%----------------Certainity function multiplication------------------------

Range_density1 = 1./(sqrt(1-(Y1_new.*Y1_new)));
Range_density2 = 1./(sqrt(1-(Y2_new.*Y2_new)));

Y_quantised = (Range_density1.*Y1_new) + (Range_density2.*Y2_new);

% SNR_HDR_signal = snr(Y_quantised, fs, 6); %snr using MATLAB 2014a only
% disp(SNR_HDR_signal);
% SNT_non_HDR_signal = snr(Y1_new, fs, 6); %snr of the LDR (non-quantized) signal

% -------------------Plotting input signal--------------------------------
figure (1);

subplot (4,1,1);
plot (t,ch0);
axis ([0 0.0125 -1 1]);
grid on;
xlabel('Time(s)--->');
ylabel ('Amplitude--->');
title ('Input Signal 1');

subplot (4,1,2);
plot (t,ch1);
axis ([0 0.0125 -2.5 2.5]);
grid on;
xlabel('Time(s)--->');
ylabel ('Amplitude--->');
title ('Input Signal 2');

subplot (4,1,3);
plot (t,Y1);
axis ([0 0.0125 -1.1 1.1]);
grid on;
xlabel('Time(s)--->');
ylabel ('Amplitude--->');
title ('Filtered signal 1');

subplot (4,1,4);
plot (t,Y2);
axis ([0 0.0125 -2.5 2.5]);
grid on;
xlabel('Time(s)--->');
ylabel ('Amplitude--->');
title ('Filtered signal 2');
% ----------------------------
figure(2);
subplot (2,1,1);
plot(t,ch0,'x',t,quants1,'.')
axis ([0 0.005 -2 2]);
grid on;
legend('Original signal 1','Quantized signal 1');

subplot (2,1,2);
plot(t,ch1,'x',t,quants2,'.')
axis ([0 0.005 -2 2]);
grid on;
legend('Original signal 2','Quantized signal 2');

%---------------------------

figure (3);

subplot (4,1,1);
plot (Range_density1,Y1);
axis ([0.9995 1.0100 -2 2]);
grid on;
xlabel('Range Density Function--->');
ylabel ('Sample values--->');
title ('Range Density Function 1');

subplot (4,1,2);
plot ( Range_density2, Y2);
axis ([0.999995 1.000100 -3.85 3.85]);
grid on;
xlabel('Range Density Function--->');
ylabel ('Sample Values--->');
title ('Range Density function 2');

subplot (4,1,3);
plot (t,Range_density1);
axis ([0 0.025 0.9995 1.0100]);
grid on;
xlabel('Time(s)--->');
ylabel ('Amplitude--->');
title ('Certainity function 1');

subplot (4,1,4);
plot (t,Range_density2);
axis ([0 0.025 0.9995 1.0100]);
grid on;
xlabel('Time(s)--->');
ylabel ('Amplitude--->');
title ('Certainity function 2');

% -------------------------------

figure(4);
plot (t,Y_quantised);
axis ([0 0.025 -0.250 0.250]);
grid on;
xlabel('Time(s)--->');
ylabel ('Amplitude--->');
title ('Quantised Signal to be transmitted');







