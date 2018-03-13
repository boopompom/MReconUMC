function SystemCorrections( MR )
%System corrections such as noise prewhitening and phase corrections are
% adressed in this routine.
%
% V20180129 - T.Bruijnen

% Notification
fprintf('Applying system corrections ......................  \n');tic


% Do 1D fft in z-direction for stack-of-stars if 2D nufft is used
if (strcmpi(MR.Parameter.Scan.ScanMode,'3D') && MR.UMCParameters.IterativeReconstruction.SplitDimension==3)
    
    if mod(MR.UMCParameters.AdjointReconstruction.IspaceSize{1}(3),2)>0
        MR.Data=cellfun(@(v) ifft(ifftshift(v,3),MR.UMCParameters.AdjointReconstruction.IspaceSize{1}(3),3),MR.Data,'UniformOutput',false); 
    else
        MR.Data=cellfun(@(v) ifft(v,MR.UMCParameters.AdjointReconstruction.IspaceSize{1}(3),3),MR.Data,'UniformOutput',false); 
    end
    
    for n=1:numel(MR.Data);MR.UMCParameters.AdjointReconstruction.KspaceSize{n}(3)=MR.UMCParameters.AdjointReconstruction.IspaceSize{n}(3);end
	MR.Parameter.ReconFlags.isimspace=[0,0,1];     
end

% Radial phase correction functions
radial_phasecorrection(MR);

% Scale k-space data to kmax = 0.02
for n=1:numel(MR.Data)
    MR.Data{n}=MR.Data{n}/max(MR.Data{n}(:));
end


%END
end
