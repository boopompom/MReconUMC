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
     fprintf('No coil maps pre-calculated.......................  ');tic;
     fprintf('Finished [%.2f sec]\n',toc');return;end

% Sense refscan method, creates sensitivity operator internaly and returns function afterwards.
if strcmpi(MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps,'refscan');
    reconframe_sensitivity_mapping(MR);return;end

% Notification        
fprintf('     Estimation of sensitivities..................  ');tic; 

% Estimate the coil sensitivities with ESPIRiT
if strcmpi(MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps,'espirit')
for n=1:numel(MR.Data)
     % Short variables for reconframe dimensions
    rf_Kd=MR.UMCParameters.AdjointReconstruction.KspaceSize{n};
    rf_Id=[MR.Parameter.Gridder.OutputMatrixSize{n}(1:3) MR.UMCParameters.AdjointReconstruction.IspaceSize{n}(4:end)];
    rf_it_dim=MR.UMCParameters.IterativeReconstruction.SplitDimension;
    
    % Different index for k-space trajectory [3 nx ns nz dyn] instead of [nx ns nz nc dyn]
    ktraj_it_dim=rf_it_dim;    
    if rf_it_dim < 5;ktraj_it_dim=ktraj_it_dim+1;end
    
    % Short variables for BART dimensions
    bart_Id=dim_reconframe_to_bart(rf_Id);
    bart_it_dim=dim_reconframe_to_bart(rf_it_dim);

    % Preallocate output
    MR.Parameter.Recon.Sensitivities{n}=zeros(bart_Id(1:4)); 

    % Track progress
    parfor_progress(rf_Kd(rf_it_dim));

    for p=1:rf_Kd(rf_it_dim) % Loop over "partitions"
        
        % Dimensions to pass to espirit
        esp_Id=bart_Id;esp_Id(bart_it_dim)=1;esp_Id(11)=1;
        
        % ESPIRiT
        MR.Parameter.Recon.Sensitivities{n}=dynamic_indexing(MR.Parameter.Recon.Sensitivities{n},rf_it_dim,p,...
            espirit(ktraj_reconframe_to_bart(dynamic_indexing(dynamic_to_spokes(MR.Parameter.Gridder.Kpos{n}),ktraj_it_dim,p)),...
            ksp_reconframe_to_bart(dynamic_indexing(dynamic_to_spokes(MR.Data{n}),rf_it_dim,p)),esp_Id));
        
        % Track progress
        parfor_progress;
    end
end
end

% Display
% Notification
fprintf('Finished [%.2f sec]\n',toc')

% END
end