function PPoints_ED_prs(obj, evt, vva, vvb)

hndl = get(gcf, 'Userdata');

hndl.setting.criteria.NPoints(vva, vvb) = round(str2double(get(obj, 'string')));

set(hndl.postreviewFig, 'Userdata', hndl);