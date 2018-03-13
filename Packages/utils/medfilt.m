function res = medfilt(I,w)

sz=size(I);
res=I;
for n=1+w:sz(5)-w
    res(:,:,:,:,n)=median(I(:,:,:,:,n-w:n+w),5);
end

% END
end