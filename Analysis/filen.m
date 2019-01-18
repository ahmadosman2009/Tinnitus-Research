function fn = filen(pth, fst)

fin = dir(fullfile(pth, fst));

fn = {fin.name}';