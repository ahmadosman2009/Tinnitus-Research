function GapDurationED_prs(obj, evt)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

hndl.setting.general.gapDuration = str2double(get(obj, 'String'));

set(hndl.mainFig, 'Userdata', hndl);