% fixing curve dicontinuity
function pl = disc_fix(X,d_data,axes)
pl = [];
    if isempty(d_data)
        
        return;
    end
    axes.NextPlot = "add";
    syms L Z p kx kxy ky d t;
    d2 = d_data(:)./L;
    for i = 1:length(d2)
        x_ver = d2(i).*ones([10,1]);
        y1 = subs(X,Z,d_data(i)-0.01.*L);
        y1 = subs(y1,L,1);
        y1 = subs(y1,kxy,1);
        y1 = subs(y1,ky,1);
        y1 = subs(y1,kx,1);
        y1 = subs(y1,d,1);
        y1 = subs(y1,t,1);
        y1 = double(y1./p);
        y2 = subs(X,Z,d_data(i)+0.01.*L);
        y2 = subs(y2,L,1);
        y2 = subs(y2,kxy,1);
        y2 = subs(y2,ky,1);
        y2 = subs(y2,kx,1);
        y2 = subs(y2,d,1);
        y2 = subs(y2,t,1);
        y2 = double(y2./p);
        y_ver = linspace(y1,y2,10);
        pl1 = plot(axes,x_ver,y_ver,'--b','LineWidth',2);
        pl = [pl,pl1];
    end
end
