function CALfileName_prs(obj, evt, vv)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');
chndl = get(hndl.calibrationFig, 'Userdata');

switch vv
    case 1
        [tpstr, tppth, tpindx] = uigetfile('*.mat', 'Calibration File', fullfile(hndl.filepath.CALPath, hndl.setting.general.CALfileN));
        if tpindx
            hndl.filepath.CALPath = tppth;
            hndl.setting.general.CALfileN = tpstr;
            chndl.setting.calibration.CALfileN = hndl.setting.general.CALfileN;
        end
    case 2
        hndl.setting.general.CALfileN = get(obj, 'String');
        chndl.setting.calibration.CALfileN = hndl.setting.general.CALfileN;
    case 3
        chndl.setting.calibration.CALfileN = get(obj, 'String');
        set(hndl.calibrationFig, 'Userdata', chndl);
end

if vv < 3
    fnm = fullfile(hndl.filepath.CALPath, hndl.setting.general.CALfileN);
    if exist(fnm, 'file')
        load(fnm);
        %'CALtone', 'CALtoneFreq', 'CALns', 'CALpower', 'CALfreq', 'CALtoneadj', 'CALnsadj', beq, sensitivity_dB, ExtraGain;
        hndl.setting.calibration.CALtone = CALtone;
        hndl.setting.calibration.CALtoneFreq = CALtoneFreq;
        hndl.setting.calibration.CALns = CALns;
        hndl.setting.calibration.CALpower = CALpower;
        hndl.setting.calibration.CALfreq = CALfreq;
        hndl.setting.calibration.CALtoneadj = CALtoneadj;
        hndl.setting.calibration.CALnsadj = CALnsadj;
        hndl.setting.calibration.beq = beq;        
        hndl.setting.calibration.borg = borg;
        hndl.setting.calibration.sensitivity_dB = sensitivity_dB;
        hndl.setting.calibration.ExtraGain = ExtraGain;

        set(hndl.mainFig, 'Userdata', hndl);

        chndl.setting.calibration.CALtone = hndl.setting.calibration.CALtone;
        chndl.setting.calibration.CALtoneFreq = hndl.setting.calibration.CALtoneFreq;
        chndl.setting.calibration.CALns = hndl.setting.calibration.CALns;
        chndl.setting.calibration.CALpower = hndl.setting.calibration.CALpower;
        chndl.setting.calibration.CALfreq = hndl.setting.calibration.CALfreq;
        chndl.setting.calibration.CALtoneadj = hndl.setting.calibration.CALtoneadj;
        chndl.setting.calibration.CALnsadj = hndl.setting.calibration.CALnsadj;
        chndl.setting.calibration.beq = hndl.setting.calibration.beq;
        chndl.setting.calibration.borg = hndl.setting.calibration.borg;
        chndl.setting.calibration.sensitivity_dB = hndl.setting.calibration.sensitivity_dB;        
        chndl.setting.calibration.ExtraGain = hndl.setting.calibration.ExtraGain;
        
        chndl.setting.general.sensitivity_V = 94 - chndl.setting.calibration.sensitivity_dB;

        set(hndl.calibrationFig, 'Userdata', chndl);

        set(hndl.uicontrol.control.CALfileName_ED, 'String', hndl.setting.general.CALfileN);

        set(chndl.uicontrol.general.CALfileName_ED, 'String', chndl.setting.calibration.CALfileN);
    else
        set(obj, 'String', 'Calibration file error');
    end
end