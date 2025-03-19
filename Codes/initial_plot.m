% Initial plots for the beam
function pl = initial_plot( )
global eb yz_axes xz_axes Mx_axes My_axes Sx_axes Sy_axes v_axes u_axes corraxes prevaxes;
    
syms L;
beam_domain = 0:0.1:double(eb./L);

pl1 = plot(yz_axes,2*beam_domain,zeros(length(beam_domain)),'LineWidth',3);

pl2 = plot(xz_axes,2*beam_domain,zeros(length(beam_domain)),'LineWidth',3);

pl3 = plot(prevaxes,2*beam_domain,zeros(length(beam_domain)),'LineWidth',3);

pl4 = plot(corraxes,2*beam_domain,zeros(length(beam_domain)),'LineWidth',3);

pl5 = plot(Mx_axes,beam_domain,zeros(length(beam_domain)),'LineWidth',3);

pl6 = plot(My_axes,beam_domain,zeros(length(beam_domain)),'LineWidth',3);
 
pl7 = plot(Sy_axes,beam_domain,zeros(length(beam_domain)),'LineWidth',3);

pl8 = plot(Sx_axes,beam_domain,zeros(length(beam_domain)),'LineWidth',3);

pl9 = plot(v_axes,beam_domain,zeros(length(beam_domain)),'LineWidth',3);
 
pl10 = plot(u_axes,beam_domain,zeros(length(beam_domain)),'LineWidth',3);

pl = [pl1 pl2 pl3 pl4 pl5 pl6 pl7 pl8 pl9 pl10];
end