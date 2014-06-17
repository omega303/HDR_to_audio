% Prasoon_Mehta
% HDR to AUDIO Signals RESCALING AND RANGE DENSITY FUNCTION CODE


% ------------------------------------------------------------------------
% IDENTIFYING THE MYDAQ DEVICE
 daq.getDevices
% CREATING A NEW SESSION
s = daq.createSession('ni');
% ADDING AN ANALOG VOLTAGE INPUT CHANNEL
ch = s.addAnalogInputChannel('myDAQ1', 'ai0', 'Voltage');
%PUTTING AN ANTI-ALIASING FILTER - BUTTERWORTH FILTER WITH 
fs = 200e3;
fnorm1 = [0 fs/2]/(fs/2);  
[b1,a1] = butter(10,fnorm);  %Butterworth filter order 10
Y = filtfilt(b1,a1,ch);      %filter implementation


% SETTING DEVICE AND CHANNEL PROPERTIES
 s.Rate = 200e3; %SAMPLING FREQUENCY
 s.Channels.Range = [0 2];%VOLTAGE RANGE OF THE ANALOG INPUT (THE SINUSODIAL SIGNAL)
 s.DurationInSeconds = 0.5;%DURATION OF SAMPLING


