function modulationDepth_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1
        hndl.setting.Pre.modulation.depth = str2double(get(obj, 'String'));
        hndl.setting.Post.modulation.depth = hndl.setting.Pre.modulation.depth;
        set(hndl.uicontrol.Post.modulation.modulationDepth_ED, 'String', hndl.setting.Post.modulation.depth);
    case 2
        hndl.setting.LDur.modulation.depth = str2double(get(obj, 'String'));
    case 3
        hndl.setting.Post.modulation.depth = str2double(get(obj, 'String'));
end

set(hndl.mainFig, 'Userdata', hndl);