function HanningFilter( MR )


% Obtain the number of images in MR.Data
data_size=size(MR.Data);
nr_images=prod(data_size(3:end));
k=zeros(size(MR.Data));

for n=1:nr_images
    k(:,:,n)=fftshift(ifft2(fftshift(MR.Data(:,:,n))));
end
% Define filter
hfilter=(hamming(size(MR.Data,1))*hamming(size(MR.Data,2))');
hfilter=hfilter/max(hfilter(:));
% Filter every single image
for i = 1:nr_images
    k(:,:,i) = k( :,:,i) .* hfilter;
end

for z=n:nr_images
    MR.Data(:,:,n)=fftshift(fft2(k(:,:,n)));
end

% END
end
