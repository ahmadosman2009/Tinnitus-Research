function SParameterOfCondition

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');
thndl = get(hndl.testFig, 'Userdata');

if (hndl.py.results.currentCondition > hndl.py.general.totalConditions)
    Stop_measure(6);
else
    hndl.py.results.return = 0;
    
    hndl.py.results.currentBlock = 0;
    hndl.py.results.currentStage = 1;

    hndl.py.results.currentParameter = hndl.py.parameter(:, :, hndl.py.results.currentCondition);
    
    hndl.py.results.NBuffSize = zeros(3, 1);
    hndl.py.results.NBuffSizeFHalf = zeros(3, 1);
    hndl.py.results.NBuffSizeSHalf = zeros(3, 1);
    hndl.py.results.currentEP = zeros(3, 1);
    hndl.py.results.currentOutLev = ones(3, 1)*0.05;
    
    for stage = 1:3
        hndl.py.results.NBuffSize(stage) = ceil((hndl.py.results.currentParameter(stage, 14) + hndl.py.results.currentParameter(stage, 15))/1000 * ...
            hndl.py.general.Fs/hndl.setting.general.nFsDown)
        
        hndl.py.results.NBuffSizeFHalf(stage) = round(hndl.py.results.NBuffSize(stage)/2);
        
        hndl.py.results.NBuffSizeSHalf(stage) = hndl.py.results.NBuffSize(stage) - hndl.py.results.NBuffSizeFHalf(stage);
        
        if hndl.py.results.currentParameter(stage, 1) == 1
            hndl.py.results.currentEP(stage) = 0;
        else
            hndl.py.results.currentEP(stage) = 2.^(hndl.py.results.currentParameter(stage, 1) - 2);
        end
        
        if hndl.py.results.currentParameter(stage, 5) == 1
            tmpvA = 10.^((hndl.py.results.currentParameter(stage, 11) - ...
                ((hndl.py.results.currentParameter(stage, 12)) + ...
                20*log10(hndl.py.results.currentParameter(stage, 10))))/20); %min(tpLev, 0)
            hndl.py.results.currentOutLev(stage) = tmpvA;
            
        else
            tmpvA  = 10.^((hndl.py.results.currentParameter(stage, 11) - ...
                (hndl.py.results.currentParameter(stage, 12)))/20); %min(tpLev, 0)
            hndl.py.results.currentOutLev(stage) = tmpvA;
        end        
    end

    hndl.py.file.strName = sprintf('%s%02d%c', hndl.py.file.strBaseName, hndl.py.results.currentCondition, hndl.py.results.fileIndx);
%     
%     if hndl.py.general.rawRecording
%         hndl.py.file.strREF = [hndl.py.file.strName 'REF.sgn'];
%         hndl.py.file.strRSP = [hndl.py.file.strName 'RSP.sgn'];
%         hndl.py.file.fidREF = fopen(hndl.py.file.strREF, 'w');
%         hndl.py.file.fidRSP = fopen(hndl.py.file.strRSP, 'w');
%     end

    if hndl.py.results.currentCondition == hndl.py.general.totalConditions
        set(thndl.uicontrol.results.start_BN, 'String', 'STOP');
        set(hndl.uicontrol.results.start_BN, 'String', 'STOP');
    else
        set(thndl.uicontrol.results.start_BN, 'String', 'SKIP');
        set(hndl.uicontrol.results.start_BN, 'String', 'SKIP');
    end
           
    if ((hndl.py.results.currentCondition == 1) && (hndl.py.results.fileIndx == 65))
        set(thndl.uicontrol.results.ResultsSummary_ED, 'String', '-');
    end
    
    fprintf(hndl.py.file.fidBase, '\n%d\t', hndl.py.results.currentCondition);
    
    for stage = 1:3
%         fprintf(hndl.py.file.fidBase, '%s\t%3.2f\t%5.2f\t%s\t%5.0f\t%3.2f\t%d\t%d\t%d\t%d\t%d\t%d\t', ...
            fprintf(hndl.py.file.fidBase, '%s\t%3.2f\t%5.2f\t%s\t%5.0f\t%3.2f\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t', ...
            hndl.str.modulation_type{hndl.py.results.currentParameter(stage, 1)}, ...
            hndl.py.results.currentParameter(stage, 2), ...
            hndl.py.results.currentParameter(stage, 3), ...
            hndl.str.carrier_type{hndl.py.results.currentParameter(stage, 5) + 1}, ...
            hndl.py.results.currentParameter(stage, 6), ...
            hndl.py.results.currentParameter(stage, 7), ...
            hndl.py.results.currentParameter(stage, 11), ...
            hndl.py.results.currentParameter(stage, 13), ...
            hndl.py.results.currentParameter(stage, 14), ...
            hndl.py.results.currentParameter(stage, 15), ...
            hndl.py.results.currentParameter(stage, 16), ...
            hndl.py.results.currentParameter(stage, 17), ...
            hndl.py.results.currentParameter(stage, 18), ...
            hndl.py.results.currentParameter(stage, 19));
    end
    
%     hndl.py.results.currentTDTpara = NaN*zeros(3, 16);
    hndl.py.results.currentTDTpara = NaN*zeros(3, 18);

    for stage = 1:3
        hndl.py.results.currentTDTpara(stage, 1) = hndl.py.results.currentEP(stage);  %EP
        hndl.py.results.currentTDTpara(stage, 2) = hndl.py.results.currentParameter(stage, 2); %Depth
        hndl.py.results.currentTDTpara(stage, 3) = hndl.py.results.currentParameter(stage, 3); %mf
        hndl.py.results.currentTDTpara(stage, 4) = hndl.py.results.currentParameter(stage, 4); %mLev
        hndl.py.results.currentTDTpara(stage, 5) = hndl.py.results.currentParameter(stage, 5); %carrier type
        hndl.py.results.currentTDTpara(stage, 6) = hndl.py.results.currentParameter(stage, 6); %center freq
        hndl.py.results.currentTDTpara(stage, 7) = hndl.py.results.currentParameter(stage, 8); %bandwidth low
        hndl.py.results.currentTDTpara(stage, 8) = hndl.py.results.currentParameter(stage, 9); %bandwidth high
        hndl.py.results.currentTDTpara(stage, 9) = hndl.py.results.currentParameter(stage, 10); %carrier level adj
        hndl.py.results.currentTDTpara(stage, 10) = hndl.py.results.currentOutLev(stage); %output level
        hndl.py.results.currentTDTpara(stage, 11) = hndl.py.results.currentParameter(stage, 13); %N
        hndl.py.results.currentTDTpara(stage, 12) = hndl.py.results.currentParameter(stage, 14); %sig
        hndl.py.results.currentTDTpara(stage, 13) = hndl.py.results.currentParameter(stage, 15); %silence
        hndl.py.results.currentTDTpara(stage, 14) = hndl.py.results.currentParameter(stage, 16); %FisrtSil
        hndl.py.results.currentTDTpara(stage, 15) = hndl.py.results.currentParameter(stage, 17); %ramp
        hndl.py.results.currentTDTpara(stage, 16) = hndl.py.results.NBuffSize(stage); %buffer size
        hndl.py.results.currentTDTpara(stage, 17) = hndl.py.results.currentParameter(stage,18); %click high length
        hndl.py.results.currentTDTpara(stage, 18) = hndl.py.results.currentParameter(stage,19); %buffer low length
    end

    set(hndl.mainFig, 'Userdata', hndl);
end
