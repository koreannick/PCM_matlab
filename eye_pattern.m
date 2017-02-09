function eye_pattern(x, Rb, fs, T)  

%-----------------------------------------------------------------
% This function generates the eye diagram  
% 
% eye_pattern(x) displays the eye diagram of the input sequence x. 
% eye_pattern(x, T) displays the same eye diagram, but waits T seconds  
%                   between succesive plots. 
%                   If T is not given, T is set to zero. 
%-----------------------------------------------------------------

if (nargin == 3) 
   T = 0; 
end
Tb = 1/Rb;
ts = 1/fs;  
num_eye = 2; % Number of eye diagrams 
num_sample = Tb/ts; % Number of samples per bit period 
N = length(x); % Total number of samples 
num_block = fix(N/(num_eye*num_sample)); % Number of blocks of num_samples 
if(num_block > 150) num_block = 150; end  
index = [1:(num_eye*num_sample)]; % index for selecting input 
%% skip initial data 
index = index + (num_eye*num_sample); 
num_block = num_block - 1; 
%% 
t_time = ts * [0:num_eye*num_sample]; % Time for displaying the diagram 
time = ts * [1:num_eye*num_sample]; 
amplitude = max(abs(x)); 

% ----------------------------------------------------------------- 

delta = x(2) - x(1); 
x0 = x(1) - delta; % Estimate the first data of the input 
if(((x0 < 0) & (x(1)>0)) | ((x0>0) & (x(1)<0))) x0 = 0; end 
y = x(index); 
plot(t_time,[x0 y(:).'],'b');  grid on; 
xlabel('Time [sec]'); title('Eye Diagram'); 
hold on 
last = max(index);  
z = zeros((num_eye*num_sample), num_block-1); 
z(:) = x( (num_eye*num_sample)+1 : num_block*num_eye*num_sample ); 
front = z(num_eye*num_sample,:); 
front = [x(last) front(1:num_block-2)]; 
z = [front;  z];  
if (nargin == 3) 
    plot(t_time, z,'b'); 
else 
for k = 1:(num_block-1) 
       pause(T); 
       plot(t_time, z(:,k),'b'); 
   end 
end  

%axis([0 max(t_time) -1.25*amplitude 1.25*amplitude]), ... 
axis([0 max(t_time) -2  2]), ... 
%axis([0 max(t_time) -2.5  2.5]), ... 
hold off