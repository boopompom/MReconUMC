function apply_zeroth_order_gradient_impulse_response(MR)
%Applies the girf on the nominal gradient waveform, and save it in a matrix
% for phase correction on the data.
%
% 20170830 - T.Bruijnen

%% Logic & display 
% Only perform if this is desired
if ~strcmpi(MR.UMCParameters.SystemCorrections.PhaseCorrection,'girf')
    return;
end

% Assign variables for increased readabillity
t=MR.UMCParameters.SystemCorrections.GirfTime;
f=MR.UMCParameters.SystemCorrections.GirfZerothFrequency;
girf=MR.UMCParameters.SystemCorrections.GirfZeroth;
t_adc=MR.UMCParameters.SystemCorrections.GirfADCTime;

% Lowpass filter girf
fpar=200; beta=1; % Filter parameters
rcosfilter=rcosdesign(beta,size(girf,1)/fpar,fpar,'normal');
rcosfilter=permute(rcosfilter/max(rcosfilter),[2 1]);rcosfilter=rcosfilter(1:end-1);
girf=girf.*repmat(rcosfilter,[1 3]);

% Zeropad nominal waveform and time vector with 5 ms on both sides
dt_wf=abs(t(2)-t(1));
t_us=0:dt_wf:10E-03+t(end)-dt_wf;
zp=round(5E-03/dt_wf);
wf_us=zeros(numel(t_us),3);
wf_us(zp+1:zp+numel(t),:)=MR.UMCParameters.SystemCorrections.NominalWaveform*10^-3;

% Fourier transform the input waveform
F_waveform=fftshift(fft(fftshift(wf_us,1),[],1),1);

% Generate frequency vector of input
df_wf = 1/dt_wf/numel(t_us);
f_wf = df_wf*(0:numel(t_us)-1);
f_wf = f_wf-df_wf*ceil((numel(t_us)-1)/2); % Frequencies

% Resample the GIRF
for ax=1:3;rs_girf(:,ax)=interp1(f,girf(:,ax),f_wf);rs_girf(isnan(rs_girf))=0;end

% Apply girf
F_b0=F_waveform.*rs_girf;

% Store phase in matrix for trajectory specific interpolation operation
error_us=360*(t_us(2)-t_us(1))*cumsum(real(fftshift(ifft(ifftshift(F_b0,1),[],1),1)));
for ax=1:3;MR.UMCParameters.SystemCorrections.PhaseErrorMatrix(:,ax)=interp1(t_us,error_us(:,ax),t+5E-03);end

%END
end
