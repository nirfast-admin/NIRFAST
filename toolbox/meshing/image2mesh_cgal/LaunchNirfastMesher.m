function LaunchNirfastMesher(inrfn)
% This is called from Nirview application to create mesh using segemented
% images that are saved in Nirview (in .mha format)

% change directory so we are not in Nirview's bin folder
cd(getuserdir);

% Strip the {} from input .mha file name
inrfn=inrfn(2:end-1);

% Launch the GUI for mesher
h=image2mesh_gui;
data=guidata(h);
data.inputfn=inrfn;
guidata(h,data);
image2mesh_gui('UpdateInputFileInfo',h,[],data);
% data=guidata(h);
% image2mesh_gui('callimage2mesh_cgal_Callback',h,[],data);

