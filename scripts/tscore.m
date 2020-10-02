function [meanval, CI] = tscore(x, alpha) 
if (nargin==1)
alpha = 0.95;
end
meanval = mean(x);
SEM = std(x)/sqrt(length(x));               % Standard Error
ts = tinv([(1-alpha)*0.5  0.5+alpha*0.5],length(x)-1);      % T-Score
CI = meanval + ts*SEM;                      % Confidence Intervals