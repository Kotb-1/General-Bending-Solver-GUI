% Getting Numeric data for plotting
function Mx_plot = sub_plot(Mx,Z_plot)
    syms Z L kx ky kxy d t p E;
    Mx_plot = subs(Mx,Z,Z_plot);
    Mx_plot = subs(Mx_plot,L,1);
    Mx_plot = subs(Mx_plot,kxy,1);
    Mx_plot = subs(Mx_plot,kx,1);
    Mx_plot = subs(Mx_plot,ky,1);
    Mx_plot = subs(Mx_plot,d,1);
    Mx_plot = subs(Mx_plot,t,1);
    Mx_plot = subs(Mx_plot,E,1);
    Mx_plot = double(subs(Mx_plot,p,1));
end