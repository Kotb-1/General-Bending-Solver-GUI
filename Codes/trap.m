%Class for trapezoid distributed load
% syntax:
% trap(p_i,p_f,v_i,v_f,plane,isprev)
% - p_i:    initial position; Coeff of L ; Example: 2 for position 2*L
% - p_f:    final position; Coeff of L ; Example: 4 for position 4*L
% - v_i:    initial value is the Coeff of p ; Example: 2 for load of 2*p
% - v_f:    final value is the Coeff of p ; Example: 3 for load of 3*p
% - plane:  input (1) for yz plane ; input (2) for xz plane
% - isprev:    (OPTIONAL): True (to plot original load only) or 
%                          False (to plot original & correction load)
classdef trap
    properties
        start; %strating position for distributed load (pi)
        ending_beam; %beam length (eb)
        value1; %trapezoid value from left
        value2; %Trapezoid value from right
        corr_start; %Correction intatiating position
        plane; %Plane of action
        final_moment;% Final moment due to supports reaction
        pl;% All plots of the object
        fy;% Resultant force in the upward direction
        m0;% Moment about z=0
    end
    methods
        function obj = trap(p_i,pf,v1,v2,plane,isprev)
            if nargin<6
                isprev = true;
            end
            
            global eb yz_axes xz_axes corraxes prevaxes;
            axes2 = corraxes;
            if plane == 1 && isprev
                axes1 = yz_axes;
            elseif plane == 2 && isprev
                axes1 = xz_axes;
            elseif ~isprev
                axes1 = prevaxes;
            end
            axes1.NextPlot = "add";
            
            syms p L;
            p_i = subs(p_i,L,1)*L;
            pf = subs(pf,L,1)*L;
            v1 = subs(v1,p,1)*p;
            v2 = subs(v2,p,1)*p;
            assume(L>0)
            assume(p>0)
            obj.start = p_i;
            obj.plane = plane;
            obj.ending_beam = eb;
            obj.corr_start = pf;
            obj.value1 = v1;
            obj.value2 = v2;
            obj.pl=[];
            vi = double(v1./p);
            vf = double(v2./p);
            obj.fy = -0.5*(pf-p_i)*(v1+v2);
            if abs(vf)>abs(vi)
                x1 = rec(p_i,pf,vi,plane,false,true,false);
                x2 = n_tri(p_i,pf,vf-vi,plane,isprev,true);
                obj.final_moment = x1.final_moment+x2.final_moment;
                obj.pl = [obj.pl x1.pl x2.pl];
                m1 = -(pf-p_i)*(v1)*(p_i+0.5*(pf-p_i));
                m2 = -0.5*(pf-p_i)*(v2-v1)*(p_i+2*(pf-p_i)/3);
                obj.m0 = m1+m2;
            else
                x1 = rec(p_i,pf,vf,plane,isprev,false,true);
                x2 = rev_tri(p_i,pf,vi-vf,plane,isprev,true,vf);
                obj.final_moment = x1.final_moment+x2.final_moment;
                obj.pl = [obj.pl x1.pl x2.pl];
                m1 = -(pf-p_i)*(v2)*(p_i+0.5*(pf-p_i));
                m2 = -0.5*(pf-p_i)*(v1-v2)*(p_i+(pf-p_i)/3);
                obj.m0 = m1+m2;
            end
            p_i = double(p_i./L);
            pf = double(pf./L);
            eb2 = double(eb./L);
            
            pol = polyfit([p_i pf],[vi vf],1);
            x = linspace(p_i,pf,10);
            y = polyval(pol,x);
            y_vi = linspace(0,vi,10);
            y_vf = linspace(0,vf,10);
            x_pi = p_i.*ones(size(y_vi));
            x_pf = pf.*ones(size(y_vf));
            pl1 = plot(axes1,2.*x,y,'-b',2.*x_pi,y_vi,'-b',2.*x_pf,y_vf,'-b');
            c=1;
            pl2=[];pl3=[];pl4=[];pl5=[];pl6=[];
            for i = p_i+0.25:0.25:pf-0.25
                    x_v = i.*ones([10 1]);
                    y_v = linspace(0,polyval(pol,i),10);
                    pl2(c) = plot(axes1,2.*x_v,y_v,'-k');
                    c = c+1;
            end
            obj.pl = [obj.pl pl1' pl2];
            % correction
            if ~isprev
                axes2.NextPlot = "add";
                if abs(vf)>abs(vi)
                    % positive
                    x1 = linspace(p_i,eb2,10);
                    y1 = polyval(pol,x1);
                    y_vi1 = linspace(0,vi,10);
                    y_vf1 = linspace(0,y1(end),10);
                    x_pi1 = p_i.*ones(size(y_vi1));
                    x_pf1 = eb2.*ones(size(y_vf1));
                    pl3 = plot(axes2,2.*x1,y1,'-b',2.*x_pi1,y_vi1,'-b',2.*x_pf1,y_vf1,'-b');
                    c=1;
                    for i = p_i+0.25:0.25:eb2-0.25
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,polyval(pol,i),10);
                        pl4(c) = plot(axes2,2.*x_v,y_v,'-k');
                        c = c+1;
                    end
                    % negative
                    x2 = linspace(pf,eb2,10);
                    y2 = -polyval(pol,x2);
                    y_vi2 = -linspace(0,vf,10);
                    y_vf2 = linspace(0,y2(end),10);
                    x_pi2 = pf.*ones(size(y_vi2));
                    x_pf2 = eb2.*ones(size(y_vf2));
                    pl5 = plot(axes2,2.*x2,y2,'-b',2.*x_pi2,y_vi2,'-b',2.*x_pf2,y_vf2,'-b');
                    c=1;
                    for i = pf+0.25:0.25:eb2-0.25
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,-polyval(pol,i),10);
                        pl6(c) = plot(axes2,2.*x_v,y_v,'-k');
                        c = c+1;
                    end
                    obj.pl = [obj.pl pl3' pl4 pl5' pl6];
                end
            end
        end
    end
end