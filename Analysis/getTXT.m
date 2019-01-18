function VN = getTXT(fnm, N)
if nargin < 2
    N = 4;
end

str = '%*[^\n]';
for mmm = 1:N
    str = strcat('%s ', str);
end


fid = fopen(fnm);
T = textscan(fid, str);
fclose(fid);

COLN = T{N};

VN = zeros(length(COLN)-1, 1);

for mmm = 1:length(COLN)-1
    VN(mmm) = str2double(COLN{mmm + 1});
end