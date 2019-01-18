function PPhaseN_prs2(obj, evt)

hndl = get(gcf, 'Userdata');

set(hndl.uicontrol.control.waveN, 'Enable', 'off');

set(hndl.uicontrol.control.FFTN, 'Enable', 'off');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'off');

set(hndl.uicontrol.control.phaseN, 'Enable', 'off');

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*rsp.sgn']));

fnp = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*ref.sgn']));

fnr = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN '*Phase*.xls']));

fnx = {fin.name}';

if isempty(fnx)
    PhaseXC = fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN 'Phase' char(65) '.xls']);
else
    PhaseXC = fullfile(hndl.general.file.PathNRe, [hndl.general.file.FileN 'Phase' char(65 + length(fnx)) '.xls']);
end

axes(hndl.uicontrol.plots.display_AX);

if isempty(fnp)
    set(hndl.uicontrol.control.headLine_TX, 'String', 'None File');
else
    
    str = '';
    
    for mmm = 1:length(fnp)
        cla;
        
        set(hndl.uicontrol.control.headLine_TX, 'String', fnp{mmm});
        
        set(hndl.uicontrol.control.mf_ED, 'String', hndl.general.setting.mf(mmm));
        
        str = sprintf('%s%s: MF%5.2f ', str, fnp{mmm}, hndl.general.setting.mf(mmm));
        
        [bB, aB] = butter(2, ...
            hndl.general.setting.mf(mmm)*...
            [2.^(-hndl.general.setting.bandwidth/2), 2.^(hndl.general.setting.bandwidth/2)]/...
            (hndl.general.setting.FsP/2));     
               
        try
            fnmr = fullfile(hndl.general.file.PathN, fnr{mmm});
            
            fnms = fullfile(hndl.general.file.PathN, fnp{mmm});
            
            [sig, ref, Dsmp, cyc, NBlocks] = getReAccumulated(fnms, fnmr, hndl.general.setting.mf(mmm), hndl.general.setting.FsP);
            
            sig = filtfilt(bB, aB, (sig*1000/2/8/NBlocks));   %response original amplified 2000 times, /2 to mV, *1000 to uV
            
            N = floor(length(sig)/8);

            sigN = zeros(N, 1);
            refN = zeros(N, 1);
            
            for ppp = 1:8
                sigN = sigN + sig((ppp-1)*N + (1:N));
                refN = refN + ref((ppp-1)*N + (1:N));
            end

            refN = refN*5/max(abs(refN));

            Dcyc = (hndl.general.setting.FsP/hndl.general.setting.mf(mmm));
            
            NN = 10;
            
            Dshft = floor(Dcyc*floor(cyc/NN));
            
            Dcyc = floor(Dcyc);
            
            %             t = (0:(Dcyc-1))'/hndl.general.setting.FsP*1000;
            t = (0:(Dcyc-1))'/Dcyc;
            
            tmpsigN = zeros(Dcyc, 1);
            tmprefN = zeros(Dcyc, 1);

            MC = floor(Dcyc/2);
            
            mi = zeros(NN, 1);
            ti = zeros(NN, 1);
            tc = zeros(NN, 1);
            ci = zeros(NN, 1);
            
            for qqq = 1:NN
                tmpAs = sigN((qqq-1)*Dshft+(1:Dcyc));
                tmpAr = refN((qqq-1)*Dshft+(1:Dcyc));
                
                [tmAs, Ptmp] = max((tmpAs));
                ti(qqq) = Ptmp;
                mi(qqq) = tmAs;
                
                [tmA, Ptmp] = max((tmpAr));
                ci(qqq) = Ptmp;
                
                tc(qqq) = ti(qqq) - ci(qqq);
                
                PtmpA = abs(MC - Ptmp);
                
                sigNA = tmpAs;
                refNA = tmpAr;
                
                if Ptmp < MC
                    sigNA(1:PtmpA) = tmpAs(end-PtmpA+1:end);
                    sigNA(PtmpA+1:end) = tmpAs(1:end-PtmpA);
                    
                    ti(qqq) = (mod((ti(qqq)+PtmpA-1), Dcyc))+1;
                    
                    refNA(1:PtmpA) = tmpAr(end-PtmpA+1:end);
                    refNA(PtmpA+1:end) = tmpAr(1:end-PtmpA);
                elseif Ptmp > MC
                    sigNA(1:end-PtmpA) = tmpAs(PtmpA+1:end);
                    sigNA(end-PtmpA+1:end) = tmpAs(1:PtmpA);
                    
                    ti(qqq) = (mod((ti(qqq)-PtmpA-1), Dcyc))+1;
                    
                    if ti(qqq) == 0
                        ti(qqq) = Dcyc;
                    end
                            
                    refNA(1:end-PtmpA) = tmpAr(PtmpA+1:end);
                    refNA(end-PtmpA+1:end) = tmpAr(1:PtmpA);                    
                end
                
                tmpsigN = tmpsigN + sigNA;
                tmprefN = tmprefN + refNA;
                
                plot(t, sigNA, 'm', t, refNA, 'k');
                
                hold on;
                %                 plot(t, tmpAs, 'g', t, tmpAr, 'y');
                plot(t(ti(qqq))*ones(2,1), [-5; mi(qqq)], 'r');

                axis([t(1), t(end), -5 5]);
                
                pause(0.2)
            end
            
            plot(t, tmpsigN/NN, '-r', 'LineWidth', 3); hold on,
            
            plot(t, tmprefN/NN, '-b', 'LineWidth', 3);
            
            hold off;
            
            axis([t(1), t(end), -5 5]);
            
            xlabel('Time (cycle)');
            ylabel('uV');
            
            grid on;
            
            sht = strrep(strrep(fnp{mmm}, hndl.general.file.FileN, ''), '.sgn', ...
                ['F' num2str(hndl.general.setting.mf(mmm)) 'L' num2str(hndl.general.setting.LV(mmm)) 'C' num2str(hndl.general.setting.CF(mmm))]);
            
            xlswrite(PhaseXC, {'Time (cycle)', 'Resp (uV)', 'Reference', 'Peak Syc', 'peak SD', 'Phase (cycle)', 'Amp+ (uV)', 'Amp- (uV)'}, sht, 'A1');
                        
            xlswrite(PhaseXC, [t, tmpsigN/NN, tmprefN/NN], sht, 'A2');
            
            [VS, st] = VectorStrength(tc, Dcyc);
            [PL, PhsP] = max(tmpsigN/NN);
            PN = min(tmpsigN/NN);
            PhsP = (2*pi*(mod((Dcyc+PhsP-MC), Dcyc))/Dcyc)*(180/pi)/360;
            
            xlswrite(PhaseXC, [VS, st, PhsP, PL, PN], sht, 'D2');
            
            strD = sprintf('Peak: Cycle %4.3f, Syc %3.2f, SD (cycle) %4.3f; Amp(uV) [%5.2f, %5.2f]', PhsP, VS, st, PL, PN);
            text(0, -4, strD, 'FontSize', 18);
            
            str = sprintf('%s %s\n', str, strD);
            
            set(hndl.uicontrol.control.display_ED, 'String', str);
            
            drawnow; 
            pause(1);
        catch
            set(hndl.uicontrol.control.headLine_TX, 'String', 'Data problem');
            str = sprintf('%s\n', str);
            
            set(hndl.uicontrol.control.display_ED, 'String', str);
            
            pause(2);
        end
    end
end 

set(hndl.uicontrol.control.waveN, 'Enable', 'on');

set(hndl.uicontrol.control.FFTN, 'Enable', 'on');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'on');

set(hndl.uicontrol.control.phaseN, 'Enable', 'on');
                                                                                                                                              
