classdef IRPars < dynamicprops & deepCopyable
%Declare all parameters related to the iterative reconstructions (IR).
% Some extra eplanation about the TV operator. The parameters
% TVDimension and TVLambda govern the creation of the corresponding Total
% Variation operator. TVDimension is a cell with arrays for each data
% chunk. So if you have one data chunk it look like this ..={[1 3 0 0 2]},
% which means perform a first order finite difference on the x dimension, a
% linear combination of first and second order difference on the y
% dimension and a second order difference on the 5th dimensions (dynamics).
% The Lambda parameter has the same size and governs the weights for all
% the operations. Both parameters are eventually combined into one large
% sparse matrix to calculate the total TV.
% 
% 20170717 - T.Bruijnen

%% Parameters that are adjustable at configuration
properties
    IterativeReconstruction % |YesNo| for iterative reconstruction
    PotentialFunction % |Integer| 1=l1-norm, 2=l2-norm 
    SplitDimension % |Integer| Dimension where to split the reconstruction on. 3=per z, 5=per dynamics
    TVLambda % |Cell of arrays| Array with corresponding weights for each TV dimension
    WaveletLambda % |Double| Corresponding Wavelet weight
    Optimizer % |String| 'FISTA' or 'ADMM' or 'Primal Dual'
    MaxIterations % |Integer| number of outter iterations
    MaxInnerIterations % |Integer| number of inner iterations (ADMM)
    CGLambda % |Double| lambda for cg in ADMM or primal dual
    
end

%% Set default values
methods
    function IR = IRPars()   
        IR.TVLambda='';
        IR.PotentialFunction='1'; 
        IR.SplitDimension=12; 
        IR.IterativeReconstruction='no';
        IR.WaveletLambda='';
        IR.Optimizer='';
        IR.MaxIterations='';
        IR.MaxInnerIterations='';
        IR.CGLambda='';
    end
end

% END
end
