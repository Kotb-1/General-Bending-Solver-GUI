%Class for Simple supports
% syntax:
% simple(position,plane,index)
% - Position:       Coeff of L ; Example: 2 for position 2*L
% - plane:          input (1) for yz plane ; input (2) for xz plane
% - index:          a number to indicate the symbolic representation of the
%                   reaction force and moment
classdef simple
    properties
        p; % Position
        R; % Reaction Force
        u; % u condition
        v; % v condition
        n; % Load index
        u_dash; % u' condition
        v_dash; % v' condition
        plane;% Index of the plane
        final_moment;% Final moment due to supports reaction
        pl;% All plots of the object
        fy;% Resultant force in the upward direction
        m0;% Moment about z=0
    end
    methods
        function obj = simple(pos,plane,o)
            global yz_axes xz_axes;
            if plane == 1
                axes1 = yz_axes;
            elseif plane == 2
                axes1 = xz_axes;
            end
            axes1.NextPlot = "add";
            syms L p;
            s = "R" + o;
            pos = subs(pos,L,1)*L;
            assume(L>0)
            assume(p>0)
            obj.plane = plane;
            obj.p = pos;
            obj.R = sym(s);
            if plane == 1
               obj.v = 0;
               obj.u = nan;
            elseif plane == 2
               obj.u = 0;
               obj.v = nan;
            else
                error("wrong plane index")
            end
            obj.n = o;
            obj.u_dash = nan;
            obj.v_dash = nan;
            x1 =  concentrated_force(pos,-obj.R);
            obj.final_moment = x1;
            obj.fy = obj.R;
            obj.m0 = obj.fy*pos;
            pos = 2.*double(pos./L);
            x = [pos pos+0.25 pos-0.25];
            y = [0 -0.25 -0.25];
            
            pl1 = fill(axes1,x,y,'r');
            pl2 = text(axes1,pos,-0.5,string(obj.R),"HorizontalAlignment","center",'Color','r','FontWeight','bold');
            obj.pl = [pl1 pl2];
        end
    end
end