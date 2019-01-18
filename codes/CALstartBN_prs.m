function CALstartBN_prs(obj, evt, vv)

if nargin < 3
    vv = 1;
end

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');
chndl = get(hndl.calibrationFig, 'Userdata');

st = get(obj, 'Userdata');

if st == 1
    switch vv
        case 1
            set(chndl.uicontrol.tone.start_BN, 'String', 'Tone Calibration STOP', 'Userdata', 0);
            if hndl.tdt.RP2_on
                TDT_CAL(vv);
            end
        case 2
            set(chndl.uicontrol.sweep.start_BN, 'String', 'Sweep Calibration STOP', 'Userdata', 0);
            if hndl.tdt.RP2_on
                TDT_CAL(vv);
            end
        case 3
            set(chndl.uicontrol.noise.start_BN, 'String', 'NOISE Calibration STOP', 'Userdata', 0);
            if hndl.tdt.RP2_on
                TDT_CAL(vv);
            end
    end
else
    switch vv
        case 1
            set(chndl.uicontrol.tone.start_BN, 'String', 'Tone Calibration START', 'Userdata', 1);
            if hndl.tdt.RP2_on
                TDT_CAL_halt;
            end
        case 2
            set(chndl.uicontrol.sweep.start_BN, 'String', 'Sweep Calibration START', 'Userdata', 1);
            if hndl.tdt.RP2_on
                TDT_CAL_halt;
            end
        case 3
            set(chndl.uicontrol.noise.start_BN, 'String', 'NOISE Calibration START', 'Userdata', 1);
            if hndl.tdt.RP2_on
                TDT_CAL_halt;
            end
    end    
end