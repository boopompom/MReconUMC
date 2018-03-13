function IterativeReconstruction( MR )

% Logic & display
if ~strcmpi(MR.UMCParameters.IterativeReconstruction.IterativeReconstruction,'yes')
    return;end

% Notifcation for display
fprintf('Iterative reconstruction..........................  ');tic;

for n=1:numel(MR.Data)
    
    % Short variables for reconframe dimensions
    rf_Kd=MR.UMCParameters.AdjointReconstruction.KspaceSize{n};
    rf_Id=[MR.Parameter.Gridder.OutputMatrixSize{n}(1:3) 1 MR.UMCParameters.AdjointReconstruction.IspaceSize{n}(5:end)];
    rf_it_dim=MR.UMCParameters.IterativeReconstruction.SplitDimension;
    
    % Different index for k-space trajectory [3 nx ns nz dyn] instead of [nx ns nz nc dyn]
    ktraj_it_dim=rf_it_dim;    
    if rf_it_dim < 5;ktraj_it_dim=ktraj_it_dim+1;end
    
    % Short variables for BART dimensions
    bart_Id=dim_reconframe_to_bart(rf_Id);
    bart_it_dim=dim_reconframe_to_bart(rf_it_dim);

    % Preallocate output
    res=zeros(bart_Id);    
    
    % Generate bart pics call
    pics_call=compose_pics_call(MR);
    
    % Calculate coil maps on the fly if not pre-calculated
    calc_csm=0;
    if isempty(MR.Parameter.Recon.Sensitivities)
        calc_csm=1;
        esp_Id=bart_Id;esp_Id(bart_it_dim)=1;esp_Id(11)=1;esp_Id(4)=rf_Kd(4);end
    
    % Track progress
    parfor_progress(rf_Kd(rf_it_dim));
    
    for p=1:rf_Kd(rf_it_dim) % Loop over "partitions"
%         
%          if p~=25
%             continue;
%          end
        if calc_csm
            csm=espirit(ktraj_reconframe_to_bart(dynamic_indexing(dynamic_to_spokes(MR.Parameter.Gridder.Kpos{n}),ktraj_it_dim,p)),...
                ksp_reconframe_to_bart(dynamic_indexing(dynamic_to_spokes(MR.Data{n}),rf_it_dim,p)),esp_Id);
        else
            csm=isp_reconframe_to_bart(dynamic_indexing(MR.Parameter.Recon.Sensitivities{n},rf_it_dim,p));
        end

        % Do iterative reconstruction
        res=dynamic_indexing(res,bart_it_dim,p,bart(pics_call,...
            ktraj_reconframe_to_bart(dynamic_indexing(MR.Parameter.Gridder.Kpos{n},ktraj_it_dim,p)),...
            ksp_reconframe_to_bart(dynamic_indexing(MR.Data{n},rf_it_dim,p)),...
            csm));
        
        % Track progress
        parfor_progress;
    end

    % Reformat back to reconframe dimensions
    MR.Data{n}=isp_bart_to_reconframe(res);
    
end % Chunks

% Display and reconstruction flags
MR=set_gridding_flags(MR,1);
MR.Parameter.ReconFlags.isoversampled=[1,1,1];
if ~MR.UMCParameters.ReconFlags.NufftCsmMapping;fprintf('Finished [%.2f sec] \n',toc');end

% END
end