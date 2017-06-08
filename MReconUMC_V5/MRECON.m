
%% MRECONUMC
%% Initialize and generate path
clear all;clc;clear classes;close all
%cd('/nfs/rtsan02/userdata/home/tbruijne/MReconUMC/MReconUMC/MReconUMC_V5/')
addpath(genpath(pwd))
%root='C:\Users\s116555\Documents\Programming\MATLAB\MReconUMC\MReconUMC_V5\Packages\simulations\Phantom\';
root='/local_scratch/tbruijne/WorkingData/2DGA/';
%root='/global_scratch/Tom/Internal_data/20170605_Lowpass_gaussian/';
%root='/global_scratch/Tom/Internal_data/20170327_Lowpass_UTE_EPI/';
scan=2;

%% recon

clear MR
MR=MReconUMC(root,scan);
%MR.UMCParameters.Simulation.Simulation='yes';
%MR.UMCParameters.SystemCorrections.GIRF_nominaltraj='yes';
%MR.UMCParameters.SystemCorrections.GIRF='yes';
MR.UMCParameters.ReconFlags.Verbose=1;
%MR.Parameter.Parameter2Read.chan=10;
%MR.Parameter.Parameter2Read.echo=0;
%MR.UMCParameters.SystemCorrections.NoisePreWhitening='yes';
%MR.Parameter.Recon.ArrayCompression='yes';
MR.UMCParameters.AdjointReconstruction.PrototypeMode=15;
%MR.UMCParameters.GeneralComputing.ParallelComputing='yes';
%MR.UMCParameters.AdjointReconstruction.NUFFTtype='3D';
%MR.UMCParameters.Simulation.Simulation='yes';
%MR.Parameter.Gridder.AlternatingRadial='no';
MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps='espirit';
MR.UMCParameters.AdjointReconstruction.LoadCoilSensitivityMaps='yes';
%MR.UMCParameters.IterativeReconstruction.JointReconstruction=5;
%MR.Parameter.Recon.ACNrVirtualChannels=8;
%MR.Parameter.Recon.ArrayCompression='yes';
%MR.Parameter.Recon.CoilCombination='no';
%MR.UMCParameters.SystemCorrections.PhaseCorrection='no';
MR.UMCParameters.IterativeReconstruction.Potential_function=1;
MR.UMCParameters.IterativeReconstruction.IterativeReconstruction='yes';
MR.UMCParameters.Operators.N_iter=100;
%MR.UMCParameters.IterativeReconstruction.Wavelet=2;
MR.UMCParameters.IterativeReconstruction.TVdimension=[0 0 0 0 1 0 ];
MR.UMCParameters.IterativeReconstruction.Lambda={15};
MR.UMCParameters.AdjointReconstruction.R=8;
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=3;
%MR.UMCParameters.SystemCorrections.PhaseCorrection='model';
%MR.UMCParameters.AdjointReconstruction.NUFFTMethod='fessler';
%MR.Parameter.Recon.CoilCombination='no';
%MR.UMCParameters.GeneralComputing.NumberOfCPUs=2;
MR.PerformUMC;



