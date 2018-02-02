function nufft_call = compose_nufft_call(MR,n)
%Create the string that can be passed to the BART nufft functionality.
%
% V20180129 - T.Bruijnen

% Base call
nufft_call='nufft -i -d';

% Dimensions
Id=MR.Parameter.Gridder.OutputMatrixSize{n}(1:3);

% Add recon dimensions
if MR.UMCParameters.IterativeReconstruction.SplitDimension==3
    nufft_call=strcat(nufft_call,[num2str(Id(1)),':',num2str(Id(2)),':',num2str(1)]);
else
    nufft_call=strcat(nufft_call,[num2str(Id(1)),':',num2str(Id(2)),':',num2str(Id(3))]);
end

% END
end
