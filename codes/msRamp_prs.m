function msRamp_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1
        hndl.setting.Pre.duration.msRamp = str2double(get(obj, 'String'));
        set(obj, 'String', hndl.setting.Pre.duration.msRamp);
        if hndl.setting.Pre.duration.msRamp == 0
            hndl.setting.Pre.duration.msRamp = 0.01;
        end
        hndl.setting.Post.duration.msRamp = hndl.setting.Pre.duration.msRamp;
        set(hndl.uicontrol.Post.duration.msRamp_ED, 'String', hndl.setting.Post.duration.msRamp);
    case 2
        hndl.setting.LDur.duration.msRamp = str2double(get(obj, 'String'));
        set(obj, 'String', hndl.setting.LDur.duration.msRamp);
    case 3
        hndl.setting.Post.duration.msRamp = str2double(get(obj, 'String'));
        set(obj, 'String', hndl.setting.Post.duration.msRamp);
end

set(hndl.mainFig, 'Userdata', hndl);