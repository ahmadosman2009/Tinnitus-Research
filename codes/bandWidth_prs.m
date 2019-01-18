function bandWidth_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1        
        hndl.setting.Pre.carrier.bandWidth_P = get(obj, 'Value');
        hndl.setting.Post.carrier.bandWidth_P = hndl.setting.Pre.carrier.bandWidth_P;
        set(hndl.uicontrol.Post.carrier.bandWidth_PU, 'Value', hndl.setting.Post.carrier.bandWidth_P);
    case 2        
        hndl.setting.LDur.carrier.bandWidth_P = get(obj, 'Value');
    case 3        
        hndl.setting.Post.carrier.bandWidth_P = get(obj, 'Value');
end

set(hndl.mainFig, 'Userdata', hndl);