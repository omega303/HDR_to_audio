% HDR to AUDIO Signals RESCALING AND RANGE DENSITY FUNCTION CODE


% ------------------------------------------------------------------------
% IDENTIFYING THE MYDAQ DEVICE
 daq.getDevices
% CREATING A NEW SESSION
s = daq.createSession('ni');
% ---------------------------FOR CHANNEL 1---------------------------------
% ADDING AN ANALOG VOLTAGE INPUT CHANNEL
ch0 = s.addAnalogInputChannel('myDAQ1', 'ai0', 'Voltage');
%PUTTING AN ANTI-ALIASING FILTER - BUTTERWORTH FILTER  

fs = 20e3;
fnorm = [0 fs/2]/(fs/2);  
[b1,a1] = butter(10,fnorm);  %Butterworth filter order 10
Y1 = filtfilt(b1,a1,ch0);      %filter1 implementation

% ---------------------------FOR CHANNEL 2--------------------------------
ch1 = s.addAnalogInputChannel('myDAQ1', 'ai1', 'Voltage');

%PUTTING AN ANTI-ALIASING FILTER - BUTTERWORTH FILTER 

[b2,a2] = butter(10,fnorm);  %Butterworth filter order 10
Y2 = filtfilt(b2,a2,ch1);      %filter2 implementation

% SETTING DEVICE AND CHANNEL PROPERTIES
 s.Rate = 20e3; 
 s.Channels.Range = [-2 2];
 s.DurationInSeconds = 0.5;

 
%----------------- Rescaling the quantised signal -------------------------

g1 = 2; % the signal is a sine wave with an amptide of 0.25 V with an offset of 0.5V
% g_delta to be found out 
Y2 = Y2./(g_delta*g1);
Y1 = Y1./g1;

%----------------Certainity function multiplication------------------------


