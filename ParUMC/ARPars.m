classdef ARPars < dynamicprops & deepCopyable
%Declare all parameters related to the adjoint reconstructions (AR).
% (non-iterative reconstructions)
%
% 20170717 - T.Bruijnen

%% Parameters that are adjustable at configuration
properties
    CoilSensitivityMaps % |YesNo| Estimation of coil sensitivity maps
    IterativeDensityEstimation % |YesNo|
    PrototypeMode % |Integer| Prototyping with fewer dynamics 
    R % |Double| Acceleration factor
    RespiratorySorting % |YesNo|
    SoftGating % |YesNo| 
    SpatialResolution % |Double| Reconstruction voxel size [mm], only for in-plane resolution
end

%% Parameters that are extracted from PPE 
properties ( Hidden )
    Goldenangle % |Integer| Selection of (tiny) golden angles extracted from PPE (1=112 deg)
    IspaceSize % |Cell of arrays| Image space dimensions, extracted from PPE
    KspaceSize % |Cell of arrays| K-space dimensions, extracted from PPE
    SpatialResolutionRatio % |Double| Involved in calculation of trajectory for different resolution
    SoftWeights % |Array| with respiratory motion signal
end

%% Set default values
methods
    function AR = ARPars()   
        AR.CoilSensitivityMaps='no'; % 'no', 'espirit','walsh','refscan'
        AR.Goldenangle=0; % integer [0:1:10] --> 0 is uniform sampling
        AR.IspaceSize=[]; % No input needed
        AR.IterativeDensityEstimation='no';
        AR.KspaceSize=[]; % No input needed
        AR.PrototypeMode=0; % 1-dynamics
        AR.R=1; % Double [1-inf] , note this is not Nyquist R but Cartesian R 
        AR.SpatialResolution=0; % Single double with resolution in [mm]
        AR.SpatialResolutionRatio=[]; % No input needed
        AR.SoftGating='no';
        AR.SoftWeights=[];
        AR.RespiratorySorting='';
    end
end

% END
end
