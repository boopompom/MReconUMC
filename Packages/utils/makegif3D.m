function makegif3D(img,filename,fps,varargin)
% Transform a 3D matrix into an image based GIF file
% Note that computer vision toolbox is required for the counter (varargin).
%
% Tom Bruijnen - University Medical Center Utrecht - 201609
close all;

scrsz = get(0,'ScreenSize');
nsize=[scrsz(3)/4 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2];
figure('units','normalized','outerposition',[0 0 1 1])
for j=1:size(img,3);
    ax=img(:,:,j);
    sag=rot90(squeeze(img(:,j,:)),1);
    cor=rot90(squeeze(img(j,:,:)),1);
    imshow3(cat(3,ax,sag,cor),[],[1 3]);   
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