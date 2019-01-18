function Pmf_ED_prs(obj, evt)

hndl = get(gcf, 'Userdata');

hndl.general.setting.mf = str2double(get(obj, 'String'));

set(hndl.postreviewFig, 'Userdata', hndl);