function waveform(in, fs, time_range)  

% This function plots the digital pulse waveforms  
% fs is sampling frequency [Hz] 
% time_range is time interval to draw signal waveform(optional) 

signal = in(:);  
ts = 1/fs; 
in = in(:); 
no_samples = length(signal);   % Number of input samples 
time = [1:(no_samples)]*ts;    % Default sampling instances  
amplitude = max(abs(signal));    % Maximum input value 
if(amplitude == 0) amplitude = 1; end  
range = [min(time) max(time) -1.2*amplitude 1.2*amplitude];  
if (nargin == 3), % When time_range is given 
  range = [min(time_range) max(time_range) -1.2*amplitude 1.2*amplitude]; 
end  
rect_plot(time,signal); 
xlabel('Time [sec]'); 
ylabel('Signal waveform'); 
grid on,   
axis(range);