% Class for Concenterated Forces
% syntax:
% con_f(Position,Magnitude,direction,plane,Preview)
% - Position:   Coeff of L ; Example: 2 for position 2*L
% - Magnitude:  Coeff of p*L ; Example: 2 for a force of 2*p*L
% - direction:  is "down" for downward force or "up" for upward force
% - plane:      input (1) for yz plane ; input (2) for xz plane
% - Preview:    (OPTIONAL): input True for plotting on the preview axes
%                              or False to plot on the original axis
classdef con_f
    properties
        p; % Position
        R; % Magnitude
        final_moment; % Final moment due to concentrated force
        pl; % All plots of the object
        fy; % Resultant force in the upward direction 
        m0; % Moment about z=0
        plane; % Index of the plane
    end
    methods
        function obj = con_f(pos,R,dir,plane,isprev)
            global yz_axes xz_axes prevaxes;
            if nargin<5
                isprev = false;
            end
            if plane == 1 && ~isprev
                axes1 = yz_axes;
            elseif plane == 2 && ~isprev
                axes1 = xz_axes;
            elseif isprev
                axes1 = prevaxes;
            end
            syms p L;
            pos = subs(pos,L,1)*L;
            R = subs(R,p,1);
            R = subs(R,L,1)*p*L;
            axes1.NextPlot = "add";
            obj.plane = plane;
            if strcmpi(dir,"up")
                si = 1;
                obj.fy = R;
                R = -R;
            elseif strcmpi(dir,"down")
                si = -1;
                obj.fy = -R;
            end
            
            assume(L>0)
            assume(p>0)
            obj.p = pos;
            obj.R = R;
            x1 =  concentrated_force(pos,obj.R);
            obj.final_moment = x1;
            obj.m0 = obj.fy*pos;
            % plotting
            position = double(pos./L);
            magnitude = double(R./p./L);
            x_v = position.*ones([10 1]);
            y_v = linspace(0,magnitude,10);
            x_arr = linspace(0,0.1,10);
            y_arr = 3.*x_arr;

            pl1 = plot(axes1,2.*x_v,y_v,'-k',2.*(-si.*x_arr+position),-si.*y_arr,'-k',2.*(si.*x_arr+position),-si.*y_arr,'-k');  
            obj.pl = pl1';
        end
    end
end