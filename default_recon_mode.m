
%% Setup path and select root of data
clear all;clc;clear classes;close all;restoredefaultpath
addpath(genpath('/local_scratch/tbruijne/BART/MRecon-3.0.552/'))
addpath(genpath('/local_scratch/tbruijne/BART/MReconUMCBART'))
addpath(fullfile('/local_scratch/tbruijne/BART/bart-0.4.02/','matlab'));
setenv('TOOLBOX_PATH','/local_scratch/tbruijne/BART/bart-0.4.02/');
root='/local_scratch/tbruijne/WorkingData/2DGA/';
scan=3;

%%
clear MR
MR=MReconUMC(root,scan);
MR.Parameter.Parameter2Read.ky=MR.Parameter.Parameter2Read.ky(1:200);
%MR.Parameter.Parameter2Read.chan=MR.Parameter.Parameter2Read.chan(c);
%MR.UMCParameters.Operators.Niter=2;
%MR.UMCParameters.GeneralComputing.Chunks=3;
%MR.UMCParameters.AdjointReconstruction.PrototypeMode=5;
%MR.UMCParameters.SystemCorrections.NoisePreWhitening='yes';
MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps='espirit';
%MR.UMCParameters.AdjointReconstruction.LoadCoilSensitivityMaps='yes';
MR.UMCParameters.IterativeReconstruction.PotentialFunction=1;
%MR.Parameter.Recon.ArrayCompression='yes';
%MR.Parameter.Recon.ACNrVirtualChannels=12;
%MR.UMCParameters.IterativeReconstruction.IterativeReconstruction='yes';
%MR.UMCParameters.IterativeReconstruction.TVLambda=[0.002 0.002 0 0 0 0 ];
MR.UMCParameters.IterativeReconstruction.WaveletLambda=0.015;
MR.UMCParameters.IterativeReconstruction.SplitDimension=3;
%MR.Parameter.Recon.CoilCombination='no';
%MR.UMCParameters.AdjointReconstruction.SoftGating='yes';
%MR.UMCParameters.IterativeReconstruction.WaveletLambda={50,50};
%MR.UMCParameters.AdjointReconstruction.NufftSoftware='greengard';
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=5;
%MR.UMCParameters.AdjointReconstruction.NufftType='3D';
%MR.UMCParameters.AdjointReconstruction.CoilMapEchoNumber=2;
MR.UMCParameters.AdjointReconstruction.R=2;
%MR.UMCParameters.GeneralComputing.ParallelComputing='yes';
%MR.UMCParameters.SystemCorrections.PhaseCorrection='no';
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=1;
%MR.UMCParameters.AdjointReconstruction.IterativeDensityEstimation='yes';
% MR.UMCParameters.SystemCorrections.Girf='yes';
% MR.UMCParameters.SystemCorrections.GirfNominalTrajectory='yes';
%MR.UMCParameters.ReconFlags.Verbose=1;
%MR.Parameter.Encoding.NrDyn=1;
%MR.Parameter.Recon.CoilCombination='no';
MR.PerformUMC;



%%
