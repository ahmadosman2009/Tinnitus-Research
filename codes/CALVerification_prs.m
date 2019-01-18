function CALVerification_prs(obj, evt)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');
chndl = get(hndl.calibrationFig, 'Userdata');

chndl.setting.general.CALVerification = get(obj, 'Value');

if chndl.setting.general.CALVerification > 1
    set(chndl.uicontrol.general.CALCalibration_BN, 'Enable', 'off');
    
    if chndl.setting.general.CALVerification == 2

        set(chndl.uicontrol.general.CALinvFFT_CK, 'Enable', 'on');

        if ((chndl.setting.general.CALinvFFT == 1))
            set(chndl.uicontrol.tone.start_BN, 'Enable', 'off');
            set(chndl.uicontrol.noise.start_BN, 'Enable', 'off');
        else
            set(chndl.uicontrol.tone.start_BN, 'Enable', 'on');
            set(chndl.uicontrol.noise.start_BN, 'Enable', 'on');
        end

        set(chndl.uicontrol.sweep.start_BN, 'Enable', 'on');

        set(chndl.uicontrol.general.Scale_ED, 'Enable', 'on');
        set(chndl.uicontrol.general.SPLdB_ED, 'Enable', 'off');
    else        
        set(chndl.uicontrol.general.CALinvFFT_CK, 'Enable', 'off');

        set(chndl.uicontrol.sweep.start_BN, 'Enable', 'off');

        set(chndl.uicontrol.general.Scale_ED, 'Enable', 'off');
        set(chndl.uicontrol.general.SPLdB_ED, 'Enable', 'on');

        set(chndl.uicontrol.tone.start_BN, 'Enable', 'on');
        set(chndl.uicontrol.noise.start_BN, 'Enable', 'on');
    end        
else
    set(chndl.uicontrol.general.CALCalibration_BN, 'Enable', 'on');
    
    set(chndl.uicontrol.tone.start_BN, 'Enable', 'off');
    set(chndl.uicontrol.sweep.start_BN, 'Enable', 'off');
    set(chndl.uicontrol.noise.start_BN, 'Enable', 'off');
    
    set(chndl.uicontrol.general.CALinvFFT_CK, 'Enable', 'off');
end

set(hndl.calibrationFig, 'Userdata', chndl);