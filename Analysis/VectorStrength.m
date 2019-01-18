function [r, st, THA, z, pv] = VectorStrength(tc, c)

theta = 2*pi*mod(tc, c)/c;

st = round(100*std(theta)*180/pi/360)/100;

n = length(tc);

X = (sum(cos(theta))/n);
Y = (sum(sin(theta))/n);

r = sqrt((X.^2) + (Y.^2));

THA = atan2(Y, X)*180/pi;

R = n*r;
z = (R.^2)/n;

% pv = exp(-z);
% 
% if n < 50
%     pv = pv*(1 + (2*z - z.^2)/(4*n) - (24*z - 132*(z.^2) + 76*(z.^3) - 9*(z.^4))/(288*(n.^2)));
% end

pv = exp(sqrt(1+4*n+4*(n.^2-R.^2)) - (1+2*n));

pv = ceil(pv*1000)/1000;
