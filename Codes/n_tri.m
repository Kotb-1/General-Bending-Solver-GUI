% Class for normal triangle
% syntax:
% n_tri(p_i,p_f,v_f,plane,isprev)
% - p_i:    initial position; Coeff of L ; Example: 2 for position 2*L
% - p_f:    final position; Coeff of L ; Example: 4 for position 4*L
% - v_f:    final value is the Coeff of p ; Example: 2 for load of 2*p
% - plane:  input (1) for yz plane ; input (2) for xz plane
% - isprev:    (OPTIONAL): True (to plot original load only) or 
%                          False (to plot original & correction load)
classdef n_tri
    properties
        start; % Starting Position
        ending_tri; % Ending Position of Original Load
        ending_beam; % Length of the beam
        value_tri; % Value of Correction's large triangle
        value_rec; % Value of Correction's rectangle
        value_tri2; % Value of Correction's small triangle
        corr_start; % Starting Position of Correction's small triangle
        plane;% Index of the plane
        final_moment;% Final moment due to concentrated moment
        pl;% All plots of the object
        fy;% Resultant force in the upward direction
        m0;% Moment about z=0
    end
    methods
        function obj = n_tri(p_i,pf,vf,plane,isprev,istrap)
            global eb yz_axes xz_axes corraxes prevaxes;
            
            if nargin<6
                istrap = false;
            end
            if nargin<5
                isprev = true;
            end
            
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
            vf = subs(vf,p,1)*p;
            assume(L>0)
            assume(p>0)
            obj.start = p_i;
            obj.plane = plane;
            obj.ending_tri = pf;
            obj.ending_beam = eb;
            obj.value_tri = (vf./(pf-p_i)).*(eb-p_i);
            obj.corr_start = pf;
            obj.value_rec = -vf;
            obj.value_tri2 = -(obj.value_tri-vf);
            if pf~=eb
                x1 = s_tri(p_i,obj.value_tri,eb);
                x2 = s_tri(obj.corr_start,obj.value_tri2,eb);
                x3 = s_rec(obj.corr_start,obj.value_rec);
                obj.final_moment = x1-x2-x3;
            else 
                x1 = s_tri(p_i,vf,eb);
                obj.final_moment = x1;
            end
            obj.fy = -0.5*(pf-p_i)*vf;
            obj.m0 = obj.fy*(p_i+2*(pf-p_i)/3);
            % plotting
            pl1=[];
            pl2=[];
            pl3=[];
            pl4=[];
            pl5=[];
            pl6=[];
            p_i = double(p_i./L);
            pf = double(pf./L);
            eb2 = double(eb./L);
            vf = double(vf./p);
            pol = polyfit([p_i pf],[0 vf],1);
            x = linspace(p_i,pf,10);
            y = polyval(pol,x);
            y_vf = linspace(0,vf,10);
            x_pf = pf.*ones(size(y_vf));
            obj.pl = [];
            if ~istrap
                axes(axes1)
                pl1 = plot(axes1,2.*x,y,'-b',2.*x_pf,y_vf,'-b');
                c=1;
                for i = p_i+0.25:0.25:pf-0.25
                    x_v = i.*ones([10 1]);
                    y_v = linspace(0,polyval(pol,i),10);
                    pl2(c) = plot(axes1,2.*x_v,y_v,'-k');
                    c = c+1;
                end
                obj.pl = [pl1' pl2];
                if ~isprev
                    % correction plotting
                    corraxes.NextPlot = "add";
                    
                    x_corr1 = linspace(p_i,eb2,10);
                    y_corr1 = polyval(pol,x_corr1);
                    y_vf_corr1 = linspace(0,y_corr1(end),10);
                    x_pf_corr1 = eb2.*ones(size(y_vf_corr1));
                    pl3 = plot(corraxes,2.*x_corr1,y_corr1,'-b',2.*x_pf_corr1,y_vf_corr1,'-b');
                    c = 1;
                    for i = p_i+0.25:0.25:eb2-0.25
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,polyval(pol,i),10);
                        pl4(c) = plot(corraxes,2.*x_v,y_v,'-k');
                        c = c+1;
                    end
        
                    x_corr2 = linspace(pf,eb2,10);
                    y_corr2 = -polyval(pol,x_corr2);
                    y_vi_corr2 = linspace(0,-vf,10);
                    y_vf_corr2 = linspace(0,y_corr2(end),10);
                    x_pi_corr2 = pf.*ones(size(y_vi_corr2));
                    x_pf_corr2 = eb2.*ones(size(y_vf_corr2));
                    pl5 = plot(corraxes,2.*x_corr2,y_corr2,'-k',2.*x_pi_corr2,y_vi_corr2,'-k',2.*x_pf_corr2,y_vf_corr2,'-k');
                    c = 1;
                    for i = pf+0.25:0.25:eb2-0.25
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,-polyval(pol,i),10);
                        pl6(c) = plot(corraxes,2.*x_v,y_v,'-k');
                        c = c+1;
                    end
                    obj.pl = [obj.pl pl3' pl4 pl5' pl6];
                end
            end
        end
    end
end