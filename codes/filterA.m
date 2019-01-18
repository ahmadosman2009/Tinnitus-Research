function A = filterA(f, plotFilter)
if nargin < 2
    plotFilter = 0;
end

% FILTERA Generates an A-weighting filter.
%    FILTERA Uses a closed-form expression to generate
%    an A-weighting filter for arbitary frequencies in Hz.
%
% Author: Douglas R. Lanman, 11/21/05

% Define filter coefficients.
% See: http://www.beis.de/Elektronik/AudioMeasure/
% WeightingFilters.html#A-Weighting
c1 = 3.5041384e16;
c2 = 20.598997^2;
c3 = 107.65265^2;
c4 = 737.86223^2;
c5 = 12194.217^2;

% Evaluate A-weighting filter.
f((f == 0)) = 1e-17;
fsq = f.^2; 
num = c1*fsq.^4;
den = ((c2+fsq).^2) .* (c3+fsq) .* (c4+fsq) .* ((c5+fsq).^2);
A = num./den;


if plotFilter
    % Plot using dB scale.
    figure(plotFilter); clf;
    semilogx(f,10*log10(A));
    title('A-weighting Filter');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    xlim([10 max(f)]); grid on;
    ylim([-70 10]);
end