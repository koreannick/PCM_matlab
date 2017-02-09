function [out_waveform, t, pulse] = linecode_gen(bit_sequence, code_name, data_rate, samp_freq)

%this function generates a wave form coded in binary signalling format

% input parameters
% bet_sequences : binary input sequence
% code_name : type of line code
%  'unipolar_nrz'     'unipolar_rz'     'polar_nrz'   'polar_rz'    
%  'bipolar_nrz'     'bipolar_rz'   'manchester'    'triangle' 
%  data_rate : binary data rate [bps] 
% samp_freq: sampling frequency, if not specified default value is 10 KHz 
% 
% Output 
% out_waveform: line code waveform 
% t: time vector to plot the waveform 
% pulse: basic pulse shape 

bit_sequence;
%-------------------------- 
%Set up parameters 
%-------------------------- 
SAMPLING_FREQ = 10000; % Default value 10 KHz 
bit_sequence=bit_sequence(:); % To make a column vector 
Rb = data_rate;  
if (nargin == 3), % Default sampling frequency 
    fs = SAMPLING_FREQ; % Default sampling frequency 
end 
if (nargin == 4), % User specified sampling frequency 
    fs = samp_freq; 
  end  
Ts = 1/fs;      % Sampling period 
Tb = 1/Rb;     % Binary data period  
no_binary = length(bit_sequence);   % Number of bits 
no_sample = no_binary * Tb/Ts;    % Number of samples  
%time = [0:(no_sample-1)] * Ts;      % Time vector  
time = [1:(no_sample)] * Ts;      % Time vector   
if  strcmp(code_name, 'unipolar_nrz') 
    basic_pulse = ones(1,fs/Rb); 
    b_seq = bit_sequence; 
elseif strcmp(code_name, 'unipolar_rz') 
    n_sample = fs/Rb; 
    n_middle = n_sample/2; 
    basic_pulse = ones(1,n_sample); 
    basic_pulse((n_middle + 1):(n_sample)) = zeros(1,(n_sample-n_middle)); 
 b_seq = bit_sequence; 
elseif strcmp(code_name, 'polar_nrz') 
    basic_pulse = ones(1,fs/Rb); 
    b_seq = 2*bit_sequence- ones(size(bit_sequence)); % Binary to polar conversion 
elseif strcmp(code_name, 'polar_rz') 
    n_sample = fs/Rb; 
    n_middle = n_sample/2; 
    basic_pulse = ones(1,n_sample); 
    basic_pulse((n_middle + 1):(n_sample)) = zeros(1,(n_sample-n_middle)); 
    b_seq = 2*bit_sequence- ones(size(bit_sequence)); % Binary to polar conversion 
elseif strcmp(code_name, 'bipolar_nrz') 
    basic_pulse = ones(1,fs/Rb); 
    no_binary = length(bit_sequence); 
    for k = 1:no_binary   % Binary to bipolar conversion 
        b_seq(k,1) =  bit_sequence(k) * (-1)^(sum(bit_sequence(1:k)) - 1); 
    end 
elseif strcmp(code_name, 'bipolar_rz') 
    n_sample = fs/Rb; 
    n_middle = n_sample/2; 
    basic_pulse = ones(1,n_sample); 
    basic_pulse((n_middle + 1):(n_sample)) = zeros(1,(n_sample-n_middle)); 
      no_binary = length(bit_sequence); 
    for k = 1:no_binary   % Binary to bipolar conversion 
        b_seq(k,1) =  bit_sequence(k) * (-1)^(sum(bit_sequence(1:k)) - 1); 
    end 
elseif strcmp(code_name, 'manchester') 
    n_sample = Tb/Ts; 
    n_middle = n_sample./2; 
    basic_pulse = ones(1,n_sample); 
    basic_pulse((n_middle + 1):(n_sample)) = -ones(1,(n_sample-n_middle)); 
    b_seq = 2*bit_sequence- ones(size(bit_sequence)); % Binary to polar conversion 
elseif strcmp(code_name, 'triangle') 
    n_sample = Tb/Ts; 
    n_middle = n_sample/2; 
    step = 1/n_middle; 
    basic_pulse(1:n_middle) = [step:step:1]; 
    basic_pulse((n_middle + 1):(n_sample)) = [1-step: -step: 0]; 
    b_seq = bit_sequence; 
else 
    error('Unknown linecode type') 
end

%---------------------------------------
% Generate output signal waveform 
%--------------------------------------- 
x  = (b_seq * basic_pulse)'; 
time = time(:); 
out_waveform = x(:); 

if (nargout == 2), t = time;
end

if (nargout == 3), t = time; pulse=basic_pulse;
end 