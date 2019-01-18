function PFFTN_prs(obj, evt)

hndl = get(gcf, 'Userdata');

set(hndl.uicontrol.control.waveN, 'Enable', 'off');

set(hndl.uicontrol.control.FFTN, 'Enable', 'off');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'off');

set(hndl.uicontrol.control.phaseN, 'Enable', 'off');

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*rsp.dat']));

fnp = {fin.name}';

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
    for mmm = 1:length(fnp)
        
        set(hndl.uicontrol.control.mf_ED, 'String', hndl.general.setting.mf(mmm));
        
        [bB, aB] = butter(4, ...
            hndl.general.setting.mf(mmm)*...
            [2.^(-hndl.general.setting.bandwidth/2), 2.^(hndl.general.setting.bandwidth/2)]/...
            (hndl.general.setting.FsP/2));
        
        try
            fnm = fullfile(hndl.general.file.PathN, fnp{mmm});
            sig = PreadDAT(fnm);
            
            N = floor(length(sig)/8);

            M = 2.^(nextpow2(N));
            
            sigN = filter(bB, aB, sig);
            
            [HS, FW] = pwelch(sigN*1000, N, round(N/2), M, hndl.general.setting.FsP);

            axes(hndl.uicontrol.plots.display_AX);
            
            cla;
            
            plot(FW, HS, 'Color', rand(1, 3));
            
            xlim(hndl.general.setting.mf(mmm)*[2.^(-hndl.general.setting.bandwidth/2), ...
                2.^(hndl.general.setting.bandwidth/2)]); 
                       
            xlabel('Frequency (Hz)');
            ylabel('dB');
            
            grid on;
            
            set(hndl.uicontrol.control.headLine_TX, 'String', fnp{mmm})
            
            fred = find(FW < hndl.general.setting.mf(mmm)*(2.^(hndl.general.setting.bandwidth)));
            
            sht = strrep(strrep(fnp{mmm}, hndl.general.file.FileN, ''), '.dat', '');
            
            xlswrite(FFTXC, {'Freq (Hz)', 'Power (dB)'}, sht, 'A1')
            
            xlswrite(FFTXC, [FW(fred), HS(fred)], sht, 'A2')

            pause(5);
        catch
            set(hndl.uicontrol.control.headLine_TX, 'String', 'Data problem');
        end
    end
end 

set(hndl.uicontrol.control.waveN, 'Enable', 'on');

set(hndl.uicontrol.control.FFTN, 'Enable', 'on');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'on');

set(hndl.uicontrol.control.phaseN, 'Enable', 'on');