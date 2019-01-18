function PCOHA_ED_prs(obj, evt)

hndl = get(gcf, 'Userdata');

hndl.setting.criteria.coha = str2double(get(obj, 'String'));

set(hndl.postreviewFig, 'Userdata', hndl);