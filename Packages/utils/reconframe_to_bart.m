function res = reconframe_to_bart(input)
%Transform 12D arrays from reconframe to bart
%
% V20180129 - Tom Bruijnen

res=permute(input,[3 1 2 4 5:11]);

% END
end