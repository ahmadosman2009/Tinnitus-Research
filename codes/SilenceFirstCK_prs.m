function SilenceFirstCK_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1        
        hndl.setting.Pre.duration.SilenceFirst = get(obj, 'Value');
    case 2        
        hndl.setting.LDur.duration.SilenceFirst = get(obj, 'Value');
    case 3        
        hndl.setting.Post.duration.SilenceFirst = get(obj, 'Value');        
end

set(hndl.mainFig, 'Userdata', hndl);