function getFilename

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');
thndl = get(hndl.testFig, 'Userdata');

mStr = sprintf('+PRE%dsLDUR%dsPOST%ds+', round(hndl.setting.Pre.duration.NumBlock), ...
    round(hndl.setting.LDur.duration.NumBlock), round(hndl.setting.Post.duration.NumBlock));

% mStr = sprintf('+PRE%s_LDUR%s_POST%s+', string(hndl.str.modulation_type(hndl.setting.Pre.modulation.type_P)), ...
%     string(hndl.str.modulation_type(hndl.setting.LDur.modulation.type_P)), string(hndl.str.modulation_type(hndl.setting.Post.modulation.type_P)));


hndl.outputFile.name = sprintf('%s%s%s%03d', ...
    hndl.outputFile.SID, mStr, hndl.outputFile.STN, hndl.outputFile.Visit);

set(hndl.uicontrol.control.fileName_ED, 'String', hndl.outputFile.name);

set(thndl.uipanel.Results_PN, 'title', hndl.outputFile.name);

set(hndl.mainFig, 'Userdata', hndl);