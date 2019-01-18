function modulationType_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1
        hndl.setting.Pre.modulation.type_P = get(obj, 'Value');
        hndl.setting.Post.modulation.type_P = hndl.setting.Pre.modulation.type_P;
        set(hndl.uicontrol.Post.modulation.modulationType_PU, 'Value', hndl.setting.Post.modulation.type_P);
        
        if hndl.setting.Pre.modulation.type_P == 8
        set(hndl.uicontrol.Pre.modulation.clickMod_TX, 'Visible', 'on');
        set(hndl.uicontrol.Pre.modulation.clickMod_ED, 'Visible', 'on');
        set(hndl.uicontrol.Pre.modulation.clickHigh_TX, 'Visible', 'on');
        set(hndl.uicontrol.Pre.modulation.clickHigh_ED, 'Visible', 'on');
        set(hndl.uicontrol.Pre.modulation.clickLow_TX, 'Visible', 'off');
%         set(hndl.uicontrol.Pre.modulation.clickLow, 'Visible', 'on');
        
        set(hndl.uicontrol.Post.modulation.clickMod_TX, 'Visible', 'on');
        set(hndl.uicontrol.Post.modulation.clickMod_ED, 'Visible', 'on');
        set(hndl.uicontrol.Post.modulation.clickHigh_TX, 'Visible', 'on');
        set(hndl.uicontrol.Post.modulation.clickHigh_ED, 'Visible', 'on');
        set(hndl.uicontrol.Post.modulation.clickLow_TX, 'Visible', 'off');
%         set(hndl.uicontrol.Post.modulation.clickLow, 'Visible', 'on');
        
        
        set(hndl.uicontrol.Pre.modulation.modulationFrequencyStart_TX, 'Enable', 'off'); 
        set(hndl.uicontrol.Pre.modulation.modulationFrequencyStart_ED,'Enable', 'off');
        set(hndl.uicontrol.Pre.modulation.modulationDepth_TX,'Enable', 'off');
        set(hndl.uicontrol.Pre.modulation.modulationDepth_ED,'Enable', 'off');
        
%         set(hndl.uicontrol.Post.modulation.clickLow_TX, 'Enable', 'off'); 
%         set(hndl.uicontrol.Post.modulation.clickLow_ED,'Enable', 'off');
%         set(hndl.uicontrol.Post.modulation.clickModulation_TX,'Enable', 'off');
%         set(hndl.uicontrol.Post.modulation.clickModulation,'Enable', 'off');


        else 
        set(hndl.uicontrol.Pre.modulation.clickMod_TX, 'Visible', 'off');
        set(hndl.uicontrol.Pre.modulation.clickMod_ED, 'Visible', 'off');
        set(hndl.uicontrol.Pre.modulation.clickHigh_TX, 'Visible', 'off');
        set(hndl.uicontrol.Pre.modulation.clickHigh_ED, 'Visible', 'off');
        set(hndl.uicontrol.Pre.modulation.clickLow_TX, 'Visible', 'off');
%         set(hndl.uicontrol.Pre.modulation.clickLow, 'Visible', 'off');
        
        set(hndl.uicontrol.Post.modulation.clickMod_TX, 'Visible', 'off');
        set(hndl.uicontrol.Post.modulation.clickMod_ED, 'Visible', 'off');
        set(hndl.uicontrol.Post.modulation.clickHigh_TX, 'Visible', 'off');
        set(hndl.uicontrol.Post.modulation.clickHigh_ED, 'Visible', 'off');
        set(hndl.uicontrol.Post.modulation.clickLow_TX, 'Visible', 'off');
%         set(hndl.uicontrol.Post.modulation.clickLow, 'Visible', 'off');

        set(hndl.uicontrol.Pre.modulation.modulationFrequencyStart_TX, 'Enable', 'on'); 
        set(hndl.uicontrol.Pre.modulation.modulationFrequencyStart_ED,'Enable', 'on');
        set(hndl.uicontrol.Pre.modulation.modulationDepth_TX,'Enable', 'on');
        set(hndl.uicontrol.Pre.modulation.modulationDepth_ED,'Enable', 'on');

        end
        
        

    case 2
        hndl.setting.LDur.modulation.type_P = get(obj, 'Value');
        
         if hndl.setting.LDur.modulation.type_P == 8
        set(hndl.uicontrol.LDur.modulation.clickMod_TX, 'Visible', 'on');
        set(hndl.uicontrol.LDur.modulation.clickMod_ED, 'Visible', 'on');
        set(hndl.uicontrol.LDur.modulation.clickHigh_TX, 'Visible', 'on');
        set(hndl.uicontrol.LDur.modulation.clickHigh_ED, 'Visible', 'on');
        set(hndl.uicontrol.LDur.modulation.clickLow_TX, 'Visible', 'off');
%         set(hndl.uicontrol.LDur.modulation.clickLow, 'Visible', 'on');
        
        set(hndl.uicontrol.LDur.modulation.modulationFrequencyStart_TX, 'Enable', 'off'); 
        set(hndl.uicontrol.LDur.modulation.modulationFrequencyStart_ED,'Enable', 'off');
        set(hndl.uicontrol.LDur.modulation.modulationDepth_TX,'Enable', 'off');
        set(hndl.uicontrol.LDur.modulation.modulationDepth_ED,'Enable', 'off');
       
        else 
        set(hndl.uicontrol.LDur.modulation.clickMod_TX, 'Visible', 'off');
        set(hndl.uicontrol.LDur.modulation.clickMod_ED, 'Visible', 'off');
        set(hndl.uicontrol.LDur.modulation.clickHigh_TX, 'Visible', 'off');
        set(hndl.uicontrol.LDur.modulation.clickHigh_ED, 'Visible', 'off');
        set(hndl.uicontrol.LDur.modulation.clickLow_TX, 'Visible', 'off');
%         set(hndl.uicontrol.LDur.modulation.clickLow, 'Visible', 'off');
       
        set(hndl.uicontrol.LDur.modulation.modulationFrequencyStart_TX, 'Enable', 'on'); 
        set(hndl.uicontrol.LDur.modulation.modulationFrequencyStart_ED,'Enable', 'on');
        set(hndl.uicontrol.LDur.modulation.modulationDepth_TX,'Enable', 'on');
        set(hndl.uicontrol.LDur.modulation.modulationDepth_ED,'Enable', 'on');

        end
    case 3
        hndl.setting.Post.modulation.type_P = get(obj, 'Value');
end

set(hndl.mainFig, 'Userdata', hndl);

