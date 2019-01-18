function modulationFrequencyStep_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1
        
        hndl.setting.Pre.modulation.frequencyStep_P = get(obj, 'value');
        
        if hndl.setting.Pre.modulation.Num_CK
            
            hndl.setting.Pre.modulation.frequency_N = ...
                nextpow2((hndl.setting.Pre.modulation.frequencyEnd_P/hndl.setting.Pre.modulation.frequencyStart_P).^hndl.setting.Pre.modulation.frequencyStep_P) + 1;
            hndl.setting.Pre.modulation.mf_V = zeros(1, hndl.setting.Pre.modulation.frequency_N);
            if hndl.setting.Pre.modulation.frequency_N > 1
                for qqq = 1:(hndl.setting.Pre.modulation.frequency_N-1)
                    hndl.setting.Pre.modulation.mf_V(qqq) = ...
                        round(hndl.setting.Pre.modulation.frequencyStart_P*(2.^((qqq-1)/hndl.setting.Pre.modulation.frequencyStep_P))*10)/10;
                end
            end
            hndl.setting.Pre.modulation.mf_V(end) = hndl.setting.Pre.modulation.frequencyEnd_P;
        else
            hndl.setting.Pre.modulation.frequency_N = 1;
            hndl.setting.Pre.modulation.mf_V = hndl.setting.Pre.modulation.frequencyStart_P;
            
        end
        
        hndl.setting.Post.modulation.frequencyStep_P = hndl.setting.Pre.modulation.frequencyStep_P;
        set(hndl.uicontrol.Post.modulation.modulationFrequencyStep_PU, 'Value', hndl.setting.Post.modulation.frequencyStep_P);
        
        hndl.setting.Post.modulation.frequency_N = hndl.setting.Pre.modulation.frequency_N;
        hndl.setting.Post.modulation.mf_V = hndl.setting.Pre.modulation.mf_V;
    case 2
        
        hndl.setting.LDur.modulation.frequencyStep_P = get(obj, 'value');
        
        if hndl.setting.LDur.modulation.Num_CK
            
            hndl.setting.LDur.modulation.frequency_N = ...
                nextpow2((hndl.setting.LDur.modulation.frequencyEnd_P/hndl.setting.LDur.modulation.frequencyStart_P).^hndl.setting.LDur.modulation.frequencyStep_P) + 1;
            hndl.setting.LDur.modulation.mf_V = zeros(1, hndl.setting.LDur.modulation.frequency_N);
            if hndl.setting.LDur.modulation.frequency_N > 1
                for qqq = 1:(hndl.setting.LDur.modulation.frequency_N-1)
                    hndl.setting.LDur.modulation.mf_V(qqq) = ...
                        round(hndl.setting.LDur.modulation.frequencyStart_P*(2.^((qqq-1)/hndl.setting.LDur.modulation.frequencyStep_P))*10)/10;
                end
            end
            hndl.setting.LDur.modulation.mf_V(end) = hndl.setting.LDur.modulation.frequencyEnd_P;
        else
            hndl.setting.LDur.modulation.frequency_N = 1;
            hndl.setting.LDur.modulation.mf_V = hndl.setting.LDur.modulation.frequencyStart_P;
            
        end
    case 3
        
        hndl.setting.Post.modulation.frequencyStep_P = get(obj, 'value');
        
        if hndl.setting.Post.modulation.Num_CK
            
            hndl.setting.Post.modulation.frequency_N = ...
                nextpow2((hndl.setting.Post.modulation.frequencyEnd_P/hndl.setting.Post.modulation.frequencyStart_P).^hndl.setting.Post.modulation.frequencyStep_P) + 1;
            hndl.setting.Post.modulation.mf_V = zeros(1, hndl.setting.Post.modulation.frequency_N);
            if hndl.setting.Post.modulation.frequency_N > 1
                for qqq = 1:(hndl.setting.Post.modulation.frequency_N-1)
                    hndl.setting.Post.modulation.mf_V(qqq) = ...
                        round(hndl.setting.Post.modulation.frequencyStart_P*(2.^((qqq-1)/hndl.setting.Post.modulation.frequencyStep_P))*10)/10;
                end
            end
            hndl.setting.Post.modulation.mf_V(end) = hndl.setting.Post.modulation.frequencyEnd_P;
        else
            hndl.setting.Post.modulation.frequency_N = 1;
            hndl.setting.Post.modulation.mf_V = hndl.setting.Post.modulation.frequencyStart_P;
            
        end
end

set(hndl.mainFig, 'Userdata', hndl);

