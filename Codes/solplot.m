% Displaying the values of the unknowns
function pl = solplot(axes1,solutions)
names = fieldnames(solutions);
alleqs = {};
for i = 1:length(names)
    unk_name = names{i};
    unk_name = unk_name + "  =  ";
    unk = solutions.(names{i});
    unk = latex(unk);
    unk = "$$" + unk_name + string(unk) + "$$";
    alleqs{1,i} = unk; 
end
pl = text(axes1,2,10,alleqs,'interpreter', 'latex','FontSize',24);
end

