function fileName_prs(obj, evt, v)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch v
    case 1
        hndl.outputFile.SID = get(obj, 'String');        
    case 2
        hndl.outputFile.STN = get(obj, 'String');
    case 3
        hndl.outputFile.Visit = str2double(get(obj, 'String'));
end

set(hndl.mainFig, 'Userdata', hndl);

getFilename;