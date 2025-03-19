% Final Function
% Syntax:
%       [Mx,My,Sx,Sy,v,v_dash,u,u_dash,solutions,isyz,isxz] = Structure_Project(supports,loads)
% Where:
%   Outputs:
%       Mx:         Moment in Y-Z plane
%       My:         Moment in X-Z plane
%       v:          Deflection in Y direction
%       v_dash:     Slope of deflection in Y
%       u:          Deflection in X direction
%       u_dash:     Slope of deflection in X
%       solutions:  Struct for Values of Unknowns
%       isyz:       True if Y-Z plane has loads or supports
%       isxz:       True if X-Z plane has loads or supports
%
%   Inputs:
%       supports:    A cell array containing all Supports
%       loads:          A cell array containing all Loads


function [Mx,My,Sx,Sy,v,v_dash,u,u_dash,solutions,isyz,isxz] = Main_Solver(supports,loads)
    %% Variables Declaration
    global eb w Is;

    syms L Z c1 c2 c3 c4 p E d t dumdum;

    assume(L>0)
    assume(p>0)
    assume(Z>0)

    if ~isempty(w) && ~isempty(Is)
        if strcmpi(w,'I')
            Ix    = Is(1)*t*d^3;
            Iy    = Is(2)*t*d^3;
            Ixy   = Is(3)*t*d^3;
            K_bar = Ix*Iy-Ixy^2;
            kx    = Ix/K_bar;
            ky    = Iy/K_bar;
            kxy   = Ixy/K_bar;
        elseif strcmpi(w,'k')
            kx  = Is(1)/t/d^3;
            ky  = Is(2)/t/d^3;
            kxy = Is(3)/t/d^3;
        end
    else
        syms kx ky kxy
    end
    
    %% Moment creation
    MMs=[]; %Symbolic moments
    RRs = []; %Symbolic Reactions

    z_u = [];
    z_v = [];
    z_ud = [];
    z_vd = [];
    u_value = [];
    v_value = [];
    ud_value = [];
    vd_value = [];
    fi = length(supports); % number of unknown reactions
    Mx = 0;
    My = 0;
    Fy = 0;
    Fx = 0;
    m01 = 0;
    m02 = 0;
    
    isyz = false;
    isxz = false;

    for i = 1:length(supports)
        c_conc = supports{i};
        RRs = [RRs c_conc.R];%#ok<AGROW>
        if c_conc.plane == 1
            if c_conc.p~=eb
                Mx = Mx+ c_conc.final_moment;
            end
            Fy = Fy + c_conc.fy;
            m01 = m01+c_conc.m0;
            isyz = true;
        end
        if c_conc.plane == 2
            if c_conc.p~=eb
                My = My+ c_conc.final_moment;
            end
            Fx = Fx + c_conc.fy;
            m02 = m02+c_conc.m0;
            isxz = true;
        end
        if ~isnan(c_conc.u)
            z_u = [z_u;c_conc.p];%#ok<AGROW>
            u_value = [u_value;c_conc.u];%#ok<AGROW>
        end
        if ~isnan(c_conc.v)
            z_v = [z_v;c_conc.p];%#ok<AGROW>
            v_value = [v_value;c_conc.v];%#ok<AGROW>
        end
        if ~isnan(c_conc.u_dash)
            z_ud = [z_ud;c_conc.p];%#ok<AGROW>
            ud_value = [ud_value;c_conc.u_dash];%#ok<AGROW>
        end
        if ~isnan(c_conc.v_dash)
            z_vd = [z_vd;c_conc.p];%#ok<AGROW>
            vd_value = [vd_value;c_conc.v_dash];%#ok<AGROW>
        end
        if isa(c_conc,'fixed')
            MMs = [MMs c_conc.M];%#ok<AGROW>
        end
    end

    for i = 1:length(loads)
        c_load = loads{i};
        if c_load.plane == 1
            Mx = Mx+ c_load.final_moment;
            Fy = Fy + c_load.fy;
            m01 = m01+c_load.m0;
            isyz = true;
        end
        if c_load.plane == 2
            My = My+ c_load.final_moment;
            Fx = Fx + c_load.fy;
            m02 = m02+ c_load.m0;
            isxz = true;
        end
    end

    unknowns = [c1 c2 c3 c4 RRs MMs];
    trans = -1./E.*[-kxy,kx;ky,-kxy]*[Mx;My];
    Mx_ph = Mx;
    My_ph = My;

    if Mx~=0
        Mx = Mx + dumdum;
        Mx = children(Mx);
    end
    if My~=0
        My = My + dumdum;
        My = children(My);
    end
    
    Mx1i = int(Mx,Z);
    Mx2i = int(Mx1i,Z);
    My1i = int(My,Z);
    My2i = int(My1i,Z);
    Mx1 = sum([Mx1i(:)])+c1;
    Mx2 = sum([Mx2i(:)])+c1*Z+c2;
    My1 = sum([My1i(:)])+c3;
    My2 = sum([My2i(:)])+c3*Z+c4;
    Mx1 = subs(Mx1,dumdum,0);
    Mx2 = subs(Mx2,dumdum,0);
    My1 = subs(My1,dumdum,0);
    My2 = subs(My2,dumdum,0);
    trans1 = -1./E.*[-kxy,kx;ky,-kxy]*[Mx1;My1];
    trans2 = -1./E.*[-kxy,kx;ky,-kxy]*[Mx2;My2];
    u2_dash = trans(1);
    v2_dash = trans(2);
    u_dash = trans1(1);
    v_dash = trans1(2);
    u = trans2(1);
    v = trans2(2);

    if isyz && ~isxz
        eqns = [subs(v_dash,Z,z_vd)==vd_value ; subs(v,Z,z_v)==v_value ; Fy == 0; m01 == 0];
    elseif isxz && ~isyz
        eqns = [subs(u_dash,Z,z_ud)==ud_value ; subs(u,Z,z_u)==u_value ; Fx == 0; m02 == 0];
    elseif isyz && isxz
        eqns = [subs(v_dash,Z,z_vd)==vd_value ; subs(v,Z,z_v)==v_value ; Fy == 0; m01 == 0 ;subs(u_dash,Z,z_ud)==ud_value ; subs(u,Z,z_u)==u_value ;Fx == 0; m02 == 0];
    end

    solutions = solve(eqns,unknowns);
    Mx = Mx_ph;
    My = My_ph;
    D = digits(7); %for better display

    for i = 1:length(unknowns)
        unknown.var = char(unknowns(i));
        current = vpa(solutions.(unknown.var));
        Mx = subs(Mx,unknowns(i),current);
        My = subs(My,unknowns(i),current);
        v = subs(v,unknowns(i),current);
        u = subs(u,unknowns(i),current);
        u_dash = subs(u_dash,unknowns(i),current);
        v_dash = subs(v_dash,unknowns(i),current);
    end
    Sx = diff(My,Z);
    Sy = diff(Mx,Z);
    digits(D);
end