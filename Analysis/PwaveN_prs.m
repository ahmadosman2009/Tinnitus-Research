function PwaveN_prs(obj, evt)

hndl = get(gcf, 'Userdata');

set(hndl.uicontrol.control.waveN, 'Enable', 'off');

set(hndl.uicontrol.control.FFTN, 'Enable', 'off');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'off');

set(hndl.uicontrol.control.phaseN, 'Enable', 'off');

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*rsp.dat']));

fnp = {fin.name}';

fin = dir(fullfile(hndl.general.file.PathN, [hndl.general.file.FileN '*ref.dat']));

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
    for mmm = 1:length(fnp)
        cla;
        mmm
        
        [bB, aB] = butter(4, ...
            hndl.general.setting.mf(mmm)*...
            [2.^(-hndl.general.setting.bandwidth/2), 2.^(hndl.general.setting.bandwidth/2)]/...
            (hndl.general.setting.FsP/2));
        
        try
            fnmr = fullfile(hndl.general.file.PathN, fnr{mmm});
            ref = PreadDAT(fnmr);
            
            fnm = fullfile(hndl.general.file.PathN, fnp{mmm});
            sig = PreadDAT(fnm);
            
            N = floor(length(sig)/8);

            sigN = zeros(N, 1);
            refN = zeros(N, 1);
            
            for ppp = 1:8
                sigN = sigN + sig((ppp-1)*N + (1:N));
                refN = refN + ref((ppp-1)*N + (1:N));
            end

            sigN = filter(bB, aB, sigN*1000/8);
            refN = refN*0.1/max(abs(refN));

            axes(hndl.uicontrol.plots.display_AX);

%             t = (0:(length(sigN)-1))'/hndl.general.setting.FsP*1000;

            Dcyc = round(hndl.general.setting.FsP/hndl.general.setting.mf(mmm));
            t = (0:(length(sigN)-1))'/Dcyc;
            
            plot(t, sigN, 'r', t, refN, 'c');
            
            axis([t(1), t(end), -0.1 0.1]);
            
            xlabel('Time (cycle)');
            ylabel('mV');
            
            grid on;
            
            set(hndl.uicontrol.control.headLine_TX, 'String', fnp{mmm})        
            
            set(hndl.uicontrol.control.mf_ED, 'String', hndl.general.setting.mf(mmm));
            
            sht = strrep(strrep(fnp{mmm}, hndl.general.file.FileN, ''), '.dat', '');
            
            xlswrite(WaveXC, {'Cylces', 'Level (nV)'}, sht, 'A1');
            
            xlswrite(WaveXC, [t, sigN*1e3], sht, 'A2');
        catch
            set(hndl.uicontrol.control.headLine_TX, 'String', 'Data problem');
        end

        pause(5);
    end
end 

set(hndl.uicontrol.control.waveN, 'Enable', 'on');

set(hndl.uicontrol.control.FFTN, 'Enable', 'on');

set(hndl.uicontrol.control.coherenceN, 'Enable', 'on');

set(hndl.uicontrol.control.phaseN, 'Enable', 'on');
