% 
clear all;close all;clc
% grasp matlab
SCALE=0.6;
SPOKES=13;
KSPACE=readcfl('/local_scratch/tbruijne/BART/bart-workshop/demos/grasp/example/data/slice');
SENS=readcfl('/local_scratch/tbruijne/BART/bart-workshop/demos/grasp/example/data/sens');
READ=size(KSPACE,1);
LINES=size(KSPACE,2);
PHASES=floor(LINES / SPOKES);
KSPACE=KSPACE(:,1:PHASES*SPOKES,:,:);

tmp1=bart('traj -G -x 512 -y 2093');

tmp2=bart('scale 0.5',tmp1);
traj=bart('reshape 1028 13 161',tmp2);
traj(1,:)=traj(1,:)+.25;
traj(2,:)=traj(2,:)+.25;

clear tmp1 tmp2
tmp1=bart('reshape 6 13 161',KSPACE);
tmp2=bart('transpose 2 10',tmp1);

kspace=bart('reshape 7 1 512 13',tmp2);
clear tmp1 tmp2


% 
% % NUFFT to lowres
% lowres_img=bart('nufft -i -d30:30:1 -t',traj,kspace);
% lowres_img=mean(lowres_img,11);
% % Transform back to k-space
% lowres_ksp=bart('fft -u 7', lowres_img);
% dims=size(res);dims(11)=1;dims(4)=6;
% % Zeropad to original size
% ksp_zerop=zpad(lowres_ksp,dims);
% 
% % Calculate sense maps
% csm=bart('ecalib -t 0.001 -m1',ksp_zerop);
% SENS=csm;


res=bart('pics -S -d5 -u10 -RT:1024:0:0.01 -i150 -t',traj(:,:,:,:,:,:,:,:,:,:,1:40),kspace(:,:,:,:,:,:,:,:,:,:,1:40),SENS);

