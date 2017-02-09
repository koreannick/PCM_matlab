function [out, seed] = random_seq(N,seed)

%this function generates a sequence of random binary digits.

% random_seq(N) generates N random binary digits.
%The output sequence is either "0" or "1" with equal probability.
%random_seq(N,seed) starts generating bit sequence using the value of seed.

if ( nargin == 2 )
    rand('seed',seed)
end

x = rand(1,N);
out = ones(size(x));
index = (x<0.5);

out(index) = zeros(length(x(index)),1);

if(nargout ==2)
    seed = rand('seed');
end