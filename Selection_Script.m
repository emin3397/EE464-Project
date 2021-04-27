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
D_max=0.48;
B_sat=0.3;
Kcu=0.4;%Winding factor
Fs=40e3;%37-50kHz
Skin_depth=75/sqrt(Fs);%Skin depth in mm
KRF=0.6;%Input current ripple factor
Current_Density=4;%Current Density A/mm^2

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
d_air_gap=@(Ae)u_0*N1_selected^2*Ae*1e-4/Lm; %required air gap in mm;

Ae=pi*10.9^2;%mm^2

N1_selected=ceil(N1_min(Ae));
N2_calc=N1_selected/n;
d_air_gap_calc=d_air_gap(Ae);

N1_wire_len=N1_selected*2*pi*sqrt(Ae/pi);
N2_wire_len=N1_selected/n*2*pi*sqrt(Ae/pi);
N3_wire_len=N2_wire_len;

wire_area_N1=N1_selected*I_sw_max/Current_Density; %mm^2
wire_area_N2=N2_wire_len*I_out_avg/Current_Density;%mm^2
wire_area_N3=N3_wire_len*100e-3/Current_Density;%mm^2

Total_wire_area=wire_area_N1+wire_area_N2+wire_area_N3;
winding_window_area=Total_wire_area/Kcu; %mm^2
winding_window_height=sqrt(Total_wire_area);

Transformer_Volume=winding_window_height*winding_window_area*5; %mm^3;