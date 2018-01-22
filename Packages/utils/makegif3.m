function makegif3(img,filename,fps,varargin)
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
figure('units','normalized','outerposition',[0 0 1 1])
for j=1:size(img,3);
    imshow3(squeeze(img(:,:,j,:)),[],[1 3]);
    h1 = annotation('textbox',[.0 0.055 0.24 0.059245960502693],...
    'String','MRL','FitBoxToText','on','Color',[1 1 1],'LineStyle','none','FontSize',20,'FontWeight','bold');
    h2 = annotation('textbox',[0.0 0.95 0.238099859353024 0.059245960502693],...
    'String',['TE=',num2str(te(j)),' [ms]'],'FitBoxToText','on','Color',[1 1 1],'LineStyle','none','FontSize',20,'FontWeight','bold');
    A = getframe();
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