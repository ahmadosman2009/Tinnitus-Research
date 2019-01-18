function PZSD_prs(obj, evt)

hndl = get(gcf, 'Userdata');

hndl.setting.criteria.Zsd = str2double(get(obj, 'String'));

set(hndl.postreviewFig, 'Userdata', hndl);