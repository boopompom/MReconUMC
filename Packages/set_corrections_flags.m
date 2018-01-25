function MR = set_corrections_flags(MR,sign)
%% Deal with the reconstruction flags
if sign==0 % Unset correction pars
    MR.Parameter.ReconFlags.isread=0;
    MR.Parameter.ReconFlags.israndphasecorr=0;
    MR.Parameter.ReconFlags.isreadparameter=0;
    MR.Parameter.ReconFlags.ispdacorr=0;
    MR.Parameter.ReconFlags.isdcoffsetcorr=0;
    MR.Parameter.ReconFlags.isdcoffsetcorr=0;
    MR.Parameter.ReconFlags.ismeasphasecorr=0;
else
    MR.Parameter.ReconFlags.isread=1;
    MR.Parameter.ReconFlags.israndphasecorr=1;
    MR.Parameter.ReconFlags.isreadparameter=1;
    MR.Parameter.ReconFlags.ispdacorr=1;
    MR.Parameter.ReconFlags.isdcoffsetcorr=1;
    MR.Parameter.ReconFlags.isdcoffsetcorr=1;
    MR.Parameter.ReconFlags.ismeasphasecorr=1;
end

% END
end