function carrierType_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1
        hndl.setting.Pre.carrier.carrierType_P = get(obj, 'Value');
        
        switch hndl.setting.Pre.carrier.carrierType_P
            case 1
                set(hndl.uicontrol.Pre.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.Pre.carrier.bandWidth_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.Pre.carrier.centerFrequency_TX, 'Visible', 'on');
                set(hndl.uicontrol.Pre.carrier.centerFrequency_PU, 'Visible', 'on');
                
            case 2
                set(hndl.uicontrol.Pre.carrier.centerFrequency_TX, 'Visible', 'on');
                set(hndl.uicontrol.Pre.carrier.centerFrequency_PU, 'Visible', 'on');
                
                set(hndl.uicontrol.Pre.carrier.bandWidth_TX, 'Visible', 'on');
                set(hndl.uicontrol.Pre.carrier.bandWidth_PU, 'Visible', 'on');
            case 3
                set(hndl.uicontrol.Pre.carrier.centerFrequency_TX, 'Visible', 'off');
                set(hndl.uicontrol.Pre.carrier.centerFrequency_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.Pre.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.Pre.carrier.bandWidth_PU, 'Visible', 'off');
           case 4
                set(hndl.uicontrol.Pre.carrier.centerFrequency_TX, 'Visible', 'off');
                set(hndl.uicontrol.Pre.carrier.centerFrequency_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.Pre.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.Pre.carrier.bandWidth_PU, 'Visible', 'off'); 
        end
        
        hndl.setting.Post.carrier.carrierType_P = hndl.setting.Pre.carrier.carrierType_P;
        set(hndl.uicontrol.Post.carrier.carrierType_PU, 'Value', hndl.setting.Post.carrier.carrierType_P);
        
        switch hndl.setting.Post.carrier.carrierType_P
            case 1
                set(hndl.uicontrol.Post.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.Post.carrier.bandWidth_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.Post.carrier.centerFrequency_TX, 'Visible', 'on');
                set(hndl.uicontrol.Post.carrier.centerFrequency_PU, 'Visible', 'on');
                
            case 2
                set(hndl.uicontrol.Post.carrier.centerFrequency_TX, 'Visible', 'on');
                set(hndl.uicontrol.Post.carrier.centerFrequency_PU, 'Visible', 'on');
                
                set(hndl.uicontrol.Post.carrier.bandWidth_TX, 'Visible', 'on');
                set(hndl.uicontrol.Post.carrier.bandWidth_PU, 'Visible', 'on');
            case 3
                set(hndl.uicontrol.Post.carrier.centerFrequency_TX, 'Visible', 'off');
                set(hndl.uicontrol.Post.carrier.centerFrequency_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.Post.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.Post.carrier.bandWidth_PU, 'Visible', 'off');
            case 4
                set(hndl.uicontrol.Post.carrier.centerFrequency_TX, 'Visible', 'off');
                set(hndl.uicontrol.Post.carrier.centerFrequency_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.Post.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.Post.carrier.bandWidth_PU, 'Visible', 'off');                         
        end
    case 2
        hndl.setting.LDur.carrier.carrierType_P = get(obj, 'Value');
        
        switch hndl.setting.LDur.carrier.carrierType_P
            case 1
                set(hndl.uicontrol.LDur.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.LDur.carrier.bandWidth_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.LDur.carrier.centerFrequency_TX, 'Visible', 'on');
                set(hndl.uicontrol.LDur.carrier.centerFrequency_PU, 'Visible', 'on');
                
            case 2
                set(hndl.uicontrol.LDur.carrier.centerFrequency_TX, 'Visible', 'on');
                set(hndl.uicontrol.LDur.carrier.centerFrequency_PU, 'Visible', 'on');
                
                set(hndl.uicontrol.LDur.carrier.bandWidth_TX, 'Visible', 'on');
                set(hndl.uicontrol.LDur.carrier.bandWidth_PU, 'Visible', 'on');
            case 3
                set(hndl.uicontrol.LDur.carrier.centerFrequency_TX, 'Visible', 'off');
                set(hndl.uicontrol.LDur.carrier.centerFrequency_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.LDur.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.LDur.carrier.bandWidth_PU, 'Visible', 'off');
            case 4
                set(hndl.uicontrol.LDur.carrier.centerFrequency_TX, 'Visible', 'off');
                set(hndl.uicontrol.LDur.carrier.centerFrequency_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.LDur.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.LDur.carrier.bandWidth_PU, 'Visible', 'off');              
        end
    case 3
        hndl.setting.Post.carrier.carrierType_P = get(obj, 'Value');
        
        switch hndl.setting.Post.carrier.carrierType_P
            case 1
                set(hndl.uicontrol.Post.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.Post.carrier.bandWidth_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.Post.carrier.centerFrequency_TX, 'Visible', 'on');
                set(hndl.uicontrol.Post.carrier.centerFrequency_PU, 'Visible', 'on');
                
            case 2
                set(hndl.uicontrol.Post.carrier.centerFrequency_TX, 'Visible', 'on');
                set(hndl.uicontrol.Post.carrier.centerFrequency_PU, 'Visible', 'on');
                
                set(hndl.uicontrol.Post.carrier.bandWidth_TX, 'Visible', 'on');
                set(hndl.uicontrol.Post.carrier.bandWidth_PU, 'Visible', 'on');
            case 3
                set(hndl.uicontrol.Post.carrier.centerFrequency_TX, 'Visible', 'off');
                set(hndl.uicontrol.Post.carrier.centerFrequency_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.Post.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.Post.carrier.bandWidth_PU, 'Visible', 'off');
            case 4
                set(hndl.uicontrol.Post.carrier.centerFrequency_TX, 'Visible', 'off');
                set(hndl.uicontrol.Post.carrier.centerFrequency_PU, 'Visible', 'off');
                
                set(hndl.uicontrol.Post.carrier.bandWidth_TX, 'Visible', 'off');
                set(hndl.uicontrol.Post.carrier.bandWidth_PU, 'Visible', 'off');           
        end
end

set(hndl.mainFig, 'Userdata', hndl);
