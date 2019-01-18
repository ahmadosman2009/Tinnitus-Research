function rms = get_RMS(sig, mn)
if nargin < 2
    mn = 1;
end

if mn == 1  %substract mean first
    rms = std(sig, 1);
else
    rms = sqrt(sum(sig.^2)/length(sig));
end