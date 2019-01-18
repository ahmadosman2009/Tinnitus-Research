function CALinvFFT_prs(obj, evt)

hndl = get(gcf, 'Userdata');
chndl = get(hndl.calibrationFig, 'Userdata');

chndl.setting.general.CALinvFFT = get(obj, 'Value');

if ((chndl.setting.general.CALinvFFT == 1) && (chndl.setting.general.CALVerification == 2))    
    set(chndl.uicontrol.tone.start_BN, 'Enable', 'off');
    set(chndl.uicontrol.noise.start_BN, 'Enable', 'off');
    
elseif ((chndl.setting.general.CALinvFFT == 0) && (chndl.setting.general.CALVerification == 2))
    set(chndl.uicontrol.tone.start_BN, 'Enable', 'on');
    set(chndl.uicontrol.noise.start_BN, 'Enable', 'on');
end

set(hndl.calibrationFig, 'Userdata', chndl);