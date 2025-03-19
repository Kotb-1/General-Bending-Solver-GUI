% Converting equations into latex to be displayed
function pl = momentdisp(axes1,solutions)
names = fieldnames(solutions);
alleqs = [];
gl = [];
for i = 1:length(names)
    unk_name = names{i};
    unk_name = unk_name + "  =  ";
    unk = solutions.(names{i});
    unk = latex(unk);
   
    unk = [gl , "$$" + unk_name + string(unk) + "$$"];
    
    unk = strrep(unk,"\mathrm{ky}","K_y");
    unk = strrep(unk,"\mathrm{kx}","K_x");
    unk = strrep(unk,"\mathrm{kxy}","K_{xy}");
    unk = strrep(unk,"(\frac{\mathrm{sign}\left(","({-[Z-");
    unk = strrep(unk,"\,L-Z\right)}{2}-\frac{1}{2}\right)","L]^0}\right)");
    unk = strrep(unk,"L-Z\right)}{2}-\frac{1}{2}\right)","L]^0}\right)");
    unk = strrep(unk,"(\mathrm{sign}\left(","({-2[Z-");
    unk = strrep(unk,"\,L-Z\right)-1\right)","L]^0}\right)");
    unk = strrep(unk,"L-Z\right)-1\right)","L]^0}\right)");
    unk = strrep(unk,"\right)}{E}$$",") $$");
    unk = strrep(unk,"\frac{K_y\,\left","\frac{K_y}{E}\,");
    unk = strrep(unk,"\frac{K_x\,\left","\frac{K_x}{E}\,");
    unk = strrep(unk,"\frac{K_{xy}\,\left","\frac{K_{xy}}{E}\,");
    unk = strrep(unk,"\left(","(");
    unk = strrep(unk,"\right)",")");
    unk = strrep(unk,"(","\left(");
    unk = strrep(unk,")","\right)");
    pl1(1,i) = text(axes1,2,18-2*i,unk,'interpreter', 'latex','FontSize',24);
    gl = [gl  , " ", newline];
        % alleqs = [alleqs,unk];
    
end
pl = pl1;
end