function f_d = angular_dependency_filter(d)
% Filter angular dependency using the golden angle assumption

% Radial angles
dangle=(pi/(((1+sqrt(5))/2)));
radang=mod(0:dangle:dangle*size(d,1)-.1,2*pi);

% Sort both arrays
[s_radang,idx]=sort(radang);

% Set the fitting model
A0=[1,1,1];
phi=@(a,theta)(a(1)*cos(theta)+a(2)*sin(theta)+a(3)); 

% Loop over all coils and do fit
for c=1:size(d,2)
    % Demean
    d(:,c)=demean(d(:,c));
    % Fitting 
    pars=nlinfit(radang,d(:,c)',phi,A0);
    p(:,c)=pars;
end

% Correction
for c=1:size(d,2)
    f_d(:,c)=d(:,c)-phi(p(:,c),radang)';
end

% END
end