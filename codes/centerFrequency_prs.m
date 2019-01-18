function centerFrequency_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1
        hndl.setting.Pre.carrier.centerFrequency_P = str2double(get(obj, 'String'));
        hndl.setting.Post.carrier.centerFrequency_P = hndl.setting.Pre.carrier.centerFrequency_P;
        set(hndl.uicontrol.Post.carrier.centerFrequency_PU, 'String', hndl.setting.Post.carrier.centerFrequency_P);
    case 2
        hndl.setting.LDur.carrier.centerFrequency_P = str2double(get(obj, 'String'));
    case 3
        hndl.setting.Post.carrier.centerFrequency_P = str2double(get(obj, 'String'));
end

set(hndl.mainFig, 'Userdata', hndl);
