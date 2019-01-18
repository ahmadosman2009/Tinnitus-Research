function show_setup_page

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

set(hndl.mainFig, 'Visible', 'on');
set(hndl.testFig, 'Visible', 'off');

set(hndl.uimenu.stageA2c_UM, 'Enable', 'on');