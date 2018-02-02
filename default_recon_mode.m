
%% Setup path and select root of data
clear all;clc;clear classes;close all;restoredefaultpath
addpath(genpath('/local_scratch/tbruijne/BART/MRecon-3.0.552/'))
addpath(genpath('/local_scratch/tbruijne/BART/MReconUMCBART'))
addpath(fullfile('/local_scratch/tbruijne/BART/bart-0.4.02/','matlab'));
setenv('TOOLBOX_PATH','/local_scratch/tbruijne/BART/bart-0.4.02/');
root='/local_scratch/tbruijne/WorkingData/FIM/';
%root='/nfs/bsc01/researchData/USER/tbruijne/MR_Data/Internal_data/Radial3D_data/U2/20170926_3D_Abdomen/'
%root='/nfs/bsc01/researchData/USER/tbruijne/MR_Data/Internal_data/MRL_data/20170405_MRL_2Dcine_4D_data/';
%root='/nfs/bsc01/researchData/USER/tbruijne/MR_Data/Internal_data/Radial3D_data/U2/20170928_4D_abdomen/';
root='/nfs/bsc01/researchData/USER/tbruijne/MR_Data/Internal_data/Radial3D_data/U2/20170928_4D_abdomen/';
scan=1;

%%
clear MR
MR=MReconUMC(root,scan);
%MR.Parameter.Parameter2Read.ky=MR.Parameter.Parameter2Read.ky(1:300);
%MR.Parameter.Parameter2Read.chan=MR.Parameter.Parameter2Read.chan(c);
%MR.UMCParameters.Operators.Niter=2;
%MR.UMCParameters.GeneralComputing.Chunks=2;
%MR.UMCParameters.AdjointReconstruction.PrototypeMode=5;
%MR.UMCParameters.SystemCorrections.NoisePreWhitening='yes';
%MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps='espirit';
%MR.UMCParameters.AdjointReconstruction.LoadCoilSensitivityMaps='yes';
%MR.UMCParameters.IterativeReconstruction.PotentialFunction=1;
%MR.Parameter.Recon.ArrayCompression='yes';
%MR.Parameter.Recon.ACNrVirtualChannels=12;
MR.UMCParameters.IterativeReconstruction.IterativeReconstruction='yes';
MR.UMCParameters.IterativeReconstruction.TVLambda=[0 0 0 0 0.08 0 ];
MR.UMCParameters.IterativeReconstruction.WaveletLambda=0.0003;
MR.UMCParameters.IterativeReconstruction.SplitDimension=3;
MR.UMCParameters.IterativeReconstruction.MaxIterations=30;
%MR.Parameter.Recon.CoilCombination='no';
%MR.UMCParameters.AdjointReconstruction.SoftGating='yes';
MR.UMCParameters.AdjointReconstruction.RespiratorySorting=10;
%MR.UMCParameters.IterativeReconstruction.WaveletLambda={50,50};
%MR.UMCParameters.AdjointReconstruction.NufftSoftware='greengard';
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=5;
%MR.UMCParameters.AdjointReconstruction.NufftType='3D';
%MR.UMCParameters.AdjointReconstruction.CoilMapEchoNumber=2;
%MR.UMCParameters.AdjointReconstruction.R=10;
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

b_bart_4d_mrl=MR.Data;
cd('/nfs/rtsan01/RT-Temp/TomBruijnen/Rob/4D/')
save('b_bart_4d_mrl.mat','b_bart_4d_mrl')


%%
