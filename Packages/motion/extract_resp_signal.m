function respiration = extract_resp_signal(kc)


kc = permute(kc,[2 1 3]);
[nz,ntviews,nc] = size(kc);
% ZIP = fft(kc,200,1);
ZIP = abs(fftshift(ifft(kc,200,1),1));
for ii=1:nc
    for jj=1:ntviews
        % Normalize
        maxprof = max(ZIP(:,jj,ii));
        minprof = min(ZIP(:,jj,ii));
        ZIP(:,jj,ii) = (ZIP(:,jj,ii) - minprof)./(maxprof-minprof);
    end;
end;

kk = 1; 
clear PCs
for ii=1:nc
    tmp = permute(ZIP(:,:,ii),[1 3 2]);
    tmp = abs(reshape(tmp,[size(tmp,1)*size(tmp,2),ntviews])');
    
    covariance=cov(tmp);
    [tmp2, V] = eig(covariance);
    V = diag(V);
    [~, rindices] = sort(-1*V);
    V = V(rindices);
    tmp2 = tmp2(:,rindices);
    PC = (tmp2' * tmp')';
    
    % Take the first two principal components from each coil element.
    for jj=1:2
        tmp3=smooth(PC(:,jj),6,'lowess'); % do some moving average smoothing
        
        %Normalize the signal for display
        tmp3=tmp3-min(tmp3(:));
        tmp3=tmp3./max(tmp3(:));
        PCs(:,kk)=tmp3;kk=kk+1;
%         %plot the estimated signal
%         imagesc(abs(ZIP(:,:,ii))),axis image,colormap(gray), axis off
%         hold on
%         plot(-tmp3(:)*100+220,'r')
%         hold off
%         pause
    end
end    

close all
% Do coil clusting to find the respiratory motion signal
% Function obtained from Tao Zhang (http://web.stanford.edu/~tzhang08/software.html)
thresh = 0.95;
[respiration, ~] = coilClustering(PCs, thresh);

%Normalize the signal for display
respiration=respiration-min(respiration(:));
respiration=respiration./max(respiration(:));


