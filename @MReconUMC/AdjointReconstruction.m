function AdjointReconstruction( MR )
%Perform only the adjoint operation (i.e. non-iterative reconstruction)
% - Nufft structures and dcf operators are initialized and applied.
% - Different handling when reconframe native gridder is selected.
% - dcf operator is performed twice since it is common practice to define
% it as the sqrt(dcf) for iterative reconstructions.
%
% 20170717 - T.Bruijnen

% Logic & display
% If nufft is already performed during csm generation for single dynamic
% reconstructions we dont need to do it a second time.
% Or if you want an iterative reconstruction skip the function completely.
if MR.Parameter.ReconFlags.isgridded==1 || strcmpi(MR.UMCParameters.IterativeReconstruction.IterativeReconstruction,'yes')
    return;end

% Notifcation for display
if ~MR.UMCParameters.ReconFlags.NufftCsmMapping;fprintf(['Initialize operators and do NUFFT ................  ']);tic;end

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
    res=zeros(bart_Id);    

    % Generate bart nufft call
    nufft_call=compose_nufft_call(MR,n);
        
    % Track progress
    parfor_progress(rf_Kd(rf_it_dim));
   
    for p=1:rf_Kd(rf_it_dim) % Loop over "partitions"
        
        % Do inverse NUFFT
        res=dynamic_indexing(res,bart_it_dim,p,bart(nufft_call,...
            ktraj_reconframe_to_bart(dynamic_indexing(MR.Parameter.Gridder.Kpos{n},ktraj_it_dim,p)),...
            ksp_reconframe_to_bart(dynamic_indexing(MR.Data{n},rf_it_dim,p))));
        
        % Track progress
        parfor_progress;
    end
        
        
    MR.Data{n}=isp_bart_to_reconframe(res);
end % Chunks

% Display and reconstruction flags
MR=set_gridding_flags(MR,1);
MR.Parameter.ReconFlags.isoversampled=[1,1,1];
if ~MR.UMCParameters.ReconFlags.NufftCsmMapping;fprintf('Finished [%.2f sec] \n',toc');end

% END
end