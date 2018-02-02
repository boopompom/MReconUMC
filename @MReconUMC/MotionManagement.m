function MotionManagement( MR )
% Function to call all motion-sorting or motion-weighted related functions

%% Logic & display
if strcmpi(MR.UMCParameters.AdjointReconstruction.SoftGating,'no') && isempty(MR.UMCParameters.AdjointReconstruction.RespiratorySorting)
    return;end
 
% Get dimensionality
dims=MR.UMCParameters.AdjointReconstruction.KspaceSize{1};

% Reshape data such that all dynamics are in second dimension
respdata=dynamic_to_spokes(MR.Data{1}(dims(1)/2+1,:,:,:,:,:,:,:,:,:,:));

% Extract respiratory signal from first echo and first data chunk
respiration=extract_resp_signal(squeeze(respdata));



if strcmpi(MR.UMCParameters.AdjointReconstruction.SoftGating,'yes')
    % Get mean navigator and calc difference for each projection
    midp=mean(respiration,1)';
    for n=1:numel(respiration)
        d(n)=abs(midp-respiration(n));end

    % Translate this distance to a data consistency weight
    c1=prctile(d,10); % Threshold to do nothing
    c2=optimize_sgw(d,MR.UMCParameters.AdjointReconstruction.IspaceSize{1}(1),c1); % Parametrize exponential function automatically
    for n=1:numel(respiration)
        if d(n)<= c1
            soft_weights(n)=1;
        else
            soft_weights(n)=exp(-c2*(d(n)-c1));
        end
    end
    
    % Reshape soft-weights to the dynamic stuff and save
    MR.UMCParameters.AdjointReconstruction.SoftWeights=reshape(soft_weights,[1 dims(2) 1 1 dims(5) 1]);
end

if ~isempty(MR.UMCParameters.AdjointReconstruction.RespiratorySorting)
    
    % Preallocate new k-space data/ktraj matrix
    ksp=zeros(size(MR.Data{1}));
    ktraj=zeros(size(MR.Parameter.Gridder.Kpos{1}));
    
    % Reshape MRdata and traj
    MR.Data{1}=dynamic_to_spokes(MR.Data{1});
    MR.Parameter.Gridder.Kpos{1}=dynamic_to_spokes(MR.Parameter.Gridder.Kpos{1});
    
    % Phase sorting
    dt=numel(respiration)/MR.UMCParameters.AdjointReconstruction.RespiratorySorting;
    [~,idx]=sort(respiration);    
    par.respiration=respiration;par.resp_phases=MR.UMCParameters.AdjointReconstruction.RespiratorySorting;par.sort_data='phase';
    idx=sort_data_4D(par);
    
    % Map phase correctly
    for t=1:dims(5)
        ksp(:,:,:,:,t,:,:,:,:,:,:)=MR.Data{1}(:,idx(1+dt*(t-1):t*dt),:,:,:,:,:,:,:,:,:);
        ktraj(:,:,:,:,t,:,:,:,:,:,:)=MR.Parameter.Gridder.Kpos{1}(:,:,idx(1+dt*(t-1):t*dt),:,:,:,:,:,:,:,:);
    end
    
    % Assign again
    MR.Data{1}=ksp;
    MR.Parameter.Gridder.Kpos{1}=ktraj;
    
    clear ktraj ksp
end

% END
end























