function PFFTN_prs2(obj, evt)

hndl = get(gcf, 'Userdata');

set(hndl.uicontrol.control.waveN, 'Enable', 'off');

set(hndl.uicontrol.control.FFTN, 'Enable', 'off');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'off');

set(hndl.uicontrol.control.phaseN, 'Enable', 'off');

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*rsp.sgn']));

fnp = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*ref.sgn']));

fnr = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN '*FFT*.xls']));

fnx = {fin.name}';

if isempty(fnx)
    FFTXC = fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN 'FFT' char(65) '.xls']);
else
    FFTXC = fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN 'FFT' char(65 + length(fnx)) '.xls']);
end

if isempty(fnp)
    set(hndl.uicontrol.control.headLine_TX, 'String', 'None File');
else
    
    axes(hndl.uicontrol.plots.display_AX);
    
    for mmm = 1:length(fnp)
        
        set(hndl.uicontrol.control.mf_ED, 'String', hndl.general.setting.mf(mmm));
        
        [bB, aB] = butter(2, ...
            hndl.general.setting.mf(mmm)*...
            [2.^(-hndl.general.setting.bandwidth/2), 2.^(hndl.general.setting.bandwidth/2)]/...
            (hndl.general.setting.FsP/2));
        
        try
            fnmr = fullfile(hndl.general.file.PathN, fnr{mmm});
            
            fnms = fullfile(hndl.general.file.PathN, fnp{mmm});
            
            [sig, tmpC, tmpA, tmpB, NBlocks] = getReAccumulated(fnms, fnmr, hndl.general.setting.mf(mmm), hndl.general.setting.FsP);
            
            N = floor(length(sig)/8);

            M = 2.^(nextpow2(N));
            
            sigN = filtfilt(bB, aB, sig*1000/2/NBlocks);
            
            [HS, FW] = pwelch(sigN*4, N, round(N/2), M, hndl.general.setting.FsP);
            
            cla;
            
            semilogx(FW, 10*log10(HS), 'Color', rand(1, 3));
            
            xlim(hndl.general.setting.mf(mmm)*[2.^(-hndl.general.setting.bandwidth/2), ...
                2.^(hndl.general.setting.bandwidth/2)]); 
            
            ylim([ max(10*log10(HS)) - 10, 30]);
                       
            xlabel('Frequency (Hz)');
            ylabel('dB re 1 uV');
            
            grid on;
            
            set(hndl.uicontrol.control.headLine_TX, 'String', fnp{mmm})
            
            fred = find(FW < hndl.general.setting.mf(mmm)*(2.^(hndl.general.setting.bandwidth)));
            
            sht = strrep(strrep(fnp{mmm}, hndl.general.file.FileN, ''), '.sgn', ...
                ['F' num2str(hndl.general.setting.mf(mmm)) 'L' num2str(hndl.general.setting.LV(mmm)) 'C' num2str(hndl.general.setting.CF(mmm))]);            
            
            xlswrite(FFTXC, {'Freq (Hz)', 'Power'}, sht, 'A1')
            
            xlswrite(FFTXC, [FW(fred), HS(fred)], sht, 'A2')

            pause(2);
        catch
            set(hndl.uicontrol.control.headLine_TX, 'String', 'Data problem');
        end
    end
end 

set(hndl.uicontrol.control.waveN, 'Enable', 'on');

set(hndl.uicontrol.control.FFTN, 'Enable', 'on');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'on');

set(hndl.uicontrol.control.phaseN, 'Enable', 'on');