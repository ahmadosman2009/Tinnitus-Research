function clickMod_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1
        hndl.setting.Pre.modulation.clickMod = str2double(get(obj, 'String'));
        set(obj, 'String', hndl.setting.Pre.modulation.clickMod);
        hndl.setting.Post.modulation.clickMod =  hndl.setting.Pre.modulation.clickMod;

        set(hndl.uicontrol.Post.modulation.clickMod_ED, 'String',hndl.setting.Post.modulation.clickMod);
        
             set(hndl.uicontrol.Pre.modulation.clickLow_TX, 'String', ...
            1000/hndl.setting.Pre.modulation.clickMod - ...
         hndl.setting.Pre.modulation.clickHigh);
     
     hndl.setting.Pre.modulation.clickLow = 1000/hndl.setting.Pre.modulation.clickMod-hndl.setting.Pre.modulation.clickHigh;
     hndl.setting.Post.modulation.clickLow = 1000/hndl.setting.Pre.modulation.clickMod-hndl.setting.Pre.modulation.clickHigh;


     set(hndl.uicontrol.Post.modulation.clickLow_TX, 'String', get(hndl.uicontrol.Pre.modulation.clickLow_TX,'string'));
     
    case 2
        hndl.setting.LDur.modulation.clickMod = str2double(get(obj, 'String'));
        set(obj, 'String', hndl.setting.LDur.modulation.clickMod);

        
             set(hndl.uicontrol.LDur.modulation.clickLow_TX, 'String', ...
            1000/hndl.setting.LDur.modulation.clickMod - ...
         hndl.setting.LDur.modulation.clickHigh);
    case 3   
        hndl.setting.Post.modulation.clickMod = str2double(get(obj, 'String'));
             hndl.setting.Post.modulation.clickLow = 1000/hndl.setting.Pre.modulation.clickMod-hndl.setting.Pre.modulation.clickHigh;

             set(hndl.uicontrol.Post.modulation.clickLow_TX, 'String', ...
            1000/hndl.setting.Post.modulation.clickMod - ...
         hndl.setting.Post.modulation.clickHigh);

end

set(hndl.mainFig, 'Userdata', hndl);