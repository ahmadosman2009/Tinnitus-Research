function LoadParameterBN_prs(obj, evt)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

[tpstr, tppth, tpindx] = uigetfile('*.mat', 'Calibration File', fullfile(hndl.filepath.parameterPath, hndl.setting.general.parameterfileN));

if tpindx
    hndl.filepath.parameterPath = tppth;
    hndl.setting.general.parameterfileN = tpstr;
    set(hndl.uicontrol.control.Parameters_ED, 'String', hndl.setting.general.parameterfileN);
    
    load(fullfile(hndl.filepath.parameterPath, hndl.setting.general.parameterfileN));
    
    hndl.setting = tmpSetting;
    
    set(hndl.mainFig, 'Userdata', hndl);
    
    updateParameter;
end
