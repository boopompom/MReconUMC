function walsh(MR)
%Call BART toolbox to compute coil maps according with the Walsh method
%
% V20180129 - T.Bruijnen

for n=1:numel(MR.Data)
    
% Short variable
Kd=MR.UMCParameters.AdjointReconstruction.KspaceSize{n};
Id=MR.UMCParameters.AdjointReconstruction.KspaceSize{n};


for avg=1:Kd(12) % Averages
for ex2=1:Kd(11) % Extra2
for ex1=1:Kd(10) % Extra1
for mix=1:Kd(9)  % Locations
for loc=1:Kd(8)  % Mixes
for ech=1:Kd(7)  % Echos
for ph=1:Kd(6)   % Phases
for dyn=1:Kd(5)  % Dynamics

    % Per slice
    if MR.UMCParameters.IterativeReconstruction.SplitDimension==3
        for z=1:Kd(3)
            % Reconstruct low-resolution image 
            lowres_img=bart('nufft -i -d30:30:1 -t',MR.Parameter.Gridder.Kpos{n}(:,:,:,:,dyn,ph,ech,loc,mix,ex1,ex2,avg),...
                reconframe_to_bart(MR.Data{n}(:,:,z,:,dyn,ph,ech,loc,mix,ex1,ex2,avg)));
            
                        lowres_img=bart('nufft -i -d30:30:1 -t',ktmp,...
                reconframe_to_bart(MR.Data{n}(:,:,z,:,dyn,ph,ech,loc,mix,ex1,ex2,avg)));

            % Transform back to k-space
            lowres_ksp=bart('fft -u 7', lowres_img);

            % Zeropad to original size
            ksp_zerop=zpad(lowres_ksp,[Id(1:2) 1 Id(4)]);

            % Calculate sense maps
            MR.Parameters.Recon.Sensitivities{n}(:,:,z,:,dyn,ph,ech,loc,mix,ex1,ex2,avg)=bart_to_reconframe(bart('walsh -t 0.02 -m1', ksp_zerop));                                

        end
    else % Per Volume
            % Reconstruct low-resolution image 
            lowres_img=bart('nufft -i -d30:30:1 -t', MR.Parameters.Gridder.Kpos{n}(:,:,:,:,dyn,ph,ech,loc,mix,ex1,ex2,avg),...
                reconframe_to_bart(MR.Data{n}(:,:,:,:,dyn,ph,ech,loc,mix,ex1,ex2,avg)));

            % Transform back to k-space
            lowres_ksp=bart('fft -u 7', lowres_img);

            % Zeropad to original size
            ksp_zerop=zpad(lowres_ksp,Id(1:4));

            % Calculate sense maps
            MR.Parameters.Recon.Sensitivities{n}(:,:,:,:,dyn,ph,ech,loc,mix,ex1,ex2,avg)=bart_to_reconframe(bart('walsh -t 0.02 -m1', ksp_zerop));     
    end
end % Slices
end % Dynamics
end % Echos
end % Phases
end % Mixes
end % Locations
end % Extra1
end % Extra2
end % Averages




csm=walsh
% END