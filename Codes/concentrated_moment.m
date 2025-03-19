% Moment due to concentrated moment using singularity
% M is the value moment
% P is the moment position 
function x = concentrated_moment(p,M)
    syms Z;
    if p == 0   
        x = M;
    else
        x = M.*sing(Z,p,0);
    end
end