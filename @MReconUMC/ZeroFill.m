function ZeroFill(MR)
%Zeropad output depending on MR.Parameter.Encoding.?ReconRes

F=bart('fft 7',MR.Data);
F2=bart(['resize 0 ',num2str(MR.Parameter.Encoding.XReconRes)],...
    bart(['resize 1 ',num2str(MR.Parameter.Encoding.YReconRes)],...
    bart(['resize 2 ',num2str(round(MR.Parameter.Encoding.ZReconRes*MR.Parameter.Encoding.KzOversampling))],F)));

MR.Data=bart('fft -i 7',F2);

% END
end