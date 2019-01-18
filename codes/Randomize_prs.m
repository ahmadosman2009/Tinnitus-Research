function Randomize_prs(obj, evt)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

hndl.setting.general.randomize = get(obj, 'Value');

set(hndl.mainFig, 'Userdata', hndl);