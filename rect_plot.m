function rect_plot(time,signal)  

% This function draws a stair-like graph of the digital pulse waveform.  

n = length(time); 
delta = (max(time) - min(time)) / (n-1); 
nn = 2*n; 
yy = zeros(nn+2,1); 
xx = yy;
t = time(:)' - delta; 
xx(1:2:nn) = t; 
xx(2:2:nn) = t; 
xx(nn+1:nn+2) = t(n) + [delta;delta]; 
yy(2:2:nn) = signal; 
yy(3:2:nn+1) = signal; 
plot(xx,yy)