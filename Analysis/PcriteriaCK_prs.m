function PcriteriaCK_prs(obj, evt, vv)

hndl = get(gcf, 'Userdata');

hndl.setting.criteria.selection(vv) = get(obj, 'Value');

set(hndl.postreviewFig, 'Userdata', hndl);