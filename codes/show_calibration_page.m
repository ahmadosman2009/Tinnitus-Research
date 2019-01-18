function show_calibration_page

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

set(hndl.mainFig, 'Visible', 'off');

set(hndl.calibrationFig, 'Visible', 'on');