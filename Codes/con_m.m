% Class for concentrated Moment
% syntax:
% con_m(Position,Magnitude,direction,plane,Preview)
% - Position:   Coeff of L ; Example: 2 for position 2*L
% - Magnitude:  Coeff of p*L^2 ; Example: 2 for a force of 2*p*L^2
% - direction:  is 'cw' for Clockwise Moment or 'ccw' for
%               Counterclockwise Moment
% - plane:      input (1) for yz plane ; input (2) for xz plane
% - Preview:    (OPTIONAL): input True for plotting on the preview axes
%                              or False to plot on the original axis
classdef con_m
    properties
        p; % Position
        M; % Magnitude
        final_moment; % Final moment due to concentrated moment
        pl; % All plots of the object
        plane; % Index of the plane
        fy; % Resultant force in the upward direction (always = 0) 
        m0; % Moment about z=0
        f; %figure handle
    end
    methods
        function obj = con_m(pos,m,dir,plane,isprev)
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
            
            axes1.NextPlot = "add";
            obj.plane = plane;
            syms p L;
            pos = subs(pos,L,1)*L;
            m = subs(m,p,1);
            m = subs(m,L,1)*p*L^2;
            assume(L>0)
            assume(p>0)
            obj.p = pos;
            if strcmpi(dir,"ccw")
                obj.M = m;
                mark = '+';
                angle = 180;
                lw =  2;
                s = 50;
            elseif strcmpi(dir,"cw")
                obj.M = -m;
                mark = '.';
                angle = 0;
                lw = 3;
                s = 100;
            end
            
            x1 =  concentrated_moment(pos,obj.M);
            obj.final_moment = x1;
            obj.fy = 0;
            obj.m0 = obj.M;
            % plotting
            position = double(pos./L);
            magnitude = double(obj.M./p./L^2);
            [obj.pl,obj.f] = circular_arrow(axes1, 0.25 , [2.*position 0], angle , 180 , -sign(magnitude));
            pl2 = scatter(axes1,2.*position,0,s,'r',mark,'LineWidth',lw);
            obj.pl = [obj.pl pl2];
        end
    end
end