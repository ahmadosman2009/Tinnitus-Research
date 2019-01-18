function PTcoherenceN_prs2(obj, evt)

hndl = get(gcf, 'Userdata');

set(hndl.uicontrol.control.waveN, 'Enable', 'off');

set(hndl.uicontrol.control.FFTN, 'Enable', 'off');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'off');

set(hndl.uicontrol.control.phaseN, 'Enable', 'off');

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*rsp.sgn']));

fnp = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*ref.sgn']));

fnr = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN '*Cohere*.xls']));

fnx = {fin.name}';

if isempty(fnx)
    CohereXC = fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN 'Cohere' char(65) '.xls']);
else
    CohereXC = fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN 'Cohere' char(65 + length(fnx)) '.xls']);
end

axes(hndl.uicontrol.plots.display_AX);

if isempty(fnp)
    set(hndl.uicontrol.control.headLine_TX, 'String', 'None File');
else
    
    str = '';
    
    for mmm = 1:length(fnp)

        cla;
        try
            set(hndl.uicontrol.control.mf_ED, 'String', hndl.general.setting.mf(mmm));

            set(hndl.uicontrol.control.headLine_TX, 'String', fnp{mmm});
            
            str = sprintf('%s%s: MF%5.2f\n', str, fnp{mmm}, hndl.general.setting.mf(mmm));

            fnmr = fullfile(hndl.general.file.PathN, fnr{mmm});

            fnms = fullfile(hndl.general.file.PathN, fnp{mmm});

            sht = strrep(strrep(fnp{mmm}, hndl.general.file.FileN, ''), '.sgn', ...
                ['F' num2str(hndl.general.setting.mf(mmm)) 'L' num2str(hndl.general.setting.LV(mmm)) 'C' num2str(hndl.general.setting.CF(mmm))]);

            xlswrite(CohereXC, {'Frequency (Hz)', 'Coherence'}, sht, 'A1');

            xlswrite(CohereXC, {'MF', '#COH', '#OMIT', '#DIFFL', '#DIFFR', '#SDL', '#SDR'}, sht, 'C1');

            xlswrite(CohereXC, hndl.general.setting.mf(mmm), sht, 'C2');

            xlswrite(CohereXC, hndl.setting.criteria.NPoints, sht, 'D2');

            STindx = 2;
            
            STindxB = 0;

            [sumrspR, sumrefR, Dsmp, cyc, NBlocks] = ...
                getPhaseblockedBlock(fnms, fnmr, hndl.general.setting.mf(mmm), hndl.general.setting.FsP, hndl.setting.criteria.perBlock);                       

            rst = zeros(NBlocks, 5, hndl.setting.criteria.NCriteria);  %seg, %coh, diff, sd, strength, checkpass, %criteria

            for qqq = 1:NBlocks
                
                refa = sumrefR(:, qqq);
                rspa = sumrspR(:, qqq);

                nWin = Dsmp;
                
                nOverlap = fix(nWin/2);
                
                nFFT = max(round(2.^(nextpow2(nWin))), 128);
                
                [Cxy, freqFactor] = mscohere(rspa, refa, hamming(nWin), nOverlap, nFFT, hndl.general.setting.FsP);
                
                Phxy = cpsd(rspa, refa, hamming(nWin), nOverlap, nFFT, hndl.general.setting.FsP);
                
                freqN = find(freqFactor < (hndl.general.setting.mf(mmm)*2));
                
                tmpa = [freqFactor(freqN), Cxy(freqN)];
                
                stc = ['A' num2str(STindx)];
                
                xlswrite(CohereXC, tmpa, sht, stc);
                
                STindx = STindx + length(freqN) + 1;
                
                [vm, pm] = min(abs((freqFactor - hndl.general.setting.mf(mmm))));
                
                ph = mod((360-angle(Phxy(pm))*180/pi), 360);
                
                passedrst = zeros(hndl.setting.criteria.NCriteria, 1);
                
                str = sprintf('%s\n BLK %02d: phase(%c) %4.1f ', str, qqq, 127, ph);
                
                strD = '';
                
                for kkk = 1:hndl.setting.criteria.NCriteria
                    
                    cohst = pm - floor((hndl.setting.criteria.NPoints(kkk, 1) - 1)/2);
                    cohed = pm + floor(hndl.setting.criteria.NPoints(kkk, 1)/2);
                    cohIndx = (cohst:cohed);
                    
                    diffIndx = zeros(1, sum(hndl.setting.criteria.NPoints(kkk, 3:4)));
                    
                    if hndl.setting.criteria.NPoints(kkk, 3) > 0
                        diffLed = cohst - (hndl.setting.criteria.NPoints(kkk, 2)+1);
                        diffLst = diffLed - hndl.setting.criteria.NPoints(kkk, 3) + 1;
                        diffIndx(1:hndl.setting.criteria.NPoints(kkk, 3)) = (diffLst:diffLed);
                    end
                    if hndl.setting.criteria.NPoints(kkk, 4) > 0
                        diffRst = cohed + (hndl.setting.criteria.NPoints(kkk, 2)+1);
                        diffRed = diffRst + hndl.setting.criteria.NPoints(kkk, 4) - 1;
                        diffIndx(hndl.setting.criteria.NPoints(kkk, 3) + (1:hndl.setting.criteria.NPoints(kkk, 4))) = (diffRst:diffRed);
                    end
                    
                    stdIndx = zeros(1, sum(hndl.setting.criteria.NPoints(kkk, 5:6)));
                    
                    if hndl.setting.criteria.NPoints(kkk, 5) > 0
                        stdLed = cohst - (hndl.setting.criteria.NPoints(kkk, 2)+1);
                        stdLst = stdLed - hndl.setting.criteria.NPoints(kkk, 5) + 1;
                        stdIndx(1:hndl.setting.criteria.NPoints(kkk, 5)) = (stdLst:stdLed);
                    end
                    if hndl.setting.criteria.NPoints(kkk, 6) > 0
                        stdRst = cohed + (hndl.setting.criteria.NPoints(kkk, 2)+1);
                        stdRed = stdRst + hndl.setting.criteria.NPoints(kkk, 6) - 1;
                        stdIndx(hndl.setting.criteria.NPoints(kkk, 5) + (1:hndl.setting.criteria.NPoints(kkk, 6))) = (stdRst:stdRed);
                    end
                    
                    tmpCD = Cxy(cohIndx);
                    rst(qqq, 1, kkk) = mean([tmpCD(:); Cxy(pm)]);
                    rst(qqq, 2, kkk) = mean(Cxy(diffIndx));
                    rst(qqq, 3, kkk) = std(Cxy(stdIndx));
                    rst(qqq, 4, kkk) = (rst(qqq, 1, kkk)-rst(qqq, 2, kkk))/rst(qqq, 3, kkk);
                    
                    Passed = 0;
                    
                    if hndl.setting.criteria.selection(1)
                        Passed = (Passed || (((rst(qqq, 1, kkk) >= hndl.setting.criteria.cohz) && ...
                            (rst(qqq, 4, kkk) >= hndl.setting.criteria.Zsd))));
                    end
                    if hndl.setting.criteria.selection(2)
                        Passed = (Passed || ((rst(qqq, 1, kkk) >= hndl.setting.criteria.coha)));
                    end
                    if hndl.setting.criteria.selection(3)
                        Passed = (Passed || (rst(qqq, 4, kkk) > hndl.setting.criteria.Zsda));
                    end
                    
                    rst(qqq, 5, kkk) =  Passed;
                    
                    if Passed
                        passedrst(kkk) = passedrst(kkk) + 1;
                    else
                        passedrst(kkk) = 0;
                    end
                    
                    strD = sprintf('%s Cr%d ->(COH %3.2f; Strength %3.2f) ', strD, kkk, rst(qqq, 1, kkk), rst(qqq, 4, kkk));
                    
                    CLMV = (kkk-1)*7;
                    
                    if (CLMV+10) > 52
                        CLM = ['B' char('A'+(CLMV+10)-52-1)];
                    elseif (CLMV+11) > 26
                        CLM = ['A' char('A'+(CLMV+10)-26-1)];
                    else
                        CLM = char('J'+CLMV);
                    end
                    
                    if (CLMV+12) > 52
                        CLMB = ['B' char('A'+(CLMV+12)-52-1)];
                    elseif (CLMV+11) > 26
                        CLMB = ['A' char('A'+(CLMV+12)-26-1)];
                    else
                        CLMB = char('L'+CLMV);
                    end
                    
                    if qqq == 1
                        xlswrite(CohereXC, {'#', 'Passed', 'coh', 'diff', 'sd', 'strength', 'checkpass'}, sht, [CLM '1']);
                    end
                    
                    stc = STindxB+2;
                    xlswrite(CohereXC, [kkk, passedrst(kkk)], sht, [CLM num2str(stc)]);
                    
                    stc = STindxB + 3;
                    xlswrite(CohereXC, rst(qqq, :, kkk), sht, [CLMB num2str(stc)]);
                end
                
                STindxB = STindxB + 2;
                
                if 1
                    plot(freqFactor, Cxy, 'Color', 'k'); hold on;

                    xlim(hndl.general.setting.mf(mmm)*[2.^(-hndl.general.setting.bandwidth/2), 2.^(hndl.general.setting.bandwidth/2)]);
                    ylim([0, 1]);

                    xlabel('Frequency (Hz)');
                    ylabel('Coherence');

                    grid on;

                    drawnow;
%                     pause(0.5);
                end
                
                str = sprintf('%s%s\n', str, strD);
                
            end                      
            
            set(hndl.uicontrol.control.display_ED, 'String', str);

            drawnow; pause(0.1);
            
        catch
            set(hndl.uicontrol.control.headLine_TX, 'String', 'Data problem');
        end
        hold off;
    end
end

set(hndl.uicontrol.control.waveN, 'Enable', 'on');

set(hndl.uicontrol.control.FFTN, 'Enable', 'on');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'on');

set(hndl.uicontrol.control.phaseN, 'Enable', 'on');