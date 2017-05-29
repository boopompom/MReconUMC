function ADC = extract_adc_info(MR)
% Extract set of attributes and store to struct

% ADC.ref=MR.Parameter.GetValue('AQ`base:[1]:ref')*10^(-3); % ref or ref_Act doesnt matter
% ADC.time=MR.Parameter.GetValue('AQ`base:[1]:time')*10^(-3);
% ADC.samples=MR.Parameter.GetValue('AQ`base:[1]:samples_act');
% ADC.dur=MR.Parameter.GetValue('AQ`base:[1]:dur_act')*10^(-3);
% ADC.dt=ADC.dur/ADC.samples;
% ADC.epi_dt=MR.Parameter.GetValue('GR`m[0]:dur')*10^(-3);
% ADC.nr_acq=MR.Parameter.GetValue('AQ`base:[1]:comp_elements');
% ADC.offset=ADC.time-ADC.ref;toc


% Faster alternative
tmp=MR.Parameter.GetObject('AQ`base');tmp=tmp.attributes{1};
ADC.ref=tmp(4).values*10^(-3);
ADC.time=tmp(2).values*10^(-3);
ADC.samples=tmp(73).values;
ADC.dur=tmp(1).values*10^(-3);
ADC.dt=ADC.dur/ADC.samples;
ADC.epi_dt=MR.Parameter.GetValue('GR`m[0]:dur')*10^(-3);
ADC.nr_acq=tmp(21).values;
ADC.offset=ADC.time-ADC.ref;

if ADC.nr_acq > 1
    ADC.offset=ADC.offset+MR.Parameter.GetValue('SQ`base:dur2')*10^(-3);
end

% END
end