function FileNameParameter_prs(obj, evt)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

str = get(obj, 'String');
str = strrep(str, '.mat', '');

hndl.setting.general.parameterfileN = [str '.mat'];

set(hndl.mainFig, 'Userdata', hndl);