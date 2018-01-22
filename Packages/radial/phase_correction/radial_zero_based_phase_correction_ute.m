function radial_zero_based_phase_correction_ute(MR,n)
% Remove central phase from radial 2D / Stack-of-stars acquisitions

% Logic
if ~strcmpi(MR.UMCParameters.SystemCorrections.PhaseCorrection,'zero') 
    return;
end

% Get dimensions for data handling
dims=MR.UMCParameters.AdjointReconstruction.KspaceSize{n};

% Preallocate the matrix
phase_corr_matrix=zeros(size(MR.Data{n}));

% Loop over all lines and determine the correction phase
for avg=1:dims(12) % Averages
for ex2=1:dims(11) % Extra2
for ex1=1:dims(10) % Extra1
for mix=1:dims(9)  % Locations
for loc=1:dims(8)  % Mixes
for ech=1:dims(7)  % Echoes
for ph=1:dims(6)   % Phases
for dyn=1:dims(5)  % Dynamics
for z=1:dims(3)    % Z
for y=1:dims(2)    % Y
for coil=1:dims(4) % Coils
    
    cur_phase(coil)=angle(MR.Data{n}(1,y,z,coil,dyn,ph,ech,loc,mix,ex1,ex2,avg)) -...
        angle(MR.Data{n}(1,y,z,1,dyn,ph,ech,loc,mix,ex1,ex2,avg));
      
end % Y
    phase_corr_matrix(:,y,z,:,dyn,ph,ech,loc,mix,ex1,ex2,avg)=...
        single(exp(1j*repmat(cur_phase,[dims(1) 1 1 1 1 1 1 1 1 1 1 1])));  
end % Z
end % Coils
end % Dynamics
end % Echos
end % Phases
end % Mixes
end % Locations
end % Extra1
end % Extra2
end % Averages

% Apply matrix multiplication with single indexing
MR.Data{n}=MR.Data{n}.*phase_corr_matrix;


% END
end