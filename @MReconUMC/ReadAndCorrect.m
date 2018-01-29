function ReadAndCorrect( MR )
%Perform the standard data correction functions. Note that ReadData is
% overloaded to differently handle the noise and phase correction
% calibration data.
%
% V20180129 - T.Bruijnen

% Logic and display
% Notification
fprintf('Perform ReadAndCorrect ...........................  ');tic;

%% Large data set handling
% These are loaded and corrected channelwise to prevent freezing during the
% randomphasecorrection steps

% Save default channel indices
ch_idx=MR.Parameter.Parameter2Read.chan;
    
% Calculate number of coils per chunk
chunk_size=ceil(numel(ch_idx)/MR.UMCParameters.GeneralComputing.Chunks);    
    
for chunk=1:MR.UMCParameters.GeneralComputing.Chunks
    
    % Get coil indecis to load
    coil_idx=(chunk-1)*chunk_size+1:chunk*chunk_size;
    
    % Cutoff if exceeds the numel of coils
    coil_idx(coil_idx>numel(ch_idx))=[];
    
    % Check
    if isempty(coil_idx)
        continue;
    end
    
    % Reset correction flags (required for multi-chunk)
    MR=set_corrections_flags(MR,0);
    
    % Assign coil indices
    MR.Parameter.Parameter2Read.chan=ch_idx(coil_idx);
    
    % Reading and correcting steps
    MR.ReadData;
    MR.RandomPhaseCorrection;
    MR.RemoveOversampling;
    MR.PDACorrection;
    MR.DcOffsetCorrection;
    MR.MeasPhaseCorrection;
    
    % Store data in struct
    data{chunk}=permute(MR.Data,[1 3 2]);
    MR.Data=[];
    
end

% Reset parameter2read indices
MR.Parameter.Parameter2Read.chan=ch_idx;

% Order multi-coil data
data=cat(2,data{:});
MR.Data=reshape(data,[size(data,1),size(data,2)*size(data,3)]);

% Change labels
MR.Parameter.LabelLookupTable=numel(ch_idx)+(1:size(MR.Data,2));

% Notification
fprintf('Finished [%.2f sec]\n',toc')

% END
end