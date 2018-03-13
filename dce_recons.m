
%% Setup path and select root of data
clear all;clc;clear classes;close all;restoredefaultpath
addpath(genpath('/nfs/bsc01/researchData/USER/tbruijne/Projects_Software/Reconframe/MRecon-3.0.553/'))
addpath(genpath('/local_scratch/tbruijne/BART/MReconUMCBART'))
cd('/local_scratch/tbruijne/BART/MReconUMCBART');
addpath(fullfile('/local_scratch/tbruijne/BART/bart-0.4.02/','matlab'));
setenv('TOOLBOX_PATH','/local_scratch/tbruijne/BART/bart-0.4.02/');
root='/local_scratch/tbruijne/WorkingData/DCE/';
scan=1;

%% 13 spokes
clear MR
MR=MReconUMC(root,scan);
MR.Parameter.Parameter2Read.ky=MR.Parameter.Parameter2Read.ky(1:1040);
MR.UMCParameters.IterativeReconstruction.IterativeReconstruction='yes';
MR.UMCParameters.IterativeReconstruction.TVLambda=[0 0 0 0 0.01 0 ];
MR.UMCParameters.IterativeReconstruction.WaveletLambda=0.005;
MR.UMCParameters.IterativeReconstruction.SplitDimension=3;
MR.UMCParameters.IterativeReconstruction.MaxIterations=300;
MR.UMCParameters.AdjointReconstruction.R=80;
MR.PerformUMC;

dat_13sp=MR.Data;
save([root,'Scan1.mat'],'dat_13sp');
clear dat_13sp

%% 21 spokes
clear MR
MR=MReconUMC(root,scan);
MR.Parameter.Parameter2Read.ky=MR.Parameter.Parameter2Read.ky(1:1050);
MR.UMCParameters.IterativeReconstruction.IterativeReconstruction='yes';
MR.UMCParameters.IterativeReconstruction.TVLambda=[0 0 0 0 0.01 0 ];
MR.UMCParameters.IterativeReconstruction.WaveletLambda=0.005;
MR.UMCParameters.IterativeReconstruction.SplitDimension=3;
MR.UMCParameters.IterativeReconstruction.MaxIterations=300;
MR.UMCParameters.AdjointReconstruction.R=50;
MR.PerformUMC;

dat_21sp=MR.Data;
save([root,'Scan1.mat'],'dat_21sp');
clear dat_21sp