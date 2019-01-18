function CALSave_prs(obj, evt)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');
chndl = get(hndl.calibrationFig, 'Userdata');

CALtone = chndl.setting.calibration.CALtone;
CALtoneFreq = chndl.setting.calibration.CALtoneFreq;
CALns = chndl.setting.calibration.CALns;
CALpower = chndl.setting.calibration.CALpower;
CALfreq = chndl.setting.calibration.CALfreq;
CALtoneadj = chndl.setting.calibration.CALtoneadj;
CALnsadj = chndl.setting.calibration.CALnsadj;
beq = chndl.setting.calibration.beq;
borg = chndl.setting.calibration.borg;
sensitivity_dB = chndl.setting.calibration.sensitivity_dB;
ExtraGain = chndl.setting.calibration.ExtraGain;

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

fCAL = fullfile(hndl.filepath.CALPath, chndl.setting.calibration.CALfileN);

hndl.setting.general.CALfileN = chndl.setting.calibration.CALfileN;
set(hndl.uicontrol.control.CALfileName_ED, 'String', hndl.setting.general.CALfileN);

set(hndl.mainFig, 'Userdata', hndl);

save(fCAL, 'CALtone', 'CALtoneFreq', 'CALns', 'CALpower', 'CALfreq', 'CALtoneadj', 'CALnsadj', 'beq', 'borg', 'sensitivity_dB', 'ExtraGain');

CALPath = hndl.filepath.CALPath;
CALfileN = hndl.setting.general.CALfileN;

fStartUp = 'StartUp.mat';

save(fStartUp, 'CALPath', 'CALfileN');