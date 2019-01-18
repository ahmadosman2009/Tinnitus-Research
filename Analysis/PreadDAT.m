function sig = PreadDAT(fnm)

fid = fopen(fnm, 'r');
sig = fread(fid, 'float32');
fclose(fid);