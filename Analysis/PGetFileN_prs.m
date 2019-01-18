function PGetFileN_prs(obj, evt, vv)

hndl = get(gcf, 'Userdata');

switch vv
    case 1
        [FileN, PathN] = uigetfile('*.rst', 'Select the Root file', [hndl.general.file.PathN '\a.rst']);

        if isequal(FileN, 0)
            disp('No file selected');
        else
            fnm = fullfile(PathN, FileN);
            hndl.general.setting.mf = getTXT(fnm, 4);
            hndl.general.setting.LV = getTXT(fnm, 8);
            hndl.general.setting.CF = getTXT(fnm, 6);
            
            FileN = strrep(FileN, 'Data.rst', '');

            hndl.general.file.FileN = FileN;
            hndl.general.file.PathN = PathN;

            set(hndl.uicontrol.control.FileName, 'String', hndl.general.file.FileN);
            set(hndl.uicontrol.control.PathName, 'String', hndl.general.file.PathN);

            set(hndl.postreviewFig, 'Userdata', hndl);
        end
    case 2
        hndl.general.file.FileN = get(obj, 'String');

        set(hndl.postreviewFig, 'Userdata', hndl);
    case 3
        hndl.general.file.PathN = get(obj, 'String');

        set(hndl.postreviewFig, 'Userdata', hndl);
end
