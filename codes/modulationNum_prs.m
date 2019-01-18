function modulationNum_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    
    case 1        
        hndl.setting.Pre.modulation.Num_CK = get(obj, 'Value');
        
        if hndl.setting.Pre.modulation.Num_CK
            if (hndl.setting.Pre.modulation.frequencyEnd_P < hndl.setting.Pre.modulation.frequencyStart_P)
                hndl.setting.Pre.modulation.frequencyEnd_P = hndl.setting.Pre.modulation.frequencyStart_P;
                set(hndl.uicontrol.Pre.modulation.modulationFrequencyEnd_ED, 'String', hndl.setting.Pre.modulation.frequencyEnd_P);
            end
            
            set(hndl.uicontrol.Pre.modulation.modulationFrequencyEnd_TX, 'Visible', 'on');
            set(hndl.uicontrol.Pre.modulation.modulationFrequencyEnd_ED, 'Visible', 'on');
            set(hndl.uicontrol.Pre.modulation.modulationFrequencyStep_TX, 'Visible', 'on');
            set(hndl.uicontrol.Pre.modulation.modulationFrequencyStep_PU, 'Visible', 'on');
            
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
            
            set(hndl.uicontrol.Pre.modulation.modulationFrequencyEnd_TX, 'Visible', 'off');
            set(hndl.uicontrol.Pre.modulation.modulationFrequencyEnd_ED, 'Visible', 'off');
            set(hndl.uicontrol.Pre.modulation.modulationFrequencyStep_TX, 'Visible', 'off');
            set(hndl.uicontrol.Pre.modulation.modulationFrequencyStep_PU, 'Visible', 'off');
        end
        
        hndl.setting.Post.modulation.Num_CK = hndl.setting.Pre.modulation.Num_CK;
        set(hndl.uicontrol.Post.modulation.modulationNum_CK, 'Value', hndl.setting.Post.modulation.Num_CK);
        
        if hndl.setting.Post.modulation.Num_CK
            set(hndl.uicontrol.Post.modulation.modulationFrequencyEnd_TX, 'Visible', 'on');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyEnd_ED, 'Visible', 'on');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyStep_TX, 'Visible', 'on');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyStep_PU, 'Visible', 'on');
        else
            
            set(hndl.uicontrol.Post.modulation.modulationFrequencyEnd_TX, 'Visible', 'off');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyEnd_ED, 'Visible', 'off');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyStep_TX, 'Visible', 'off');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyStep_PU, 'Visible', 'off');
        end
        hndl.setting.Post.modulation.frequency_N = hndl.setting.Pre.modulation.frequency_N;
        hndl.setting.Post.modulation.mf_V = hndl.setting.Pre.modulation.mf_V;
    
    case 2        
        hndl.setting.LDur.modulation.Num_CK = get(obj, 'Value');
        
        if hndl.setting.LDur.modulation.Num_CK
            if (hndl.setting.LDur.modulation.frequencyEnd_P < hndl.setting.LDur.modulation.frequencyStart_P)
                hndl.setting.LDur.modulation.frequencyEnd_P = hndl.setting.LDur.modulation.frequencyStart_P;
                set(hndl.uicontrol.LDur.modulation.modulationFrequencyEnd_ED, 'String', hndl.setting.LDur.modulation.frequencyEnd_P);
            end
            
            set(hndl.uicontrol.LDur.modulation.modulationFrequencyEnd_TX, 'Visible', 'on');
            set(hndl.uicontrol.LDur.modulation.modulationFrequencyEnd_ED, 'Visible', 'on');
            set(hndl.uicontrol.LDur.modulation.modulationFrequencyStep_TX, 'Visible', 'on');
            set(hndl.uicontrol.LDur.modulation.modulationFrequencyStep_PU, 'Visible', 'on');
            
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
            
            set(hndl.uicontrol.LDur.modulation.modulationFrequencyEnd_TX, 'Visible', 'off');
            set(hndl.uicontrol.LDur.modulation.modulationFrequencyEnd_ED, 'Visible', 'off');
            set(hndl.uicontrol.LDur.modulation.modulationFrequencyStep_TX, 'Visible', 'off');
            set(hndl.uicontrol.LDur.modulation.modulationFrequencyStep_PU, 'Visible', 'off');
        end
    
    case 3        
        hndl.setting.Post.modulation.Num_CK = get(obj, 'Value');
        
        if hndl.setting.Post.modulation.Num_CK
            if (hndl.setting.Post.modulation.frequencyEnd_P < hndl.setting.Post.modulation.frequencyStart_P)
                hndl.setting.Post.modulation.frequencyEnd_P = hndl.setting.Post.modulation.frequencyStart_P;
                set(hndl.uicontrol.Post.modulation.modulationFrequencyEnd_ED, 'String', hndl.setting.Post.modulation.frequencyEnd_P);
            end
            
            set(hndl.uicontrol.Post.modulation.modulationFrequencyEnd_TX, 'Visible', 'on');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyEnd_ED, 'Visible', 'on');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyStep_TX, 'Visible', 'on');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyStep_PU, 'Visible', 'on');
            
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
            
            set(hndl.uicontrol.Post.modulation.modulationFrequencyEnd_TX, 'Visible', 'off');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyEnd_ED, 'Visible', 'off');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyStep_TX, 'Visible', 'off');
            set(hndl.uicontrol.Post.modulation.modulationFrequencyStep_PU, 'Visible', 'off');
        end
end

set(hndl.mainFig, 'Userdata', hndl);

