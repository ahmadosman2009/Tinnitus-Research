function [mfA, fn] = getSGNFileName(pth, fst)

fnm = fullfile(pth, [fst 'Data.rst']);
mfA = getTXT(fnm, 4);

fn = filen(pth, [fst '*.sgn']);