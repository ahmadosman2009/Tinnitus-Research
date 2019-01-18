function CALCalibration_prs(obj, evt)

hndl = get(gcf, 'UserData');
hndl = get(hndl.mainFig, 'Userdata');
chndl = get(hndl.calibrationFig, 'Userdata');

set(obj, 'Enable', 'off');

hndl.tdt.RP2.Halt();

rcxf = fullfile(hndl.filepath.tdtPath, 'amfrRZ6CAL.rcx');

hndl.tdt.RP2.ClearCOF;
hndl.tdt.RP2.LoadCOF(rcxf);
hndl.tdt.RP2.Run();

tpp = hndl.tdt.RP2.GetSFreq();
if tpp < 1
    error('TDT Calibration problem');
end

bufSize = round(tpp*chndl.setting.general.duration);

%
hndl.tdt.RP2.SetTagVal('SigSelect', 0);

hndl.tdt.RP2.SetTagVal('FreqA', chndl.setting.calibration.CALtoneFreq);

hndl.tdt.RP2.SetTagVal('SWSize', bufSize);

hndl.tdt.RP2.SetTagVal('LevelA', 1);

pause(0.01);

hndl.tdt.RP2.SoftTrg(1);

stg = hndl.tdt.RP2.GetTagVal('RunStatus');

while (stg > 0)
    pause(0.1);

    status = double(hndl.tdt.RP2.GetStatus);
    if bitget(status, 3) == 0
        break;
    end
    stg = hndl.tdt.RP2.GetTagVal('RunStatus');
end

runIndx = hndl.tdt.RP2.GetTagVal('RunIndex');

if runIndx > 0
    SWsig = hndl.tdt.RP2.ReadTagV('SWSigoutP', 0, runIndx);
else
    SWsig = hndl.tdt.RP2.ReadTagV('SWSigoutP', 0, bufSize);
end

TDT_CAL_halt;

% tmpRMS = get_RMS(SWsig);

chndl.setting.general.InScale = get_RMS(SWsig);

tmpLev = chndl.setting.general.sensitivity_V - chndl.setting.calibration.ExtraGain ...
    + 20*log10(chndl.setting.general.InScale);

chndl.setting.calibration.CALtone = tmpLev;

set(chndl.uicontrol.general.InScale_ED, 'String', tmpLev);

set(chndl.uicontrol.general.BPScale_ED, 'String', '+ 0');

set(chndl.uicontrol.tone.calibratedLevel_ED, 'String', tmpLev);

N = round(hndl.setting.general.Fs/50);

[CALpower, CALfreq] = pwelch(SWsig, N*2, N, N*2, hndl.setting.general.Fs);

set(hndl.calibrationFig, 'CurrentAxes', chndl.uicontrol.sweep.FreqDomain_AX);

[p, toneP] = min(abs(CALfreq - chndl.setting.calibration.CALtoneFreq));

TMPadj = 10*log10(CALpower(toneP));

semilogx(CALfreq, 10*log10(CALpower) + (chndl.setting.calibration.CALtone - TMPadj));
xlabel('Frequency (Hz)');
ylabel('Mag (dB SPL)');
grid on;
axis([10, tpp/2, 0, chndl.setting.calibration.CALtone + 20]);

pause(1);


hndl.tdt.RP2.Run();

hndl.tdt.RP2.SetTagVal('SigSelect', 1);

t = (0:bufSize-1)/tpp;

FL = round(hndl.setting.general.Fs/800);
FH = round((hndl.setting.general.Fs - (hndl.setting.general.Fs/20))/2);

A = (FH - FL)/chndl.setting.general.duration;

x = 1*sin(2*pi*(FL + A/2*t).*t);

hndl.tdt.RP2.SetTagVal('SWSize', bufSize);

hndl.tdt.RP2.SetTagVal('LevelB', 1);

hndl.tdt.RP2.WriteTagV('SWSig', 0, x);

pause(0.01);

hndl.tdt.RP2.SoftTrg(1);

stg = hndl.tdt.RP2.GetTagVal('RunStatus');

while (stg > 0)
    pause(0.1);

    status = double(hndl.tdt.RP2.GetStatus);
    if bitget(status, 3) == 0
        break;
    end
    stg = hndl.tdt.RP2.GetTagVal('RunStatus');
end

runIndx = hndl.tdt.RP2.GetTagVal('RunIndex');

if runIndx > 0
    SWsig = hndl.tdt.RP2.ReadTagV('SWSigoutP', 0, runIndx);
else
    SWsig = hndl.tdt.RP2.ReadTagV('SWSigoutP', 0, bufSize);
end

TDT_CAL_halt;

% tmpRMS2 = get_RMS(SWsig);

chndl.setting.general.InScale = get_RMS(SWsig);

chndl.setting.calibration.CALns = chndl.setting.general.sensitivity_V - chndl.setting.calibration.ExtraGain ...
    + 20*log10(chndl.setting.general.InScale);

set(chndl.uicontrol.general.InScale_ED, 'String', chndl.setting.calibration.CALns);
set(chndl.uicontrol.general.BPScale_ED, 'String', '+ 0');

N = round(hndl.setting.general.Fs/50);

[CALpower, CALfreq] = pwelch(SWsig, N*2, N, N*2, hndl.setting.general.Fs);

chndl.setting.calibration.CALpower = CALpower;
chndl.setting.calibration.CALfreq = CALfreq;

[p, SelectedCALcfP] = min(abs(CALfreq - chndl.setting.calibration.CALtoneFreq));
chndl.setting.calibration.CALtoneadj = chndl.setting.calibration.CALtone - 10*log10(CALpower(SelectedCALcfP));

chndl.setting.calibration.CALnsadj = chndl.setting.calibration.CALns - 10*log10(sum(CALpower(3:end)));

set(hndl.calibrationFig, 'CurrentAxes', chndl.uicontrol.sweep.FreqDomain_AX);

semilogx(CALfreq, 10*log10(CALpower) + chndl.setting.calibration.CALnsadj);
xlabel('Frequency (Hz)');
ylabel('Mag (dB SPL)');
grid on;
axis([10, tpp/2, 0, chndl.setting.calibration.CALns]);
pause(0.5);

NN = round(hndl.setting.general.Fs/400);

[H5, W5] = pwelch(SWsig, NN*2, NN, NN*2, hndl.setting.general.Fs);

[p, toneP] = min(abs(W5 - chndl.setting.calibration.CALtoneFreq));

TMPadj = H5(toneP);

H55 = (H5/TMPadj);

Hinv = 1./H55;

FL = round(hndl.setting.general.Fs/400);
FH = round((hndl.setting.general.Fs - (hndl.setting.general.Fs/20))/2);

[p, q] = min(abs(W5-FL));

Hinv(1:q) = H55(1:q);

[p, q] = min(abs(W5-FH));

Hinv(q:end) = eps;

chndl.setting.calibration.beq = fir2((2.^(nextpow2(NN*2))-1), W5/(hndl.setting.general.Fs/2), sqrt(Hinv));

chndl.setting.calibration.borg = fir2((2.^(nextpow2(NN*2))-1), W5/(hndl.setting.general.Fs/2), sqrt(H55));

set(obj, 'Enable', 'on');

set(hndl.calibrationFig, 'Userdata', chndl);

