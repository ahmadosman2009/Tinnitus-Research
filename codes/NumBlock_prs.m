function NumBlock_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1
        hndl.setting.Pre.duration.NumBlock = round(str2double(get(obj, 'String')));
        set(obj, 'String', hndl.setting.Pre.duration.NumBlock);
        
        set(hndl.uicontrol.Pre.duration.SecBlock_ED, 'String', ...
            hndl.setting.Pre.duration.NumBlock *(hndl.setting.Pre.duration.sPerSignal + hndl.setting.Pre.duration.sPerSilence));
        
    case 2
        hndl.setting.LDur.duration.NumBlock = round(str2double(get(obj, 'String')));
        set(obj, 'String', hndl.setting.LDur.duration.NumBlock);
        
        set(hndl.uicontrol.LDur.duration.SecBlock_ED, 'String', ...
            hndl.setting.LDur.duration.NumBlock *(hndl.setting.LDur.duration.sPerSignal + hndl.setting.LDur.duration.sPerSilence));
        
    case 3
        hndl.setting.Post.duration.NumBlock = round(str2double(get(obj, 'String')));
        set(obj, 'String', hndl.setting.Post.duration.NumBlock);
        
        set(hndl.uicontrol.Post.duration.SecBlock_ED, 'String', ...
            hndl.setting.Post.duration.NumBlock *(hndl.setting.Post.duration.sPerSignal + hndl.setting.Post.duration.sPerSilence));
end

set(hndl.mainFig, 'Userdata', hndl);

getFilename