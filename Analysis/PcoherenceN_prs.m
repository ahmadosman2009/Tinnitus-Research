function PcoherenceN_prs(obj, evt)

hndl = get(gcf, 'Userdata');

set(hndl.uicontrol.control.waveN, 'Enable', 'off');

set(hndl.uicontrol.control.FFTN, 'Enable', 'off');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'off');

set(hndl.uicontrol.control.phaseN, 'Enable', 'off');
% 
% fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*rsp.coh']));
% 
% fnp = {fin.name}';

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
    for mmm = 1:length(fnp)
        
        try
            fnm = fullfile(hndl.general.file.PathN, fnp{mmm});
        
            set(hndl.uicontrol.control.mf_ED, 'String', hndl.general.setting.mf(mmm));

            set(hndl.uicontrol.control.headLine_TX, 'String', fnp{mmm})

            tmpa = PreadCOH(fnm);

            [bn, bb] = max(tmpa(:, 1));

            seg = floor(length(tmpa)/bb);

            segIndx = 1:bb;

            [vm, pm] = min(abs((tmpa(1:bb, 1) - hndl.general.setting.mf(mmm))));

            tstr = '';
            cla;

            passedrst = zeros(hndl.setting.criteria.NCriteria, 1);
            
            rst = zeros(seg, 5, hndl.setting.criteria.NCriteria);  %seg, %coh, diff, sd, strength, checkpass, %criteria
            
            for qqq = 1:seg
                Cxy = tmpa((segIndx+(qqq-1)*bb), 2);
                FactorF = tmpa((segIndx+(qqq-1)*bb), 1);
                
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
                end

                if 1
                    %                         set(hndl.postreviewFig, 'CurrentAxes', hndl.axes(hndl.uicontrol.plots.display_AX));

                    plot(FactorF, Cxy, 'Color', rand(1, 3)); hold on;

                    xlim(hndl.general.setting.mf(mmm)*[2.^(-hndl.general.setting.bandwidth/2), 2.^(hndl.general.setting.bandwidth/2)]);
                    ylim([0, 1]);

                    xlabel('Frequency (Hz)');
                    ylabel('Coherence');

                    grid on;
                    
                    drawnow; 
                    
%                     pause(0.2);
                end
            end

            for kkk = 1:hndl.setting.criteria.NCriteria
                tstr = sprintf('%s%d-P%d; ', tstr, kkk, passedrst(kkk) >= hndl.setting.criteria.NBlocks);
            end
            
            text(hndl.general.setting.mf(mmm)/1.4, 0.9, tstr, 'FontSize', 18);
            
            hold off;
            
            drawnow; pause(0.1);
            
            sht = strrep(strrep(fnp{mmm}, hndl.general.file.FileN, ''), '.coh', '');
            
            xlswrite(CohereXC, {'Frequency (Hz)', 'Coherence'}, sht, 'A1');
            
%             xlswrite(CohereXC, tmpa, sht, 'A2');
            
            xlswrite(CohereXC, {'MF', '#COH', '#OMIT', '#DIFFL', '#DIFFR', '#SDL', '#SDR'}, sht, 'C1');
            
            xlswrite(CohereXC, hndl.general.setting.mf(mmm), sht, 'C2');
            
            xlswrite(CohereXC, hndl.setting.criteria.NPoints, sht, 'D2');
            
            for kkk = 1:hndl.setting.criteria.NCriteria                
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
                                              
                xlswrite(CohereXC, {'#', 'Passed', 'coh', 'diff', 'sd', 'strength', 'checkpass'}, sht, [CLM '1']);                
                xlswrite(CohereXC, [kkk, passedrst(kkk)], sht, [CLM '2']);
                xlswrite(CohereXC, rst(:, :, kkk), sht, [CLMB '3']);
            end
            
%             pause(4);
        catch
            set(hndl.uicontrol.control.headLine_TX, 'String', 'Data problem');
        end
    end
end

set(hndl.uicontrol.control.waveN, 'Enable', 'on');

set(hndl.uicontrol.control.FFTN, 'Enable', 'on');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'on');

set(hndl.uicontrol.control.phaseN, 'Enable', 'on');