function pics_call = compose_pics_call(MR)
%Create the string that can be passed to the BART pics functionality.
%
% V20180129 - T.Bruijnen

pics_call='pics -e ';

% Wavelet regularization
if ~isempty(MR.UMCParameters.IterativeReconstruction.WaveletLambda)
    pics_call=strcat(pics_call,[' -r',num2str(MR.UMCParameters.IterativeReconstruction.WaveletLambda)]);
end

% Total variation regularization
if ~isempty(MR.UMCParameters.IterativeReconstruction.TVLambda)
    % Create bitmask depending on the dimensions
    tv_idx=find(dim_reconframe_to_bart(MR.UMCParameters.IterativeReconstruction.TVLambda)>0);
    bm=@(x)(sum(2.^x));
   
    pics_call=strcat(pics_call,[' -R T:',num2str(bm(tv_idx-1)),':0:',...
        num2str(max(MR.UMCParameters.IterativeReconstruction.TVLambda))]);
end

% Change number of iterations
if ~isempty(MR.UMCParameters.IterativeReconstruction.MaxIterations)
    pics_call=strcat(pics_call,[' -i',num2str(MR.UMCParameters.IterativeReconstruction.MaxIterations)]);
end

% Potential function (l1/l2 wavelet)
pics_call=strcat(pics_call,[' -l',num2str(MR.UMCParameters.IterativeReconstruction.PotentialFunction)]);

% Add trajectory 
if ~isempty(MR.Parameter.Gridder.Kpos)
    pics_call=strcat(pics_call,' -t');
end
% END
end
