function CheckConflicts( MR )
% Check whether certain input parameters have conflicts with each other. 
% For example iterative reconstruction is not possible when no coil
% sensitivity maps are provided. Furthermore it gives a warning when the
% amount of memory required to perform the randomphasecorrection is too
% large. Sometimes it will change the input and continue the
% reconstruction. 
%
% 20180129 - T.Bruijnen

% Logic & display
% Notification
fprintf('Checking for parameter conflicts..................  ');tic;

if strcmpi(MR.Parameter.Scan.UTE,'yes') && strcmpi(MR.UMCParameters.SystemCorrections.Girf,'no')
	fprintf('\n>>>>>>>>>> Warning: Girf corrections are required for UTE!                <<<<<<<<<<\n')
	fprintf('>>>>>>>>>> Change: Trajectory is derived from the GIRFs and waveforms.    <<<<<<<<<<\n')
    MR.UMCParameters.SystemCorrections.Girf='yes';
end

if ~isempty(MR.UMCParameters.AdjointReconstruction.RespiratorySorting)
    MR.UMCParameters.AdjointReconstruction.R=MR.UMCParameters.AdjointReconstruction.RespiratorySorting;
end

if MR.UMCParameters.IterativeReconstruction.SplitDimension==4
    fprintf('\n>>>>>>>>>> Warning: Reconstructions cant be split over the coil dimension. <<<<<<<\n')
	fprintf('>>>>>>>>>> Change: Split dimension set to default (12).                   <<<<<<<<<<\n')
    MR.UMCParameters.IterativeReconstruction.SplitDimension=12;
end

% Check if enough memory is available to reconstruct
[MemoryNeeded, MemoryAvailable, ~] = MR.GetMemoryInformation;
if MemoryNeeded > MemoryAvailable
    fprintf('\n>>>>>>>>>> Warning: Reconstruction will require more memory then you have available. <<<<<<<<<<\n')
end

%% Display
% Notification
fprintf('Finished [%.2f sec]\n',toc')

% END
end
