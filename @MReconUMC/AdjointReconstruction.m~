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
    
% Short variable
Kd=MR.UMCParameters.AdjointReconstruction.KspaceSize{n};
Id=[MR.Parameter.Gridder.OutputMatrixSize{n}(1:3) MR.UMCParameters.AdjointReconstruction.IspaceSize{n}(4:end)];

% Preallocate output
res=zeros(Id);
    
for avg=1:Kd(12) % Averages
for ex2=1:Kd(11) % Extra2
for ex1=1:Kd(10) % Extra1
for mix=1:Kd(9)  % Locations
for loc=1:Kd(8)  % Mixes
for ech=1:Kd(7)  % Echos
for ph=1:Kd(6)   % Phases
for dyn=1:Kd(5)  % Dynamics
    % Per slice
    if MR.UMCParameters.IterativeReconstruction.SplitDimension==3 || strcmpi(MR.Parameter.Scan.ScanMode,'2D')
        for z=1:Kd(3)
            res(:,:,z,:,dyn,ph,ech,loc,mix,ex1,ex2,avg)=bart(['nufft -i -d', num2str(Id(1)),':',num2str(Id(2)),':',num2str(1)],...
                MR.Parameter.Gridder.Kpos{n}(:,:,:,:,:,dyn,ph,ech,loc,mix,ex1,ex2,avg),...
                reconframe_to_bart(MR.Data{n}(:,:,z,:,dyn,ph,ech,loc,mix,ex1,ex2,avg)));end
    else % Per Volume
            res(:,:,:,:,dyn,ph,ech,loc,mix,ex1,ex2,avg)=bart(['nufft -i -d', num2str(Id(1)),':',num2str(Id(2)),':',num2str(Id(3)),' -t'],...
                MR.Parameter.Gridder.Kpos{n}(:,:,:,:,:,dyn,ph,ech,loc,mix,ex1,ex2,avg),...
                reconframe_to_bart(MR.Data{n}(:,:,:,:,dyn,ph,ech,loc,mix,ex1,ex2,avg)));       
    end
end % Dynamics
end % Echos
end % Phases
end % Mixes
end % Locations
end % Extra1
end % Extra2
end % Averages
MR.Data{n}=res;
end % Chunks

% Display and reconstruction flags
MR=set_gridding_flags(MR,1);
MR.Parameter.ReconFlags.isoversampled=[1,1,1];
if ~MR.UMCParameters.ReconFlags.NufftCsmMapping;fprintf('Finished [%.2f sec] \n',toc');end

% END
end