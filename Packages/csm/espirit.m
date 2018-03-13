function csm = espirit(traj,kdata,dims)
%Call BART toolbox to compute coil maps using espirit.
%
% V20180129 - T.Bruijnen

% NUFFT to lowres
lowres_img=bart('nufft -i -d30:30:1 -t',traj,kdata);

% Transform back to k-space
lowres_ksp=bart('fft -u 7', lowres_img);

% Zeropad to original size
ksp_zerop=zpad(lowres_ksp,dims);

% Calculate sense maps
csm=bart('ecalib -t 0.03 -m1',ksp_zerop);


% END
end