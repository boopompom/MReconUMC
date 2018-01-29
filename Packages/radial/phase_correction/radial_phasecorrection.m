function radial_phasecorrection( MR )
% 20160616 - Linear phase correction by fitting a model through the k0
% phase to correct for angular dependance. Alternatively one could simply
% subtract the k0 phase from all spokes.

if ~strcmpi(MR.Parameter.Scan.AcqMode,'Radial') || strcmpi(MR.UMCParameters.SystemCorrections.PhaseCorrection,'no')
    return
end

% Notification
fprintf('     Perform radial phase correction..............  ');tic;

% Iterate over all the data chunks
for n=1:numel(MR.Data)
    
    if ~(strcmpi(MR.Parameter.Scan.UTE,'yes') && (n==1))
        % Apply zero-based phase correction
        radial_zero_based_phase_correction(MR,n);
    end
end

% GIRF based phase correction
radial_apply_phase_correction_2D(MR);

% Notification
fprintf('Finished [%.2f sec]\n',toc')

% END
end
