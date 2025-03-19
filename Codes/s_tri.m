% Moment due a normal triangle using singularity ---> after corrections
% (all triangles must reach the end of the beam)
% pi is the intial position
% Value is the load value
% eb is the Beam length
function x = s_tri(p_i,value,eb)
    syms Z p L;
    if p_i==eb
        x=0;
    else
        x = (value./(eb-p_i)).*sing(Z,p_i,3)./6;
    end
end