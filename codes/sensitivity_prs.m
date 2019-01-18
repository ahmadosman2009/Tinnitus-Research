function sensitivity_prs(obj, evt, vv)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');
chndl = get(hndl.calibrationFig, 'Userdata');

st = str2double(get(obj, 'String'));

switch vv
    case 1
        if st > 0
            st = -st;
            set(chndl.uicontrol.general.sensitivity_dB_ED, 'String', st);
        end

        chndl.setting.calibration.sensitivity_dB = st;

        chndl.setting.general.sensitivity_mV = round(10.^(chndl.setting.calibration.sensitivity_dB/20)*10000)/10;

        chndl.setting.general.sensitivity_V = 94 - chndl.setting.calibration.sensitivity_dB;
        
        set(chndl.uicontrol.general.sensitivity_mV_ED, 'String', chndl.setting.general.sensitivity_mV);
        
        set(chndl.uicontrol.general.sensitivity_V_ED, 'String', chndl.setting.general.sensitivity_V);
    case 2

        chndl.setting.calibration.sensitivity_dB = round(20*log10(st/1000)*10)/10;

        chndl.setting.general.sensitivity_mV = st;

        chndl.setting.general.sensitivity_V = 94 - chndl.setting.calibration.sensitivity_dB;
            
        set(chndl.uicontrol.general.sensitivity_dB_ED, 'String', chndl.setting.calibration.sensitivity_dB);
        
        set(chndl.uicontrol.general.sensitivity_V_ED, 'String', chndl.setting.general.sensitivity_V);
end

set(hndl.calibrationFig, 'Userdata', chndl);