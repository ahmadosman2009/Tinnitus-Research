function show_testing_page

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

set(hndl.mainFig, 'Visible', 'off');
set(hndl.testFig, 'Visible', 'on');