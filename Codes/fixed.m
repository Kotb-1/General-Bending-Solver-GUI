% Class for Fixed supports
% syntax:
%fixed(position,plane,index)
% - Position:       Coeff of L ; Example: 2 for position 2*L
% - plane:          input (1) for yz plane ; input (2) for xz plane
% - index:          a number to indicate the symbolic representation of the
%                   reaction force and moment
classdef fixed
    properties
        p; % Position
        R; % Reaction Force
        M; % Reaction Moment
        n; % Load index
        u; % u condition
        v; % v condition
        u_dash; % u' condition
        v_dash; % v' condition
        plane;% Index of the plane
        final_moment;% Final moment due to supports reaction
        pl;% All plots of the object
        fy;% Resultant force in the upward direction
        m0;% Moment about z=0
        f;%temp figure handle
    end
    methods
        function obj = fixed(pos,plane,o)
            global yz_axes xz_axes;
            if plane == 1
                axes1 = yz_axes;
            elseif plane == 2
                axes1 = xz_axes;
            end
            axes1.NextPlot = "add";
            syms L p;
            s = "R" + o;
            ss = "M" + o;
            pos = subs(pos,L,1)*L;
            assume(L>0)
            assume(p>0)
            obj.plane = plane; % It acts in both planes but each has its own unknowns
            obj.p = pos;
            obj.R = sym(s);
            obj.M = sym(ss);
            obj.n = o;
            if plane == 1
               obj.v = 0;
               obj.v_dash = 0;
               obj.u = nan;
               obj.u_dash = nan;
            elseif plane == 2
               obj.u = 0;
               obj.u_dash = 0;
               obj.v = nan;
               obj.v_dash = nan;
            else
                error("wrong plane index")
            end
            
            
            x1 =  concentrated_force(pos,-obj.R);
            x2 = concentrated_moment(pos,obj.M);
            obj.final_moment = x1+x2;
            obj.fy = obj.R;
            obj.m0 = obj.fy*pos+obj.M;

            % plotting
            pos = double(pos./L);
            % axes(axes1)
            if pos == 0
                x = [0 -0.125 -0.125 0];
                y = [1 1 -1 -1].*0.5;
                pl1 = fill(axes1,x,y,'r');
                [pl2, obj.f] = circular_arrow(axes1, 1 , [1-0.5 0], 180 , 90 , -1 , 'r');
                pl3 = text(axes1,(pos-0.5)*2,0,string(obj.M),"HorizontalAlignment","left",'Color','b','FontWeight','bold');
            else
                x = 2.*[pos pos+0.125/2 pos+0.125/2 pos];
                y = [1 1 -1 -1].*0.5;
                pl1 = fill(axes1,x,y,'r');
                [pl2,obj.f] = circular_arrow(axes1, 1 , [2.*pos-0.5 0], 0 , 90 , -1 , 'r');
                pl3 = text(axes1,(pos+0.5)*2,0,string(obj.M),"HorizontalAlignment","right",'Color','b','FontWeight','bold');
            end
           
            x_v = pos.*ones([10 1]);
            y_v = linspace(0,-1,10);
            x_arr = linspace(0,0.1,10);
            y_arr = 3.*x_arr;
            
            pl4 = plot(axes1,2.*x_v,y_v,'-k',2.*(-x_arr+pos),-y_arr,'-k',2.*(x_arr+pos),-y_arr,'-k');
            pl5 = text(axes1,2*pos,-1.25,string(obj.R),"HorizontalAlignment","center",'Color','b','FontWeight','bold');
            obj.pl = [pl1 pl2 pl3 pl4' pl5];
            
        end
    end
end