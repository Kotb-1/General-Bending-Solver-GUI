% Resets certain axes to have the beam only
function preview_reset()
global eb prevaxes corraxes;
    
syms L;
beam_domain = 0:0.1:double(eb./L);

prevaxes.NextPlot = "Replace";
corraxes.NextPlot = "Replace";
plot(prevaxes,2*beam_domain,zeros(length(beam_domain)),'LineWidth',3)

plot(corraxes,2*beam_domain,zeros(length(beam_domain)),'LineWidth',3)
prevaxes.NextPlot = "add";
corraxes.NextPlot = "add";
tick_change(prevaxes);
tick_change(corraxes);

end