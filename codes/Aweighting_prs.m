function Aweighting_prs(obj, evt)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');
chndl = get(hndl.calibrationFig, 'Userdata');

chndl.setting.general.Aweighting = get(obj, 'Value');

set(hndl.calibrationFig, 'Userdata', chndl);