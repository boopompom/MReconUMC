function set_geometry_parameters( MR )

% Get dimensions for data handling
dims=cellfun(@size,MR.Data,'UniformOutput',false);num_data=numel(dims);
for n=1:num_data;dims{n}(numel(size(MR.Data{n}))+1:12)=1;end % Up to 12D
MR.UMCParameters.AdjointReconstruction.KspaceSize=dims;
MR.UMCParameters.AdjointReconstruction.IspaceSize=dims;

% If 2D create Zres = 1 
if isempty(MR.Parameter.Encoding.ZRes)
    MR.Parameter.Encoding.ZRes=1;MR.Parameter.Encoding.ZReconRes=1;MR.Parameter.Encoding.KzOversampling=1;end

% Change resolution settings for XYZ
if ~isempty(MR.UMCParameters.AdjointReconstruction.SpatialResolution)
   
   % Short variable for new matrix size
   xyz_old=[MR.Parameter.Encoding.XRes MR.Parameter.Encoding.YRes MR.Parameter.Encoding.ZRes];
   xyz=round(xyz_old.*MR.Parameter.Scan.AcqVoxelSize./MR.UMCParameters.AdjointReconstruction.SpatialResolution);
    
   % Resolution ratio to crop k-space for subsampling
   MR.UMCParameters.AdjointReconstruction.SpatialResolutionRatio=MR.UMCParameters.AdjointReconstruction.SpatialResolution./MR.Parameter.Scan.AcqVoxelSize;
   
    % XY    
   if xyz(1) > xyz_old(1) % Zerofilling
        MR.Parameter.Encoding.XReconRes=xyz(1);
        MR.Parameter.Encoding.YReconRes=xyz(2);
   else % FT to lower res
       MR.Parameter.Encoding.XRes=xyz(1);
       MR.Parameter.Encoding.YRes=xyz(2);
   end
   
   % Z
   if xyz(3) > xyz_old(3) % Zerofilling
       MR.Parameter.Encoding.ZReconRes=xyz(3);
   else
       MR.Parameter.Encoding.ZRes=xyz(3);
   end      
end

% Set reconstruction parameters accordingly
MR.Parameter.Scan.Samples(2)=size(MR.Data{1},2);
MR.Parameter.Parameter2Read.ky=(0:size(MR.Data{1},2)-1)';
MR.Parameter.Encoding.KyRange=[0 size(MR.Data{1},2)-1];
MR.Parameter.Parameter2Read.dyn=(0:size(MR.Data{1},5)-1)';

% Store k-space and image dimensions in struct and gridder outputsize
for n=1:numel(MR.Data);MR.UMCParameters.AdjointReconstruction.IspaceSize{n}(1:3)=[MR.Parameter.Encoding.XRes(n),...
        MR.Parameter.Encoding.YRes(n),round(MR.Parameter.Encoding.ZRes(n)*MR.Parameter.Encoding.KzOversampling(n))];end
for n=1:numel(MR.Data);MR.Parameter.Gridder.OutputMatrixSize{n}=MR.UMCParameters.AdjointReconstruction.IspaceSize{n}(1:3);end

% Adjust oversampling slightly, must have even numbered matrix size
for n=1:numel(MR.Data);MR.Parameter.Encoding.KxOversampling(n)=MR.Parameter.Gridder.OutputMatrixSize{n}(1)/MR.Parameter.Encoding.XRes(n);
    MR.Parameter.Encoding.KyOversampling(n)=MR.Parameter.Gridder.OutputMatrixSize{n}(2)/MR.Parameter.Encoding.YRes(n);end

% END
end