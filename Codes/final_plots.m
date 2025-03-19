% a function that plots Moment, Shear, and Deflection
function [pl,data] = final_plots(Mx,My,Sx,Sy,v,u,isyz,isxz,v_dash,u_dash)
global eb Mx_axes My_axes Sx_axes Sy_axes v_axes u_axes;
syms L Z p;
    Z_plot = (0:0.01:double(eb./L))';
    pl = [];
    if isxz
        My_disc = feval(symengine,'discont',My,Z);
        Sx_disc = feval(symengine,'discont',Sx,Z);
        My_plot = sub_plot(My,Z_plot);
        Sx_plot = sub_plot(Sx,Z_plot);
        pl1 = plot(My_axes,Z_plot,My_plot,'-b','LineWidth',1.5);
        pl2 = plot(Sx_axes,Z_plot,Sx_plot,'-b','LineWidth',1.5);
        pl3 = disc_fix(Sx,Sx_disc,Sx_axes);
        pl = [pl,pl1,pl2,pl3];
    end
    
    if isyz
        Mx_disc = feval(symengine,'discont',Mx,Z);
        Sy_disc = feval(symengine,'discont',Sy,Z);
        Mx_plot = sub_plot(Mx,Z_plot);
        Sy_plot = sub_plot(Sy,Z_plot);
        pl4 = plot(Mx_axes,Z_plot,Mx_plot,'-b','LineWidth',1.5);
        pl5 = plot(Sy_axes,Z_plot,Sy_plot,'-b','LineWidth',1.5);
        pl6 = disc_fix(Sy,Sy_disc,Sy_axes);
        pl = [pl,pl4,pl5,pl6];
    end
    vd = sub_plot(v_dash,Z_plot);
    ud = sub_plot(u_dash,Z_plot);
    v_plot = sub_plot(v,Z_plot);
    pl7 = plot(v_axes,Z_plot,v_plot,'-b','LineWidth',1.5);
    u_plot = sub_plot(u,Z_plot);
    pl8 = plot(u_axes,Z_plot,u_plot,'-b','LineWidth',1.5);
    pl = [pl,pl7,pl8];
    datai = [Z_plot,v_plot,vd,u_plot,ud];
    b=1;
    for i = 1:length(Z_plot)
        if mod(i,10)==1
            data(b,:) = datai(i,:);
            b = b+1;
        end
    end
end