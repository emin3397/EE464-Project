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
D_max=0.4;
B_sat=0.3;
Kcu=0.5;%Winding factor
Fs=40e3;%37-50kHz
Skin_depth=75/Fs;%Skin depth in mm
KRF=0.6;%Input current ripple factor
J_current=4;%Current Density A/mm^2

u_r=1500;
u_0=4*pi*1e-7;

%Equations
n=ceil((Vin_min-V_sw_on)/(Vout+V_diode_on)*D_max/(1-D_max)); %N1/N2
D_min=1/((Vin_max-V_sw_on)/((Vout+V_diode_on)*n)+1);

Lm=(Vin_min*D_max)^2/(2*Pout*Fs*KRF);
D_IL=Vin_min*D_max/(Fs*Lm);
I_sw_max=Pout/(Vin_min*D_max)+D_IL/2;

%Transformer Design
N1_min=@(Ae)Lm*I_sw_max*1e6/(B_sat*Ae); %Function to calculate Primary turn input is area of core Ae in mm^2

N1_selected=n;
d_air_gap=@(Ae)u_0*u_r*N1_selected^2*Ae*1e-4/Lm; %required air gap in mm;
