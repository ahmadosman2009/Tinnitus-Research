function SaveParameterBN_prs(obj, evt)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

tmpSetting = hndl.setting;

str = fullfile(hndl.filepath.parameterPath, hndl.setting.general.parameterfileN);

save(str, 'tmpSetting');