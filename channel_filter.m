function [r, time] = channel_filter(x,gain,noise_power,f_cutoff,fs)  

% ************************************************************************
% A communications channel modeled with a bandlimited filter and Gaussian noise 
% 
% [r, time] = CHANNEL_FILTER(x,gain,noise_power,f_cutoff,fs)  
% [r] = CHANNEL_FILTER(x,gain,noise_power,f_cutoff,fs)  
% CHANNEL_FILTER(x,gain,noise_power,f_cutoff,fs)  
% 
% This function generates output sequence r from the input sequence x  
% using a channel filter and Gaussian noise is added. 
%     
% f_cutoff: this parameter defines the passband 
% If f_cutoff is a scalar, then channel filter is LPF  
% If f_cutoff is a 1 x 2 vector, then the channel is BPF  
% gain: |H(f)| in passband 
% fs: sampling frequency 
% 
% r: output sequence 
% time: time vector 
% When no output argument is specified, the function displays the frequency response H(f). 
% ************************************************************************
Ts = 1/fs; % Sampling period 
n_sample  = length(x);  % Number of samples in input sequence 
time = [0:(n_sample-1)]*Ts; % Time vector  

% ----------------------------------------------- 
%  Filter parameter 
%       .... Cehbyshev Type 1 digital filter is used 
% ----------------------------------------------- 

ripple = 0.1;      % Allowable ripple [dB] 
filt_order = 8;    % Filter order 
fpoints = 256;   % Number of samples to display the channel response  

%------------------------ 
% Cut-off frequencies 
%------------------------ 

if (length(f_cutoff) == 1) % Lowpass filter channel 
   Wc = f_cutoff;  % Cut-off frequency in Hz 
   Wn = [Wc]/(fs/2); % Normalize the frequency 
   if ( Wc >= fs/2 ), error(''); end 
elseif (length(f_cutoff) == 2)  % Bandpass filter channel 
   W1 = min(f_cutoff); W2 = max(f_cutoff); 
 Wn = [W1, W2]/(fs/2); 
   if ( W2 >= fs/2 ), error(''); end 
end  

%----------------------------- 
% Filter coefficients  
%----------------------------- 
[B,A] = cheby1(filt_order, ripple, Wn); 
delay = 0; % Time delay of the channel [sec].  
n_delay = fix(delay/Ts); 
B = [zeros(1,n_delay) B];  
B = sqrt(gain) * B;   
x = [x(:)' zeros(1,n_delay)];  

%--------------------------------------------------- 
% Filter the input signal and add Gaussian noise 
%--------------------------------------------------- 

if (nargout == 0) 
   frequency = fs/(2*fpoints) * (0:fpoints-1); % Frequency vector 
   H = freqz(B,A,fpoints); % Frequency response  
   amplitude = abs(H);  
   amplitude_dB = 20*log10(amplitude); 
   phase = angle(H);  
   phase1 = unwrap(phase); 
   phase_deg = phase1*180/pi; % Phase in degree  
   subplot(121), plot(frequency, amplitude_dB ); 
   title('Amplitude response of the channel'); 
   xlabel('Frequency [Hz]'); 
   ylabel('Amplitude [dB]'), grid on;  
   subplot(122), plot( frequency, phase_deg ); 
   title('Phase response of the channel'); 
   xlabel('Frequency [Hz]'); 
   ylabel('Phase [degree]'), grid on; 
else 
 y = filter(B, A, x); 
   noise  = randn(size(y)); 
   r = y + sqrt(noise_power)*noise; 
end 