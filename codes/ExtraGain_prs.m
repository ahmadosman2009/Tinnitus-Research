function ExtraGain_prs(obj, evt)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');
chndl = get(hndl.calibrationFig, 'Userdata');

chndl.setting.calibration.ExtraGain = str2double(get(obj, 'String'));

set(hndl.calibrationFig, 'Userdata', chndl);