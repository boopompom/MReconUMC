function MotionManagement( MR )
% Function to call all motion-sorting or motion-weighted related functions

%% Logic & display
if strcmpi(MR.UMCParameters.AdjointReconstruction.SoftGating,'no')
    return;end
 
% Get dimensionality
dims=MR.UMCParameters.AdjointReconstruction.KspaceSize{1};

% Reshape data such that all dynamics are in second dimension
respdata=permute(reshape(permute(MR.Data{1}(dims(1)/2+1,:,:,:,:,:,:,:,:,:,:,:),[1 3 4 6:12 2 5]),...
    [1 dims(3) dims(4) 1 dims(6:12) dims(2)*dims(5) 1]),[1 12 2:11]);
        
% Extract respiratory signal from first echo and first data chunk
respiration=extract_resp_signal(squeeze(respdata));

% Get median navigator and calc difference for each projection
midp=mean(respiration,1)';
for n=1:numel(respiration)
    d(n)=abs(midp-respiration(n));end

% Translate this distance to a data consistency weight
c1=.08; % Threshold to do nothing
c2=5; % Parametrize exponential function
for n=1:numel(respiration)
    if d(n)<= c1
        soft_weights(n)=1;
    else
        soft_weights(n)=exp(-c2*d(n));
    end
end

% Reshape soft-weights to the dynamic stuff and save
MR.UMCParameters.AdjointReconstruction.SoftWeights=reshape(soft_weights,[1 dims(2) 1 1 dims(5) 1]);

% END
end
