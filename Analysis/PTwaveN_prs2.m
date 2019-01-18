function PTwaveN_prs2(obj, evt)

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
        
        sht = strrep(strrep(fnp{mmm}, hndl.general.file.FileN, ''), '.sgn', ...
            ['F' num2str(hndl.general.setting.mf(mmm)) 'L' num2str(hndl.general.setting.LV(mmm)) 'C' num2str(hndl.general.setting.CF(mmm))]);
        
        xlswrite(WaveXC, {'Cylces', 'Level (nV)', 'Ref'}, sht, 'A1');
        
        STindx = 2;

        [bB, aB] = butter(2, ...
            hndl.general.setting.mf(mmm)*...
            [2.^(-hndl.general.setting.bandwidth/2), 2.^(hndl.general.setting.bandwidth/2)]/...
            (hndl.general.setting.FsP/2));

        try
            fnmr = fullfile(hndl.general.file.PathN, fnr{mmm});

            fnms = fullfile(hndl.general.file.PathN, fnp{mmm});


            [sumrspR, sumrefR, Dsmp, cyc, NBlocks] = ...
                getPhaseblockedBlock(fnms, fnmr, hndl.general.setting.mf(mmm), hndl.general.setting.FsP, hndl.setting.criteria.perBlock);

            for kkk = 1:NBlocks

                sig = sumrspR(:, kkk);
                ref = sumrefR(:, kkk);

                NN = floor(length(sig)/Dsmp);
                sigN = zeros(Dsmp, 1);
                refN = zeros(Dsmp, 1);
                if NN < 1
                    sigN(1:length(sig)) = sig;
                    refN(1:length(ref)) = ref;
                else
                    indxN = 1:Dsmp;

                    for ppp = 1:NN
                        sigN = sigN + sig(indxN+(ppp-1)*Dsmp);
                        refN = refN + ref(indxN+(ppp-1)*Dsmp);
                    end
                end

                sigN = filtfilt(bB, aB, sigN*1000/2/NN);
                refN = refN*5/max(abs(refN));

                Dcyc = round(hndl.general.setting.FsP/hndl.general.setting.mf(mmm));

                t = (0:(length(sigN)-1))'/Dcyc;

                plot(t, sigN, 'r', t, refN, 'c');
                axis([0, 10, -5 5]);

                xlabel('Cycles');
                ylabel('uV');

                grid on;
                
                stc = ['A' num2str(STindx)];
                xlswrite(WaveXC, [t, sigN, refN], sht, stc);
                
                STindx = STindx + length(t) + 1;
                
                pause(1);
            end
        catch
            set(hndl.uicontrol.control.headLine_TX, 'String', 'Data problem');
        end

        pause(0.5);
    end
end 

set(hndl.uicontrol.control.waveN, 'Enable', 'on');

set(hndl.uicontrol.control.FFTN, 'Enable', 'on');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'on');

set(hndl.uicontrol.control.phaseN, 'Enable', 'on');
