function PPhaseN_prs(obj, evt)

hndl = get(gcf, 'Userdata');

set(hndl.uicontrol.control.waveN, 'Enable', 'off');

set(hndl.uicontrol.control.FFTN, 'Enable', 'off');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'off');

set(hndl.uicontrol.control.phaseN, 'Enable', 'off');

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*rsp.dat']));

fnp = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*ref.dat']));

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
    for mmm = 1:length(fnp)
        cla;
        
        set(hndl.uicontrol.control.headLine_TX, 'String', fnp{mmm});
        
        set(hndl.uicontrol.control.mf_ED, 'String', hndl.general.setting.mf(mmm));
        
        [bB, aB] = butter(4, ...
            hndl.general.setting.mf(mmm)*...
            [2.^(-hndl.general.setting.bandwidth/2), 2.^(hndl.general.setting.bandwidth/2)]/...
            (hndl.general.setting.FsP/2));
        
        
        try
            fnmr = fullfile(hndl.general.file.PathN, fnr{mmm});
            ref = PreadDAT(fnmr);
            
            fnm = fullfile(hndl.general.file.PathN, fnp{mmm});
            sig = PreadDAT(fnm);
            
            sig = filter(bB, aB, sig*1000/8);
%             tppp = length(sig)/8
            
            N = floor(length(sig)/8);

            sigN = zeros(N, 1);
            refN = zeros(N, 1);
            
            for ppp = 1:8
                sigN = sigN + sig((ppp-1)*N + (1:N));
                refN = refN + ref((ppp-1)*N + (1:N));
            end

            
%             sigN = filter(bB, aB, sigN*1000/8);
            refN = refN*0.05/max(abs(refN));

%             axes(hndl.uicontrol.plots.display_AX);

%             tppppp = hndl.general.setting.FsP/hndl.general.setting.mf(mmm)

            Dcyc = round(hndl.general.setting.FsP/hndl.general.setting.mf(mmm));
%             t = (0:(length(sigN)-1))'/Dcyc;

            NN = floor(length(sigN)/Dcyc);
            
            t = (0:(Dcyc-1))'/hndl.general.setting.FsP*1000;
            
            tmpsigN = zeros(Dcyc, 1);
            tmprefN = zeros(Dcyc, 1);

            MC = floor(Dcyc/2);
            
            ti = zeros(NN, 1);
            tc = zeros(NN, 1);
            ci = zeros(NN, 1);
            
            for qqq = 1:NN
                tmpAs = sigN((qqq-1)*Dcyc+(1:Dcyc));
                tmpAr = refN((qqq-1)*Dcyc+(1:Dcyc));
                
                [tmA, Ptmp] = max((tmpAs));
                ti(qqq) = Ptmp;
                
                [tmA, Ptmp] = max((tmpAr));
                ci(qqq) = Ptmp;
                
                tc(qqq) = ti(qqq) - ci(qqq);
                
                PtmpA = abs(MC - Ptmp);
                
                sigNA = tmpAs;
                refNA = tmpAr;
                
                if Ptmp < MC
                    sigNA(1:PtmpA) = tmpAs(end-PtmpA+1:end);
                    sigNA(PtmpA+1:end) = tmpAs(1:end-PtmpA);
                    
                    refNA(1:PtmpA) = tmpAr(end-PtmpA+1:end);
                    refNA(PtmpA+1:end) = tmpAr(1:end-PtmpA);
                elseif Ptmp > MC
                    sigNA(1:end-PtmpA) = tmpAs(PtmpA+1:end);
                    sigNA(end-PtmpA+1:end) = tmpAs(1:PtmpA);
                            
                    refNA(1:end-PtmpA) = tmpAr(PtmpA+1:end);
                    refNA(end-PtmpA+1:end) = tmpAr(1:PtmpA);                    
                end
                
                tmpsigN = tmpsigN + sigNA;
                tmprefN = tmprefN + refNA;
                
                plot(t, sigNA, 'm', t, refNA, 'k');
%                 plot(t, tmpAs, 'g', t, tmpAr, 'y');

                axis([t(1), t(end), -0.05 0.05]);
                
                pause(0.1)
                
                hold on;
            end
            
            plot(t, tmpsigN/NN, '-r', 'LineWidth', 3); hold on,
            
            plot(t, tmprefN/NN, '-b', 'LineWidth', 3);
            
            hold off;
            
            axis([t(1), t(end), -0.05 0.05]);
            
            xlabel('Time (ms)');
            ylabel('mV');
            
            grid on;
            
            sht = strrep(strrep(fnp{mmm}, hndl.general.file.FileN, ''), '.dat', '');  
                        
            xlswrite(PhaseXC, {'Time (ms)', 'Resp (uV)', 'Reference', 'Vector Strength', 'p Value', 'Phase (deg)', 'Amp+ (uV)', 'Amp- (uV)'}, sht, 'A1');
                        
            xlswrite(PhaseXC, [t, tmpsigN/NN, tmprefN/NN], sht, 'A2');
            
            [VS, pv] = VectorStrength(tc, Dcyc);
            [PL, PhsP] = max(tmpsigN/NN);
            PN = min(tmpsigN/NN);
            PhsP = (2*pi*(mod((PhsP-MC), Dcyc))/Dcyc)*(180/pi);
                        
            xlswrite(PhaseXC, [VS, pv, PhsP, PL, PN], sht, 'D2');
            
            strD = sprintf('VStrength%3.2f, p<=%4.3f; Phase(%c)%4.1f; Amp(uV) [%5.2f, %5.2f]', VS, pv, 176, PhsP, PL, PN);
            text(0, -4, strD, 'FontSize', 18);
            
            drawnow; 
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
