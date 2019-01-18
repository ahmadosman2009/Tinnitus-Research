function PwaveN_prs2(obj, evt)

hndl = get(gcf, 'Userdata');

set(hndl.uicontrol.control.waveN, 'Enable', 'off');

set(hndl.uicontrol.control.FFTN, 'Enable', 'off');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'off');

set(hndl.uicontrol.control.phaseN, 'Enable', 'off');

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*rsp.sgn']));

fnp = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*ref.sgn']));

fnr = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN '*Wave*.xls']));

fnx = {fin.name}';

if isempty(fnx)
    WaveXC = fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN 'Wave' char(65) '.xls']);
else
    WaveXC = fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN 'Wave' char(65 + length(fnx)) '.xls']);
end

if isempty(fnp)
    set(hndl.uicontrol.control.headLine_TX, 'String', 'None File');
else
    
    axes(hndl.uicontrol.plots.display_AX);
    
    for mmm = 1:length(fnp)
        cla;

        set(hndl.uicontrol.control.headLine_TX, 'String', fnp{mmm})
        set(hndl.uicontrol.control.mf_ED, 'String', hndl.general.setting.mf(mmm));
        
        [bB, aB] = butter(2, ...
            hndl.general.setting.mf(mmm)*...
            [2.^(-hndl.general.setting.bandwidth/2), 2.^(hndl.general.setting.bandwidth/2)]/...
            (hndl.general.setting.FsP/2));
        
        try
            fnmr = fullfile(hndl.general.file.PathN, fnr{mmm});
            
            fnms = fullfile(hndl.general.file.PathN, fnp{mmm});
            
            [sig, ref, tmpA, tmpB, NBlocks] = getReAccumulated(fnms, fnmr, hndl.general.setting.mf(mmm), hndl.general.setting.FsP);
            
            N = floor(length(sig)/8);

            sigN = zeros(N, 1);
            refN = zeros(N, 1);
            
            for ppp = 1:8
                sigN = sigN + sig((ppp-1)*N + (1:N));
                refN = refN + ref((ppp-1)*N + (1:N));
            end

            sigN = filtfilt(bB, aB, sigN*1000/2/8/NBlocks);
            refN = refN*5/max(abs(refN));

            Dcyc = round(hndl.general.setting.FsP/hndl.general.setting.mf(mmm));
            t = (0:(length(sigN)-1))'/Dcyc;
            
            plot(t, sigN, 'r', t, refN, 'c');
            axis([0, 10, -5 5]);
            
            xlabel('Cycles');
            ylabel('uV');
            
            grid on;
            
            sht = strrep(strrep(fnp{mmm}, hndl.general.file.FileN, ''), '.sgn', ...
                ['F' num2str(hndl.general.setting.mf(mmm)) 'L' num2str(hndl.general.setting.LV(mmm)) 'C' num2str(hndl.general.setting.CF(mmm))]);
            
            xlswrite(WaveXC, {'Cylces', 'Level (nV)', 'Ref'}, sht, 'A1');
            
            xlswrite(WaveXC, [t, sigN, refN], sht, 'A2');
        catch
            set(hndl.uicontrol.control.headLine_TX, 'String', 'Data problem');
        end

        pause(2);
    end
end 

set(hndl.uicontrol.control.waveN, 'Enable', 'on');

set(hndl.uicontrol.control.FFTN, 'Enable', 'on');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'on');

set(hndl.uicontrol.control.phaseN, 'Enable', 'on');
