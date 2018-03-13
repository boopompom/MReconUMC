
%% Reconstruct chewing data
clear all;clc;clear classes;close all;restoredefaultpath
addpath(genpath('/local_scratch/tbruijne/BART/MRecon-3.0.552/'))
addpath(genpath('/local_scratch/tbruijne/BART/MReconUMCBART'))
addpath(fullfile('/local_scratch/tbruijne/BART/bart-0.4.02/','matlab'));
setenv('TOOLBOX_PATH','/local_scratch/tbruijne/BART/bart-0.4.02/');
%root='/local_scratch/tbruijne/WorkingData/FIM/';
%root='/nfs/bsc01/researchData/USER/tbruijne/MR_Data/Internal_data/Radial3D_data/U2/20170928_4D_abdomen/';
root='/nfs/bsc01/researchData/USER/tbruijne/MR_Data/Internal_data/Chewing_data/Vol1_Stefan/';


%%
scan=5;
clear MR
MR=MReconUMC(root,scan);
%MR.Parameter.Parameter2Read.ky=MR.Parameter.Parameter2Read.ky(1:300);
%MR.Parameter.Parameter2Read.chan=MR.Parameter.Parameter2Read.chan(c);
%MR.UMCParameters.Operators.Niter=2;
%MR.UMCParameters.GeneralComputing.Chunks=2;
%MR.UMCParameters.AdjointReconstruction.PrototypeMode=60;
%MR.UMCParameters.SystemCorrections.NoisePreWhitening='yes';
%MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps='espirit';
%MR.UMCParameters.AdjointReconstruction.LoadCoilSensitivityMaps='yes';
%MR.UMCParameters.IterativeReconstruction.PotentialFunction=1;
%MR.Parameter.Recon.ArrayCompression='yes';
%MR.Parameter.Recon.ACNrVirtualChannels=12;
MR.UMCParameters.IterativeReconstruction.IterativeReconstruction='yes';
MR.UMCParameters.IterativeReconstruction.TVLambda=[0 0 0 0 0.02 0 ];
MR.UMCParameters.IterativeReconstruction.WaveletLambda=0.005;
MR.UMCParameters.IterativeReconstruction.SplitDimension=3;
MR.UMCParameters.IterativeReconstruction.MaxIterations=200;
%MR.Parameter.Recon.CoilCombination='no';
%MR.UMCParameters.AdjointReconstruction.SoftGating='yes';
%MR.UMCParameters.AdjointReconstruction.RespiratorySorting=10;
%MR.UMCParameters.IterativeReconstruction.WaveletLambda={50,50};
%MR.UMCParameters.AdjointReconstruction.NufftSoftware='greengard';
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=5;
%MR.UMCParameters.AdjointReconstruction.NufftType='3D';
%MR.UMCParameters.AdjointReconstruction.CoilMapEchoNumber=2;
MR.UMCParameters.AdjointReconstruction.R=125;
%MR.UMCParameters.GeneralComputing.ParallelComputing='yes';
%MR.UMCParameters.SystemCorrections.PhaseCorrection='no';
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=[3 3 10];
%MR.UMCParameters.AdjointReconstruction.IterativeDensityEstimation='yes';
% MR.UMCParameters.SystemCorrections.Girf='yes';
% MR.UMCParameters.SystemCorrections.GirfNominalTrajectory='yes';
%MR.UMCParameters.ReconFlags.Verbose=1;
%MR.Parameter.Encoding.NrDyn=1;
%MR.Parameter.Recon.CoilCombination='no';
MR.PerformUMC;

for n=1:5;
    tmp=MR.Data(:,:,n,:,:);
    MR.Data(:,:,n,:,:)=tmp/mean(abs(tmp(:)));
end

data=abs(MR.Data);
save('/nfs/bsc01/researchData/USER/tbruijne/MR_Data/Internal_data/Chewing_data/Vol1_Stefan/Scan5.mat','data')
clear data
%%
scan=6;
clear MR
MR=MReconUMC(root,scan);
%MR.Parameter.Parameter2Read.ky=MR.Parameter.Parameter2Read.ky(1:300);
%MR.Parameter.Parameter2Read.chan=MR.Parameter.Parameter2Read.chan(c);
%MR.UMCParameters.Operators.Niter=2;
%MR.UMCParameters.GeneralComputing.Chunks=2;
%MR.UMCParameters.AdjointReconstruction.PrototypeMode=40;
%MR.UMCParameters.SystemCorrections.NoisePreWhitening='yes';
%MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps='espirit';
%MR.UMCParameters.AdjointReconstruction.LoadCoilSensitivityMaps='yes';
%MR.UMCParameters.IterativeReconstruction.PotentialFunction=1;
%MR.Parameter.Recon.ArrayCompression='yes';
%MR.Parameter.Recon.ACNrVirtualChannels=12;
MR.UMCParameters.IterativeReconstruction.IterativeReconstruction='yes';
MR.UMCParameters.IterativeReconstruction.TVLambda=[0 0 0 0 0.02 0 ];
MR.UMCParameters.IterativeReconstruction.WaveletLambda=0.005;
MR.UMCParameters.IterativeReconstruction.SplitDimension=3;
MR.UMCParameters.IterativeReconstruction.MaxIterations=200;
%MR.Parameter.Recon.CoilCombination='no';
%MR.UMCParameters.AdjointReconstruction.SoftGating='yes';
%MR.UMCParameters.AdjointReconstruction.RespiratorySorting=10;
%MR.UMCParameters.IterativeReconstruction.WaveletLambda={50,50};
%MR.UMCParameters.AdjointReconstruction.NufftSoftware='greengard';
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=5;
%MR.UMCParameters.AdjointReconstruction.NufftType='3D';
%MR.UMCParameters.AdjointReconstruction.CoilMapEchoNumber=2;
MR.UMCParameters.AdjointReconstruction.R=125;
%MR.UMCParameters.GeneralComputing.ParallelComputing='yes';
%MR.UMCParameters.SystemCorrections.PhaseCorrection='no';
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=[3 3 10];
%MR.UMCParameters.AdjointReconstruction.IterativeDensityEstimation='yes';
% MR.UMCParameters.SystemCorrections.Girf='yes';
% MR.UMCParameters.SystemCorrections.GirfNominalTrajectory='yes';
%MR.UMCParameters.ReconFlags.Verbose=1;
%MR.Parameter.Encoding.NrDyn=1;
%MR.Parameter.Recon.CoilCombination='no';
MR.PerformUMC;

for n=1:5;
    tmp=MR.Data(:,:,n,:,:);
    MR.Data(:,:,n,:,:)=tmp/mean(abs(tmp(:)));
end

data=MR.Data;
save('/nfs/bsc01/researchData/USER/tbruijne/MR_Data/Internal_data/Chewing_data/Vol1_Stefan/Scan6.mat','data')
clear data
%%
scan=7;
clear MR
MR=MReconUMC(root,scan);
%MR.Parameter.Parameter2Read.ky=MR.Parameter.Parameter2Read.ky(1:300);
%MR.Parameter.Parameter2Read.chan=MR.Parameter.Parameter2Read.chan(c);
%MR.UMCParameters.Operators.Niter=2;
%MR.UMCParameters.GeneralComputing.Chunks=2;
%MR.UMCParameters.AdjointReconstruction.PrototypeMode=40;
%MR.UMCParameters.SystemCorrections.NoisePreWhitening='yes';
%MR.UMCParameters.AdjointReconstruction.CoilSensitivityMaps='espirit';
%MR.UMCParameters.AdjointReconstruction.LoadCoilSensitivityMaps='yes';
%MR.UMCParameters.IterativeReconstruction.PotentialFunction=1;
%MR.Parameter.Recon.ArrayCompression='yes';
%MR.Parameter.Recon.ACNrVirtualChannels=12;
MR.UMCParameters.IterativeReconstruction.IterativeReconstruction='yes';
MR.UMCParameters.IterativeReconstruction.TVLambda=[0 0 0 0 0.02 0 ];
MR.UMCParameters.IterativeReconstruction.WaveletLambda=0.005;
MR.UMCParameters.IterativeReconstruction.SplitDimension=3;
MR.UMCParameters.IterativeReconstruction.MaxIterations=300;
%MR.Parameter.Recon.CoilCombination='no';
%MR.UMCParameters.AdjointReconstruction.SoftGating='yes';
%MR.UMCParameters.AdjointReconstruction.RespiratorySorting=10;
%MR.UMCParameters.IterativeReconstruction.WaveletLambda={50,50};
%MR.UMCParameters.AdjointReconstruction.NufftSoftware='greengard';
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=5;
%MR.UMCParameters.AdjointReconstruction.NufftType='3D';
%MR.UMCParameters.AdjointReconstruction.CoilMapEchoNumber=2;
MR.UMCParameters.AdjointReconstruction.R=120;
%MR.UMCParameters.GeneralComputing.ParallelComputing='yes';
%MR.UMCParameters.SystemCorrections.PhaseCorrection='no';
%MR.UMCParameters.AdjointReconstruction.SpatialResolution=[3 3 10];
%MR.UMCParameters.AdjointReconstruction.IterativeDensityEstimation='yes';
% MR.UMCParameters.SystemCorrections.Girf='yes';
% MR.UMCParameters.SystemCorrections.GirfNominalTrajectory='yes';
%MR.UMCParameters.ReconFlags.Verbose=1;
%MR.Parameter.Encoding.NrDyn=1;
%MR.Parameter.Recon.CoilCombination='no';
MR.PerformUMC;

for n=1:5;
    tmp=MR.Data(:,:,n,:,:);
    MR.Data(:,:,n,:,:)=tmp/mean(abs(tmp(:)));
end

data=MR.Data;
save('/nfs/bsc01/researchData/USER/tbruijne/MR_Data/Internal_data/Chewing_data/Vol1_Stefan/Scan7.mat','data')
clear data