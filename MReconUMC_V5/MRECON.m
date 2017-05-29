
%% MRECONUMC
%% Initialize and generate path
clear all;clc;clear classes;close all
curdir=which('MRECON.m');
cd(curdir(1:end-8))
addpath(genpath('/nfs/rtsan02/userdata/home/tbruijne/MReconUMC/MReconUMC/MReconUMC_V5/'))
root='/nfs/rtsan02/userdata/home/tbruijne/Documents/WorkingData/4DGA/';
%root='/global_scratch/Tom/Internal_data/20170327_Lowpass_UTE_EPI/';
scan=2;

%% Linear Recon 2D Golden angle data 

clear MR
MR=MReconUMC(root,scan);
%MR.UMCParameters.SystemCorrections.GIRF_nominaltraj=1;
MR.UMCParameters.SystemCorrections.GIRF='yes';
%MR.UMCParameters.ReconFlags.Verbose=1;
%MR.Parameter.Parameter2Read.chan=10;
%MR.Parameter.Parameter2Read.echo=0;
%MR.UMCParameters.SystemCorrections.NoisePreWhitening='yes';
MR.Parameter.Recon.ArrayCompression='yes';
MR.UMCParameters.AdjointReconstruction.PrototypeMode=1;
%MR.UMCParameters.GeneralComputing.ParallelComputing='yes';
MR.UMCParameters.AdjointReconstruction.NUFFTtype='3D';
%MR.UMCParameters.Simulation.Simulation='yes';
%MR.Parameter.Gridder.AlternatingRadial='no';
MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps='walsh';
%MR.UMCParameters.AdjointReconstruction.LoadCoilSensitivityMaps='yes';
MR.Parameter.Recon.ACNrVirtualChannels = 5;
%MR.Parameter.Recon.ArrayCompression = 'yes';
%MR.UMCParameters.SystemCorrections.PhaseCorrection='zero';
%MR.UMCParameters.IterativeReconstruction.IterativeReconstruction='yes';
%MR.UMCParameters.IterativeReconstruction.TVtype='spatial';
%MR.UMCParameters.IterativeReconstruction.CGLambda=20;
MR.UMCParameters.AdjointReconstruction.R=7;
MR.UMCParameters.AdjointReconstruction.SpatialResolution=5;
MR.UMCParameters.SystemCorrections.PhaseCorrection='model_interpolation';
MR.UMCParameters.AdjointReconstruction.NUFFTMethod='fessler';
%MR.Parameter.Recon.CoilCombination='no';
%MR.UMCParameters.GeneralComputing.NumberOfCPUs=2;
MR.PerformUMC;

