function clickLow_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1
%         hndl.setting.Pre.modulation.clickLow = round(str2double(get(obj, 'String')));
        hndl.setting.Pre.modulation.clickLow = str2double(get(obj, 'String'));
        set(obj, 'String', hndl.setting.Pre.modulation.clickLow);
        hndl.setting.Post.modulation.clickLow =  hndl.setting.Pre.modulation.clickLow;

        set(hndl.uicontrol.Post.modulation.clickLow_ED, 'String',hndl.setting.Post.modulation.clickLow);
        

        set(hndl.uicontrol.Pre.modulation.clickModulation, 'String', ...
        1000/(hndl.setting.Pre.modulation.clickHigh + ...
         hndl.setting.Pre.modulation.clickLow));
     
     set(hndl.uicontrol.Post.modulation.clickModulation, 'String', get(hndl.uicontrol.Pre.modulation.clickModulation,'string'));
     
%         hndl.uicontrol.Post.modulation.clickModulation = hndl.uicontrol.Pre.modulation.clickModulation;
    case 2
%         hndl.setting.LDur.modulation.clickLow = round(str2double(get(obj, 'String')));
        hndl.setting.LDur.modulation.clickLow = str2double(get(obj, 'String'));
        set(obj, 'String', hndl.setting.LDur.modulation.clickLow);

        
        set(hndl.uicontrol.LDur.modulation.clickModulation, 'String', ...
                1000/(hndl.setting.LDur.modulation.clickHigh + ...
                 hndl.setting.LDur.modulation.clickLow));
    case 3   
%         hndl.setting.Post.modulation.clickLow = round(str2double(get(obj, 'String')));
        hndl.setting.Post.modulation.clickLow = str2double(get(obj, 'String'));
        
        set(hndl.uicontrol.Post.modulation.clickModulation, 'String', ...
                1000/(hndl.setting.Post.modulation.clickHigh + ...
                 hndl.setting.Post.modulation.clickLow));
%         set(obj, 'String', hndl.setting.Post.modulation.clickLow);
%         set(hndl.uicontrol.Post.modulation.clickLow_ED, 'String',hndl.setting.Post.modulation.clickLow);
end

set(hndl.mainFig, 'Userdata', hndl);