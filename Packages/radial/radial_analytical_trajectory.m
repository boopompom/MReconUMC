function radial_analytical_trajectory(MR)
% Does not work for Kooshball type of trajectories 

% Logic
if ~strcmpi(MR.Parameter.Scan.AcqMode,'Radial') || strcmpi(MR.Parameter.Scan.UTE,'yes')
    return;end

% Get dimensions for data handling
dims=MR.UMCParameters.AdjointReconstruction.KspaceSize;num_data=numel(MR.Data);

% Set parameters from input
for n=1:num_data
    if isempty(MR.UMCParameters.SystemCorrections.GradientDelays)
        dk{n}=0;
    else
        dk{n}=repmat(((cos(2*(MR.Parameter.Gridder.RadialAngles{n}+pi/2))+1)*varargin{1}(1)+...
            (-cos(2*(MR.Parameter.Gridder.RadialAngles{n}{n}+pi/2))+1)*varargin{1}(2))/2,[dims{n}(1) 1]);
    end
end

% Compute trajectory based on angles
for n=1:num_data

    % Save radial angles dimensions
    dims_angles=size(MR.Parameter.Gridder.RadialAngles{n});dims_angles(end+1:13)=1;
    
    % Calculate sampling point on horizontal spoke
    x=linspace(0,dims{n}(1)-1,dims{n}(1)+1)'-(dims{n}(1)-1)/2;x(end)=[];

    % Modulate the phase of all the successive spokes
    k{n}=zeros([dims{n}(1),dims_angles(2:end)]);
    for ech=1:dims_angles(6)
        for dyn=1:dims_angles(4)
            for l=1:dims_angles(2)
                k{n}(:,l,:,dyn,:,ech)=(-1)^(ech+1)*x*exp(1j*MR.Parameter.Gridder.RadialAngles{n}(:,l,:,dyn,:,ech));
            end
        end
    end

    % Add correction based on gradient delays
    k{n}=k{n}+(-1)*dk{n};

    % Normalize
    k{n}=k{n}/dims{n}(1);

    % Split real and imaginary parts into channels & scale for bart
    kn{n}=zeros([3,size(k{n})],'single');
    kn{n}(1,:,:,:,:,:,:,:,:,:,:,:)=imag(k{n})*MR.Parameter.Gridder.OutputMatrixSize{n}(1);
    kn{n}(2,:,:,:,:,:,:,:,:,:,:,:)=real(k{n})*MR.Parameter.Gridder.OutputMatrixSize{n}(2);
        
    % Stack of stars trajectory for 3D gridding
    if strcmpi(MR.Parameter.Scan.ScanMode,'3D') && MR.UMCParameters.IterativeReconstruction.SplitDimension~=3              
        if mod(dims{n}(3),2)>0 % is uneven
            kz=linspace(-.5,0.5,dims{n}(3));
        else % is even
            kz=linspace(-.5,0.5,dims{n}(3)+1);kz(end)=[];
        end
        repdim=[1 dims{n}];repdim([4 5])=1;
        kn{n}=repmat(kn{n},[1 1 1 dims{1}(3)]);
        kn{n}(3,:,:,:,:,:,:,:,:,:,:)=repmat(permute(kz,[1 3 4 2]),repdim)*MR.Parameter.Gridder.OutputMatrixSize{n}(3);
    end
    
    % Store traj
    MR.Parameter.Gridder.Kpos{n}=kn{n};
    
end

% Crop k-space for lower resolution reconstruction 
if ~isempty(MR.UMCParameters.AdjointReconstruction.SpatialResolutionRatio)
    if max(MR.UMCParameters.AdjointReconstruction.SpatialResolutionRatio)>1
        for n=1:numel(MR.Data)
            % Determine cut-off samples
            thresh=round(.5*dims{n}(1)*(1/MR.UMCParameters.AdjointReconstruction.SpatialResolutionRatio(1)));
            
            % Cut off data and trajectory
            MR.Data{n}=MR.Data{n}(thresh+1:end-thresh,:,:,:,:,:,:,:,:,:,:,:);
            MR.Parameter.Gridder.Kpos{n}=MR.Parameter.Gridder.Kpos{n}(:,thresh+1:end-thresh,:,:,:,:,:,:,:,:,:,:);
            
            % Scale trajectory with ratio
            MR.Parameter.Gridder.Kpos{n}([1 2],:,:,:,:,:,:,:,:,:)=MR.Parameter.Gridder.Kpos{n}([1 2],:,:,:,:,:,:,:,:,:)*MR.UMCParameters.AdjointReconstruction.SpatialResolutionRatio(1);
            MR.UMCParameters.AdjointReconstruction.KspaceSize{n}(1)=numel(thresh+1:dims{n}(1)-thresh);
        end
    end
end


% END
end