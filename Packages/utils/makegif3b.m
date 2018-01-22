function makegif3b(img,s,filename,fps,varargin)
% Transform a 4D matrix into an image based GIF file
% Note that computer vision toolbox is required for the counter (varargin).
%
% Tom Bruijnen - University Medical Center Utrecht - 201609
close all;
% Handle input
if nargin < 4
    counter=0;
else
    counter=1;
end

te=[0.2 1.9 3.4];
img=abs(squeeze(img))/max(abs(img(:)));
scrsz = get(0,'ScreenSize');
nsize=[scrsz(3)/4 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2];
for j=1:size(img,3);
    f1=figure('units','normalized','outerposition',[0 0 1 1]);
    ha=subplot(141);
    xmax=8;
    xrange=0:2:xmax;
    ymax=20;
    yrange=-ymax:5:ymax;
    yrange2=-15:5:15;
    [ax,h1,h2]=plotyy(10^-3*s.t,s.cwf(:,2),10^-3*s.t,s.pe);
    xlabel(ax(1),'Time [ms]');ylabel(ax(1),'G_{str} [mT/m]');hold on;
    xlabel(ax(2),'Time [ms]');ylabel(ax(2),'Phase error [deg]');
    set(h1,'LineWidth',3);set(h2,'LineWidth',3);
    set(ax(1),'XTick',xrange,'YTick',yrange,'LineWidth',2,'FontSize',14,'FontWeight','bold');
    set(ax(2),'XTick',xrange,'YTick',yrange,'LineWidth',2,'FontSize',14,'FontWeight','bold');
    set(gcf,'Color','w')
    grid on;box on;
    axis(ax(1), [0 xmax -ymax ymax]);
    axis(ax(2), [0 xmax -ymax ymax]);
    plot(10^-3*s.t,-1*s.cwf(:,3),'b','LineWidth',3);
    
    if j==1
        scatter(linspace(0.2,0.9,256),zeros(256,1),'r','filled')
    end
    if j==2
        scatter(linspace(1.4,2.4,256),zeros(256,1),'r','filled')
    end
    if j==3
        scatter(linspace(3,4,256),zeros(256,1),'r','filled')
    end
    %axis([0 xmax 0-ymax ymax]);grid on;box on;legend('M/P','S','Phase error','ADC');
    %set(gca,'FontSize',14,'FontWeight','bold','LineWidth',2,'XTick',xrange,'YTick',yrange)
    
    
    legend({'M/P','S','ADC','Phase error'},'FontSize',10)
    set(ha,'Position',[0.05 0.39 .22 .25]);
    subplot(1,4,[2 3 4])
    imshow3(squeeze(img(:,:,j,:)),[],[1 3]);
    h1 = annotation('textbox',[.335 0.37 0.24 0.059245960502693],...
    'String','MRL','FitBoxToText','on','Color',[1 1 1],'LineStyle','none','FontSize',20,'FontWeight','bold');
    h2 = annotation('textbox',[.335 0.59 0.238099859353024 0.059245960502693],...
    'String',['TE=',num2str(te(j)),' ms'],'FitBoxToText','on','Color',[1 1 1],'LineStyle','none','FontSize',20,'FontWeight','bold');
    text(-225, -30,'Free-breathing GIRF corrected multi-echo stack-of-stars (UTE)','FontSize',28,'FontWeight','bold')
    A = getframe(f1);
    im=frame2im(A);
    [A,map]=rgb2ind(im,256);
    if ~exist(filename,'file')
        imwrite(A,map,filename,'gif','WriteMode','overwrite','delaytime',1/fps, 'LoopCount', 65535);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','delaytime',1/fps);    
    end
end


% END
end