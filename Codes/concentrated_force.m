% Moment due to concentrated force using singularity
% R is the value force
% P is the force position 
function x = concentrated_force(p,R)
    syms Z;
    if p == 0   
        x = R.*Z;
    else
        x = R.*sing(Z,p,1);
    end
end