function clickHigh_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1
        hndl.setting.Pre.modulation.clickHigh = str2double(get(obj, 'String'));

        set(obj, 'String', hndl.setting.Pre.modulation.clickHigh);
        hndl.setting.Post.modulation.clickHigh =  hndl.setting.Pre.modulation.clickHigh;
        
        set(hndl.uicontrol.Post.modulation.clickHigh_ED, 'String',hndl.setting.Post.modulation.clickHigh);
     
        set(hndl.uicontrol.Pre.modulation.clickLow_TX, 'String', ...
            1000/hndl.setting.Pre.modulation.clickMod - ...
         hndl.setting.Pre.modulation.clickHigh);
    
%         hndl.uicontrol.Post.modulation.clickLow_TX = hndl.uicontrol.Pre.modulation.clickLow_TX; 

     hndl.setting.Pre.modulation.clickLow = 1000/hndl.setting.Pre.modulation.clickMod-hndl.setting.Pre.modulation.clickHigh;
     hndl.setting.Post.modulation.clickLow = 1000/hndl.setting.Pre.modulation.clickMod-hndl.setting.Pre.modulation.clickHigh;
     
        if  hndl.setting.Post.modulation.clickLow < 0
        warndlg('Change Click Modulation or Click High.', 'Error');
        return;
        end

%         set(hndl.uicontrol.Post.modulation.clickLow, 'String', get(hndl.uicontrol.Pre.modulation.clickLow,'string'));
        set(hndl.uicontrol.Post.modulation.clickLow_TX, 'String', hndl.setting.Post.modulation.clickLow);
%             set(hndl.uicontrol.Post.modulation.clickLow, 'String', ...
%             1000/hndl.setting.Pre.modulation.clickMod - ...
%          hndl.setting.Pre.modulation.clickHigh);
%         set(hndl.uicontrol.Post.modulation.clickLow_TX, 'String', get(hndl.uicontrol.Pre.modulation.clickLow,'string'));

%         set(hndl.uicontrol.Post.duration.msRamp_ED, 'String', hndl.setting.Post.duration.msRamp);
    case 2
%         hndl.setting.LDur.modulation.clickHigh = round(str2double(get(obj, 'String')));
        hndl.setting.LDur.modulation.clickHigh = str2double(get(obj, 'String'));
        set(obj, 'String', hndl.setting.LDur.modulation.clickHigh);


%         set(hndl.uicontrol.LDur.modulation.clickModulation, 'String', ...
%         1000/(hndl.setting.LDur.modulation.clickHigh + ...
%          hndl.setting.LDur.modulation.clickLow));
        set(hndl.uicontrol.LDur.modulation.clickLow_TX, 'String', ...
            1000/hndl.setting.LDur.modulation.clickMod - ...
         hndl.setting.LDur.modulation.clickHigh);
    case 3

%         hndl.setting.Post.modulation.clickHigh = round(str2double(get(obj, 'String')));
        hndl.setting.Post.modulation.clickHigh = str2double(get(obj, 'String'));
 
%         set(hndl.uicontrol.Post.modulation.clickModulation, 'String', ...
%                 1000/(hndl.setting.Post.modulation.clickHigh + ...
%                  hndl.setting.Post.modulation.clickLow));    
        set(hndl.uicontrol.Post.modulation.clickLow_TX, 'String', ...
            1000/hndl.setting.Post.modulation.clickMod - ...
         hndl.setting.Post.modulation.clickHigh);
     
%         set(hndl.uicontrol.Post.modulation.clickLow_TX, 'String', '200');
             hndl.setting.Post.modulation.clickLow = 1000/hndl.setting.Pre.modulation.clickMod-hndl.setting.Pre.modulation.clickHigh;


end

set(hndl.mainFig, 'Userdata', hndl);