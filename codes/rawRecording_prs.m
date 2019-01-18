function rawRecording_prs(obj, evt)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

hndl.setting.general.rawRecording = get(obj, 'Value');

set(hndl.mainFig, 'Userdata', hndl);