function CoilSensitivityMaps( MR )
%Estimate coil sensitivity maps either from the refscan, espirit or the
% walsh method. Espirit only works for (m)2D and not for 3D.
% Espirit and Walsh are autocalibrated methods and their its beneficial to
% combine reconstruct multiple dynamics together to enhance the quality of 
% the coil maps. Therefore the data is differently organized to perform the 
% gridding step needed for the csm mapping. This is regulated in the
% function csm_handle_labels_and_settings which temporary adjust the data
% dimensions. No option is available at the moment to estimate csm maps for
% multiple dynamics. The parameter AdjointReconstruction.LoadCoilSensitivityMaps
% allows the use of the coil maps from the previous reconstruction.
%
% V20180129 - T.Bruijnen

% Logic & display
if strcmpi(MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps,'no')
     fprintf('No coil maps used ................................  ');tic;
     fprintf('Finished [%.2f sec]\n',toc');return;end

% Sense refscan method, creates sensitivity operator internaly and returns function afterwards.
if strcmpi(MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps,'refscan');reconframe_sensitivity_mapping(MR);return;end

% Notification        
fprintf('     Estimation of sensitivities..................  ');tic; 

% Estimate the coil sensitivities with the Walsh method
espirit(MR);

%% Display
% Notification
fprintf('Finished [%.2f sec]\n',toc')

% END
end