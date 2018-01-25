function reconframe_sensitivity_mapping( MR )
%Estimate coil sensitivity maps from the sense refscan according to the
%reconframe manual. This routine has not been extensively tested!
%
% 20170717 - T.Bruijnen

%% Logic & display
if ~strcmpi(MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps,'refscan')
	return;end

%% reconframe_sensitivity_mapping
% Get locations of CSC/SRS 
listCSC=dir([MR.UMCParameters.GeneralComputing.DataRoot,'/CSC/','*.lab']);
locCSC=[MR.UMCParameters.GeneralComputing.DataRoot,'/CSC/',listCSC.name];
listSRS=dir([MR.UMCParameters.GeneralComputing.DataRoot,'/SRS/','*.lab']);
locSRS=[MR.UMCParameters.GeneralComputing.DataRoot,'/SRS/',listSRS.name];

% Load in the MRecon objects of them
srs=MRecon(locSRS);
csc=MRecon(locCSC);

% Reload original data, because MR doesnt work for some reason
list=dir([MR.UMCParameters.GeneralComputing.TemporateWorkingDirectory,'/','*.lab']);
T=MRecon([MR.UMCParameters.GeneralComputing.TemporateWorkingDirectory,'/',list.name]);

% Perform the regular MRsense stuff
S=MRsense(srs,T,csc);
%clear srs T csc
S.Mask=1;
S.Smooth=1;
S.Extrapolate=1;
S.MatchTargetSize=1;
S.RemoveMOversampling=1;
S.OutputSizeSensitivity=[MR.Parameter.Gridder.OutputMatrixSize{1}(1:3),1];
S.OutputSizeReformated=[MR.Parameter.Gridder.OutputMatrixSize{1}(1:3),1];
S.Perform;

% Save the coil maps after they are normalized
csm=S.Sensitivity;
if size(csm) > 3
    csm=flip(csm,3);
end
csm=csm/max(abs(csm(:)));

% Add noise to coil maps 0 points
% b=rand(size(csm));
% csm(~logical(abs(csm)))=single(b(~logical(abs(csm))));

% If radial phase correction is forced map it also to the csm
dims=size(csm);
for c=1:size(csm,4)    
    csm(:,:,:,c)=csm(:,:,:,c)*exp(-1j*angle(csm(dims(1)/2,dims(2)/2,dims(3)/2,c)));
end

% Assign coil maps to adequate structure
MR.Parameter.Recon.Sensitivities=csm;

% Define sensitivity operator
MR.UMCParameters.Operators.S=CC({MR.Parameter.Recon.Sensitivities});

%% Display
% Notification
fprintf('Finished [%.2f sec]\n',toc')

% END
end