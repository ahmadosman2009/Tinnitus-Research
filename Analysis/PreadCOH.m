function tmpa = PreadCOH(fnm)

if nargin < 1
    tmpa = 0;
    return
end

fid = fopen(fnm, 'r');
tmp = fscanf(fid, '%f');
fclose(fid);

tmpa = reshape(tmp, [2, length(tmp)/2])';
