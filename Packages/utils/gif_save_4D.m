function gif_save_4D(data_4D,voxSize,basename,indices,range,time_per_volume)
%
%
%

[nx,ny,nz,no_dyn] = size(data_4D);
if nargin < 2
    indices = [round(nx/2),round(ny/2),round(nz/2)];
    voxSize = [1.875,1.875,4.0];
    basename = '4D_MRI';
    range = [0 1];
end;

if nargin < 6
    DCE_yn = false;
else
    DCE_yn = true;
end;

if ~isreal(data_4D)
    data_4D = abs(data_4D);
    data_4D = data_4D./max(data_4D(:));
%     range = [0 0.85];
end;

% Only for DCE
% time_per_volume = 5.2335; 
% For 21: 3.6253 
% For 13: 2.2442
% For 140: 24.1688
% For 80: 13.8108
% Or calculate, using
% scan_time = MR.Parameter.Labels.ScanDuration; % 350.4478
% numb_projs = length(MR.Parameter.Parameter2Read.ky); %2030
% shot_length = scan_time/numb_projs;
% numb_of_projs = 21;
% time_per_volume = shot_length*numb_of_projs;

f1 = figure('Color',[1 1 1],'Position',[100 100 nx*voxSize(1) ny*voxSize(2)]);
imagesc(squeeze(data_4D(:,:,indices(3),1)),range); colormap(gray);
set(gca,'visible','off','xcolor','w','ycolor','w','xtick',[],'ytick',[],'box','off');
set(gca,'units','pixels');
set(gca,'units','normalized','position',[0 0 1 1]);
pause(1);
for t=1:no_dyn
    imagesc(squeeze(data_4D(:,:,indices(3),t)),range); colormap(gray);
    set(gca,'visible','off','xcolor','w','ycolor','w','xtick',[],'ytick',[],'box','off');
    set(gca,'units','pixels');
    set(gca,'units','normalized','position',[0 0 1 1]);
    str = sprintf('Phase = %d',t);
    if DCE_yn
        time = time_per_volume*t;
        str = sprintf('Time = %.2f sec',time);
    end;
    h = annotation(f1,'textbox',...
       [0.25 0.1 0.238099859353024 0.059245960502693],...
        'String',str,'FitBoxToText','on','Color',[1 1 1],'LineStyle','none');
    h2 = annotation(f1,'textbox',...
        [0.0 0.95 0.238099859353024 0.059245960502693],...
        'String','MRL UMC Utrecht','FitBoxToText','on','Color',[1 1 1],'LineStyle','none');
%     pause(0.2)
    frame2gif(f1,[basename,'_tra.gif'],3)
    h.Visible = 'off';
    h2.Visible = 'off';
end;

f2 = figure('Color',[1 1 1],'Position',[300 300 nx*voxSize(1) nz*voxSize(3)]);
imagesc(squeeze(data_4D(indices(1),:,:,1))',range); colormap(gray);
set(gca,'YDir','normal','visible','off','xcolor','w','ycolor','w','xtick',[],'ytick',[],'box','off');
set(gca,'units','pixels');
set(gca,'units','normalized','position',[0 0 1 1]);
pause(1)
for t=1:no_dyn
    imagesc(squeeze(data_4D(indices(2),:,:,t))',range); colormap(gray);
    set(gca,'YDir','normal','visible','off','xcolor','w','ycolor','w','xtick',[],'ytick',[],'box','off');
    set(gca,'units','pixels');
    set(gca,'units','normalized','position',[0 0 1 1]);
%     str = sprintf('Phase = %d',t);
%     h = annotation(f1,'textbox',...
%        [0.55 0.14 0.238099859353024 0.059245960502693],...
%         'String',str,'FitBoxToText','on','Color',[1 1 1],'LineStyle','none');
    h = annotation(f2,'textbox',...
        [0.0 0.1 0.238099859353024 0.059245960502693],...
        'String','MRL UMC Utrecht','FitBoxToText','on','Color',[1 1 1],'LineStyle','none');
    frame2gif(f2,[basename,'_cor.gif'],3)
%     pause(0.2)
    h.Visible = 'off';
end;

f3 = figure('Color',[1 1 1],'Position',[500 500 ny*voxSize(2) nz*voxSize(3)]);
imagesc(squeeze(data_4D(:,indices(2),:,1))',range); colormap(gray);
set(gca,'YDir','normal','visible','off','xcolor','w','ycolor','w','xtick',[],'ytick',[],'box','off');
set(gca,'units','pixels');
set(gca,'units','normalized','position',[0 0 1 1]);
pause(1)
for t=1:no_dyn
    imagesc(squeeze(data_4D(:,indices(3),:,t))',range); colormap(gray);
    set(gca,'YDir','normal','visible','off','xcolor','w','ycolor','w','xtick',[],'ytick',[],'box','off');
    set(gca,'units','pixels');
    set(gca,'units','normalized','position',[0 0 1 1]);
%     str = sprintf('Phase = %d',t);
%     h = annotation(f1,'textbox',...
%        [0.55 0.14 0.238099859353024 0.059245960502693],...
%         'String',str,'FitBoxToText','on','Color',[1 1 1],'LineStyle','none');
%     pause(0.2)
    h = annotation(f3,'textbox',...
        [0.0 0.1 0.238099859353024 0.059245960502693],...
        'String','MRL UMC Utrecht','FitBoxToText','on','Color',[1 1 1],'LineStyle','none');
    frame2gif(f3,[basename,'_sag.gif'],3)
    h.Visible = 'off';
end;

pause(0.2);
close; close; close