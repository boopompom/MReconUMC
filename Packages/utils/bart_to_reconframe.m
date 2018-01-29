function res = bart_to_reconframe(input)
%Transform 12D arrays from reconframe to bart
%
% V20180129 - Tom Bruijnen

res=permute(input,[2 3 1 4 5:11]);

% END
end