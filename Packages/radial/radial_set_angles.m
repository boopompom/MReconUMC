function radial_set_angles(MR)
% Function permute/reshapes the data and set radial angles for the nufft
% Todo: Add Kooshball trajectories

% Logic
if ~strcmpi(MR.Parameter.Scan.AcqMode,'Radial')
	return;end

% Get dimensions for data handling
dims=MR.UMCParameters.AdjointReconstruction.KspaceSize;num_data=numel(MR.Data);

% Set radial angles profile ordering for all data chunks
for n=1:num_data;

	% Golden angle spacing
	if MR.UMCParameters.AdjointReconstruction.Goldenangle>0
        d_angle=(pi/(((1+sqrt(5))/2)+MR.UMCParameters.AdjointReconstruction.Goldenangle-1));
        MR.Parameter.Gridder.RadialAngles{n}=mod((0:d_angle:(dims{n}(2)*dims{n}(5)-1)*d_angle),2*pi);
        MR.Parameter.Gridder.RadialAngles{n}=reshape(mod((0:d_angle:(dims{n}(2)*dims{n}(5)-1)*d_angle),2*pi),[1 dims{n}(2) 1 1 dims{n}(5) 1 1 1 1 1 1]);
        MR.Parameter.Gridder.RadialAngles{n}=repmat(MR.Parameter.Gridder.RadialAngles{n},[1 1 1 1 1 1 dims{n}(7) 1 1 1 1 1]);end

	% Uniform radial linear spacing 
	if MR.UMCParameters.AdjointReconstruction.Goldenangle==0;d_angle=pi/(dims{n}(2));
        MR.Parameter.Gridder.RadialAngles{n}=mod((0:d_angle:(dims{n}(2)-1)*d_angle),2*pi);
        MR.Parameter.Gridder.RadialAngles{n}=repmat(MR.Parameter.Gridder.RadialAngles{n},[1 1 1 1 dims{n}(5) 1 dims{n}(7) 1 1 1 1 1]);
        if strcmpi(MR.Parameter.Gridder.AlternatingRadial,'yes');MR.Parameter.Gridder.RadialAngles{n}(:,2:2:end,:,:,:,:,:,:,:,:,:)=...
                mod(MR.Parameter.Gridder.RadialAngles{n}(:,2:2:end,:,:,:,:,:,:,:,:,:)+pi,2*pi);end;end

    % Angle spacing for UTE sequences, uniform for now
    if strcmpi(MR.Parameter.Scan.UTE,'yes') && MR.UMCParameters.AdjointReconstruction.Goldenangle==0;d_angle=2*pi/dims{n}(2);
       MR.Parameter.Gridder.RadialAngles{n}=mod((0:d_angle:(dims{n}(2)-1)*d_angle),2*pi);
       MR.Parameter.Gridder.RadialAngles{n}=repmat(MR.Parameter.Gridder.RadialAngles{n},[1 1 1 1 dims{n}(5) 1 dims{n}(7) 1 1 1 1 1]);end
   
    % Modulate radial angles
    MR.Parameter.Gridder.RadialAngles{n}=mod(MR.Parameter.Gridder.RadialAngles{n},2*pi);
end

% END
end
