%%Flyback Converter

%Circuit Parameters
Vin_min=220;
Vin_max=400;
Vout=12;
Pout=100;
R_Load=Vout^2/Pout;
I_out_avg=Pout/Vout;

V_sw_on=0.2;%Mosfet on voltage
V_diode_on=0.8;%Diode forward voltage drop

%Limitations
Vout_ripple=4/100;% output ripple
D_max=0.48;
B_sat=0.3;
Kcu=0.4;%Winding factor
Fs=40e3;%37-50kHz   
Skin_depth=75/sqrt(Fs);%Skin depth in mm
KRF=0.6;%Input current ripple factor
Current_Density=4;%Current Density A/mm^2
K_margin=1.25;
u_r=1500;
u_0=4*pi*1e-7;

%Equations
n=ceil((Vin_min-V_sw_on)/(Vout+V_diode_on)*D_max/(1-D_max)); %N1/N2
D_min=1/((Vin_max-V_sw_on)/((Vout+V_diode_on)*n)+1);

Lm=(Vin_min*D_max)^2/(2*Pout*Fs*KRF);
D_IL=Vin_min*D_max/(Fs*Lm);

I_sw_max=Pout/(Vin_min*D_max)+D_IL/2;
Vds_max=Vin_max/(1-D_min);

C_out=I_out_avg*D_max/(Vout_ripple*Vout*Fs);

I_Diode=I_out_avg;

%Transformer Design E-core with gap
N1_min=@(Ae)Lm*I_sw_max*1e6/(B_sat*Ae); %Function to calculate Primary turn input is area of core Ae in mm^2
d_air_gap=@(Ae)u_0*N1_selected^2*Ae*1e-4/Lm; %required air gap in mm;

Ae=234;%pi*7.68^2;%mm^2

N1_selected=ceil(N1_min(Ae));
N2_calc=round(N1_selected/n);
d_air_gap_calc=d_air_gap(Ae);

N1_wire_len=N1_selected*2*pi*sqrt(Ae/pi);
N2_wire_len=N1_selected/n*2*pi*sqrt(Ae/pi);
N3_wire_len=N2_wire_len;

wire_area_N1=N1_selected*I_sw_max/Current_Density; %mm^2
wire_area_N2=N2_calc*I_out_avg/Current_Density;%mm^2
wire_area_N3=N2_calc*100e-3/Current_Density;%mm^2

Total_wire_area=wire_area_N1+wire_area_N2+wire_area_N3;
winding_window_area=Total_wire_area/Kcu; %mm^2
winding_window_height=sqrt(Total_wire_area);

Transformer_Volume=winding_window_height*winding_window_area*6; %mm^3;

%AWG Area in mm^2 List 1-40
AWG_Area=[42.4 33.6 26.7 21.2 16.8 13.3 10.5 8.37 6.63 5.26 4.17 3.31 2.62 2.08 1.165 1.31 1.04 0.823 0.653 0.518 0.41 0.326 0.258 0.205 0.162 0.129 0.102 0.081 0.0642 0.0509 0.0404 0.032 0.0254 0.0201 0.016 0.0127 0.01 0.00797 0.00632 0.00501];
[minValue,N1_AWG] =min(abs(AWG_Area-I_sw_max/Current_Density));
[minValue2,N2_AWG] =min(abs(AWG_Area-I_out_avg/Current_Density));
N3_AWG=length(AWG_Area);
% Result Section

fprintf("Mosfet V_DS(on)=%0.2fV I_DS(on)=%0.2f\n",Vds_max*K_margin,I_sw_max*K_margin);
fprintf("Diode V_D(reverse)=%0.2fV I_D(on)=%0.2fA\n",2*Vds_max*K_margin/n,I_out_avg*K_margin);
fprintf("Output Capacitance=%0.2fuF\n",C_out*1e6*K_margin);

fprintf("Transformer N1 Turns=%d Cable=AWG%d Length=%0.2fm\n",N1_selected,N1_AWG,N1_wire_len*K_margin*1e-3);
fprintf("Transformer N2 Turns=%d Cable=AWG%d Length=%0.2fm\n",N2_calc,N2_AWG,N2_wire_len*K_margin*1e-3);
fprintf("Transformer N3 Turns=%d Cable=AWG%d Length=%0.2fm\n",N2_calc,N3_AWG,N3_wire_len*K_margin*1e-3);
fprintf("Transformer Winding window area=%0.2fmm^2 Air gap=%0.2fmm, Ae=%0.2fmm^2 Estimated Volume=%0.2fmm^3\n",winding_window_area,d_air_gap_calc,Ae,Transformer_Volume);
fprintf("Transformer Lm=%0.2fmH Fs=%dkHz\n",Lm*1e3,Fs);



