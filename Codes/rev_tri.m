% Reverse triangle class
% syntax:
% rev_tri(p_i,p_f,v_i,plane,isprev)
% - p_i:    initial position; Coeff of L ; Example: 2 for position 2*L
% - p_f:    final position; Coeff of L ; Example: 4 for position 4*L
% - v_i:    initial value is the Coeff of p ; Example: 2 for load of 2*p
% - plane:  input (1) for yz plane ; input (2) for xz plane
% - isprev:    (OPTIONAL): True (to plot original load only) or 
%                          False (to plot original & correction load)
classdef rev_tri
    properties
        start; % strating position
        ending_tri; % ending position
        ending_beam; % beam length
        value_tri; % value of correction's large triangle
        value_rec; % correction rectangle value
        value_tri2; % value of correction's small triangle
        corr_start; % strating position of the small triangle correction
        plane;% Index of the plane
        final_moment;% Final moment due to concentrated moment
        pl;% All plots of the object
        fy;% Resultant force in the upward direction
        m0;% Moment about z=0
    end
    methods
        function obj = rev_tri(p_i,pf,vi,plane,isprev,istrap,vf)
            global eb yz_axes xz_axes prevaxes corraxes;
            axes2 = corraxes;
            if nargin<6
                istrap = false;
            end
            if nargin<7
                vf = 0;
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
            vi = subs(vi,p,1)*p;
            assume(L>0)
            assume(p>0)
            obj.start = p_i;
            obj.plane = plane;
            obj.ending_tri = pf;
            obj.ending_beam = eb;
            obj.value_tri = (vi./(-p_i+pf)).*(eb-p_i);
            obj.corr_start = p_i;
            obj.value_rec = vi;
            obj.value_tri2 = obj.value_tri-vi;
            x1 = s_tri(p_i,obj.value_tri,eb);
            x2 = s_tri(pf,obj.value_tri2,eb);
            x3 = s_rec(obj.corr_start,obj.value_rec);
            obj.final_moment = -x1+x2+x3;
            obj.fy = -0.5*(pf-p_i)*vi;
            obj.m0 = obj.fy*(p_i+(pf-p_i)/3);


            % plotting
            obj.pl =[];
            pl1=[];
            pl2=[];
            pl3=[];
            pl4=[];
            pl5=[];
            pl6=[];
            pl7=[];
            pl8=[];
            pl9=[];
            p_i = double(p_i./L);
            pf = double(pf./L);
            eb2 = double(eb./L);
            vi = double(vi./p);
            pol = polyfit([p_i pf],[vi 0],1);
            x = linspace(p_i,pf,10);
            y = polyval(pol,x);
            y_vf = linspace(0,vi,10);
            x_pi = p_i.*ones(size(y_vf));
            if ~istrap
               pl1= plot(axes1,2.*x,y,'-b',2.*x_pi,y_vf,'-b');
               obj.pl = [obj.pl pl1'];
               c=1;
                for i = p_i+0.25:0.25:pf-0.25
                   x_v = i.*ones([10 1]);
                   y_v = linspace(0,polyval(pol,i),10);
                   pl2(c) = plot(axes1,2.*x_v,y_v,'-k');
                   c = c+1;
                end
                obj.pl = [obj.pl pl2];
            end
            if ~isprev
                axes2.NextPlot = "add";
                % correction plotting
                pol = polyfit([p_i pf],[0 vi],1);
                x_corr01 = linspace(p_i,pf,10);
                x_corr02 = linspace(pf,eb2,10);
                y_corr1 = [-polyval(pol,x_corr01) -polyval(pol,x_corr02)-vf];
                y_vf_corr01 = linspace(0,y_corr1(end),10);
                y_vf_corr02 = linspace(0,y_corr1(11),10);
                x_pf_corr01 = eb2.*ones(size(y_vf_corr01));
                x_pf_corr02 = pf.*ones(size(y_vf_corr02));
                pl3 = plot(axes2,2.*[x_corr01 x_corr02],y_corr1,'-k',2.*x_pf_corr01,y_vf_corr01,'-k',2.*x_pf_corr02,y_vf_corr02,'-k');
                c=1;
                for i = p_i+0.25:0.25:pf-0.25
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,-polyval(pol,i),10);
                        pl4(c) = plot(axes2,2.*x_v,y_v,'-k');
                        c = c+1;
                end
                c=1;
                for i = pf:0.25:eb2-0.25
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,-polyval(pol,i)-vf,10);
                        pl5(c) = plot(axes2,2.*x_v,y_v,'-k');
                        c = c+1;
                end
                
                x_corr2 = linspace(pf,eb2,10);
                y_corr2 = polyval(pol,(x_corr2+p_i-pf))+vf+vi;
                y_vf_corr2 = linspace(vf+vi,y_corr2(end),10);
                x_pf_corr2 = eb2.*ones(size(y_vf_corr2));
                pl6=plot(axes2,2.*x_corr2,y_corr2,'-k',2.*x_pf_corr2,y_vf_corr2,'-k');
    
                % rec
                y_vf2 = linspace(vf,vi+vf,10);
                y_rec = x_corr01.^0.*vi+vf;
                x_eb = eb2.*ones(size(y_vf2));
                pl7 = plot(axes2,2.*x_corr01,y_rec,'-k',2.*x_pi,y_vf2,'-k',2.*x_eb,y_vf2,'-k');
                c=1;
                for i = p_i+0.25:0.25:pf-0.25
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,vi+vf,10);
                        pl8(c) = plot(axes2,2.*x_v,y_v,'-k');
                        c = c+1;
                end
                c=1;
                for i = pf:0.25:eb2-0.25
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,polyval(pol,(i+p_i-pf))+vf+vi,10);
                        pl9(c) = plot(axes2,2.*x_v,y_v,'-k');
                        c = c+1;
                end
                obj.pl = [obj.pl pl3' pl4 pl5 pl6' pl7' pl8 pl9];
            end
        end
    end
end