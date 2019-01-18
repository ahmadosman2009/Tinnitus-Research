function clickModulation_prs(obj, evt, stage)

hndl = get(gcf, 'Userdata');
hndl = get(hndl.mainFig, 'Userdata');

switch stage
    case 1

%         freq = 1000/(str2double(get(hndl.uicontrol.Pre.modulation.clickHigh, 'string')) + ...
% %                  str2double(get(hndl.uicontrol.Pre.modulation.clickLow,'string')));
% %              
%         hndl.setting.Post.modulation.clickLow =  hndl.setting.Pre.modulation.clickLow;
%         hndl.setting.Post.modulation.clickLow =  hndl.setting.Pre.modulation.clickLow;
% 

% hndl.uicontrol.Post.modulation.clickModulation = str2double(get(obj, 'String'));

    case 2
%         hndl.setting.LDur.duration.sPerSignal = str2double(get(obj, 'String'));
%         
%         set(hndl.uicontrol.LDur.duration.SecBlock_ED, 'String', ...
%             hndl.setting.LDur.duration.NumBlock *(hndl.setting.LDur.duration.sPerSignal + hndl.setting.LDur.duration.sPerSilence));
    case 3
%          freq = 1000/(str2double(get(hndl.uicontrol.Pre.modulation.clickHigh, 'string')) + ...
%                  str2double(get(hndl.uicontrol.Pre.modulation.clickLow,'string')));
%              
%          set(hndl.uicontrol.Post.modulation.clickModulation, 'String',['Mod Freq = ' num2str(freq)]);

end

set(hndl.mainFig, 'Userdata', hndl);