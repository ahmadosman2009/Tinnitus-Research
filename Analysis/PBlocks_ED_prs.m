function PBlocks_ED_prs(obj, evt)

hndl = get(gcf, 'Userdata');

hndl.setting.criteria.NBlocks = round(str2double(get(obj, 'String')));

set(hndl.postreviewFig, 'Userdata', hndl);
