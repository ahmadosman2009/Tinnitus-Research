function PTFFTN_prs2(obj, evt)

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
        
        set(hndl.uicontrol.control.headLine_TX, 'String', fnp{mmm})
        set(hndl.uicontrol.control.mf_ED, 'String', hndl.general.setting.mf(mmm));
        pause(0.5);

        [bB, aB] = butter(2, ...
            hndl.general.setting.mf(mmm)*...
            [2.^(-hndl.general.setting.bandwidth/2), 2.^(hndl.general.setting.bandwidth/2)]/...
            (hndl.general.setting.FsP/2));

        try
            fnmr = fullfile(hndl.general.file.PathN, fnr{mmm});

            fnms = fullfile(hndl.general.file.PathN, fnp{mmm});
            
            [sumrspR, sumrefR, Dsmp, cyc, NBlocks] = ...
                getPhaseblockedBlock(fnms, fnmr, hndl.general.setting.mf(mmm), hndl.general.setting.FsP, hndl.setting.criteria.perBlock);
            
            STindx = 2;
            
            sht = strrep(strrep(fnp{mmm}, hndl.general.file.FileN, ''), '.sgn', ...
                ['F' num2str(hndl.general.setting.mf(mmm)) 'L' num2str(hndl.general.setting.LV(mmm)) 'C' num2str(hndl.general.setting.CF(mmm))]);
            
            xlswrite(FFTXC, {'Freq (Hz)', 'Power'}, sht, 'A1');
            
            for qqq = 1:NBlocks
                
                rspa = sumrspR(:, qqq);
                rspa = filtfilt(bB, aB, rspa*1000/2);

                nWin = round(Dsmp/2);

                nOverlap = fix(nWin/2);

                nFFT = max(round(2.^(nextpow2(nWin))), 128);
                
                [HS, FW] = pwelch(rspa, nWin, nOverlap, nFFT, hndl.general.setting.FsP);
               
                cla;

                cr = {'r', 'k', 'b'};
                semilogx(FW, 10*log10(HS), 'Color', cr{floor((rand*3))+1});

                xlim(hndl.general.setting.mf(mmm)*[2.^(-hndl.general.setting.bandwidth/2), ...
                    2.^(hndl.general.setting.bandwidth/2)]);
                ylim([-20, 30]);
            
%                 ylim([ max(10*log10(HS)) - 10, max(10*log10(HS))]);

                xlabel('Frequency (Hz)');
                ylabel('dB re 1 uV');

                grid on;

                set(hndl.uicontrol.control.headLine_TX, 'String', fnp{mmm})

                fred = find(FW < hndl.general.setting.mf(mmm)*(2.^(hndl.general.setting.bandwidth)));
                
                stc = ['A', num2str(STindx)];

                xlswrite(FFTXC, [FW(fred), HS(fred)], sht, stc);
                
                STindx = STindx + length(fred) + 1;

                pause(0.5);
            end
        catch
            set(hndl.uicontrol.control.headLine_TX, 'String', 'Data problem');
        end
    end
end 

set(hndl.uicontrol.control.waveN, 'Enable', 'on');

set(hndl.uicontrol.control.FFTN, 'Enable', 'on');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'on');

set(hndl.uicontrol.control.phaseN, 'Enable', 'on');