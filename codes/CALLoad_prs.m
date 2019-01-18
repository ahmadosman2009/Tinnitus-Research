function CALLoad_prs(obj, evt)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');
chndl = get(hndl.calibrationFig, 'Userdata');

fnm = fullfile(hndl.filepath.CALPath, chndl.setting.calibration.CALfileN);

if exist(fnm, 'file')
    load(fnm);
    %'CALtone', 'CALtoneFreq', 'CALns', 'CALpower', 'CALfreq', 'CALtoneadj', 'CALnsadj';
    chndl.setting.calibration.CALtone = CALtone;
    chndl.setting.calibration.CALtoneFreq = CALtoneFreq;
    chndl.setting.calibration.CALns = CALns;
    chndl.setting.calibration.CALpower = CALpower;
    chndl.setting.calibration.CALfreq = CALfreq;
    chndl.setting.calibration.CALtoneadj = CALtoneadj;
    chndl.setting.calibration.CALnsadj = CALnsadj;
    chndl.setting.calibration.beq = beq;    
    chndl.setting.calibration.borg = borg;
    chndl.setting.calibration.sensitivity_dB = sensitivity_dB;
    chndl.setting.calibration.ExtraGain = ExtraGain;

    chndl.setting.general.sensitivity_V = 94 - chndl.setting.calibration.sensitivity_dB;
    
    set(chndl.uicontrol.general.InScale_ED, 'String', chndl.setting.calibration.CALns);
    
    set(chndl.uicontrol.tone.Freq_ED, 'String', chndl.setting.calibration.CALtoneFreq);
    
    set(chndl.uicontrol.tone.calibratedLevel_ED, 'String', chndl.setting.calibration.CALtone);
    
    set(chndl.uicontrol.general.sensitivity_dB_ED, 'String', chndl.setting.calibration.sensitivity_dB);
    
    set(chndl.uicontrol.general.sensitivity_V_ED, 'String', chndl.setting.general.sensitivity_V);
    
    set(chndl.uicontrol.general.ExtraGain_ED, 'String', chndl.setting.calibration.ExtraGain);

    set(chndl.uicontrol.general.sensitivity_mV_ED, 'String', round(10.^(chndl.setting.calibration.sensitivity_dB/20)*10000)/10);

    set(hndl.calibrationFig, 'CurrentAxes', chndl.uicontrol.sweep.FreqDomain_AX);

    semilogx(chndl.setting.calibration.CALfreq, 10*log10(chndl.setting.calibration.CALpower) + chndl.setting.calibration.CALnsadj);
    xlabel('Frequency (Hz)');
    ylabel('Mag (dB SPL)');
    grid on;
    axis([10, hndl.setting.general.Fs/2, 0, chndl.setting.calibration.CALns]);
    pause(0.5);

    set(hndl.calibrationFig, 'Userdata', chndl);
else
    disp('Calibration file error');
end