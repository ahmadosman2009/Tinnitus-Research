function PCriteria_ED_prs(obj, evt)

hndl = get(gcf, 'Userdata');

tmpV = round(str2double(get(obj, 'String')));

if tmpV > 6
else
    hndl.setting.criteria.NCriteria = tmpV;
    set(hndl.postreviewFig, 'Userdata', hndl);

    set(hndl.uicontrol.control.NUI_ED(1:tmpV, :), 'Visible', 'on');

    if tmpV < 6
        set(hndl.uicontrol.control.NUI_ED(tmpV+1:end, :), 'Visible', 'off');
    end
end
