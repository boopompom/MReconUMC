
%% Setup path and select root of data
clear all;clc;clear classes;close all;restoredefaultpath
addpath(genpath(pwd))
addpath(genpath('../MRecon-3.0.552/'))
root='/local_scratch/tbruijne/WorkingData/FIM/';
%root='/local_scratch/tbruijne/WorkingData/4DGA/';
scan=1;

%%
clear MR
MR=MReconUMC(root,scan);
%MR.Parameter.Parameter2Read.ky=MR.Parameter.Parameter2Read.ky(1:500);
MR.Parameter.Parameter2Read.chan=MR.Parameter.Parameter2Read.chan(5);
%MR.UMCParameters.Operators.Niter=2;
%MR.UMCParameters.AdjointReconstruction.PrototypeMode=5;
%MR.UMCParameters.SystemCorrections.NoisePreWhitening='yes';
%MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps='walsh';
%MR.UMCParameters.AdjointReconstruction.LoadCoilSensitivityMaps='yes';
%MR.UMCParameters.IterativeReconstruction.PotentialFunction=1;
%MR.Parameter.Recon.ArrayCompression='yes';
%MR.Parameter.Recon.ACNrVirtualChannels=12;
%MR.UMCParameters.IterativeReconstruction.WaveletDimension=2;
%MR.UMCParameters.IterativeReconstruction.IterativeReconstruction='yes';
%MR.UMCParameters.IterativeReconstruction.TVDimension={[1 1 0 0 0 0 1]};
%MR.UMCParameters.IterativeReconstruction.TVLambda={[30 30 0 0 0 0 2000]};
MR.UMCParameters.IterativeReconstruction.SplitDimension=3;
%MR.UMCParameters.AdjointReconstruction.SoftGating='yes';
%MR.UMCParameters.IterativeReconstruction.WaveletLambda={50,50};
%MR.UMCParameters.AdjointReconstruction.NufftSoftware='greengard';
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=3;
%MR.UMCParameters.AdjointReconstruction.NufftType='3D';
%MR.UMCParameters.AdjointReconstruction.CoilMapEchoNumber=2;
%MR.UMCParameters.AdjointReconstruction.R=2;
%MR.UMCParameters.GeneralComputing.ParallelComputing='yes';
%MR.UMCParameters.SystemCorrections.PhaseCorrection='girf';
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=3; 
%MR.UMCParameters.AdjointReconstruction.IterativeDensityEstimation='yes';
% MR.UMCParameters.SystemCorrections.Girf='yes';
% MR.UMCParameters.SystemCorrections.GirfNominalTrajectory='yes';
%MR.UMCParameters.ReconFlags.Verbose=1;
%MR.Parameter.Encoding.NrDyn=1;
MR.PerformUMC;


%%