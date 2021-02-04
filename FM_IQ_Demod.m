function [y_FM_demodulated] = FM_IQ_Demod(y)
%This function demodualtes an FM signal. It is assumed that the FM signal
%is complex (e.g. an IQ signal) centered at DC and occupies less than 90%
%of total bandwidth. 

% LPF Filter Values
Fpass1 = 0;
Fpass2 = .883;
Fstop1 = .8832;
Fstop2 = 1;
fs = 2.5;

% Attempted Filters %
%b = firls(60,[0 .9],[0 1],'differentiator'); % Differentiator 1 
%b = firls(60,[0 .881 .885 1],[0 .2 0 0],[1 1000],'differentiator'); %Differentiator 2 
%b = firls(20,[Fpass1 Fpass2 Fstop1 Fstop2]*(2/fs),[0 .2 0 0],[1 10000],'differentiator'); %design differentiater
%b = firls(6,[Fpass1 Fpass2 Fstop1 Fstop2]*(2/fs),[1 1 0 0],[1 1000]); %LPF

% Working Filter %
b = firls(20,[Fpass1 Fpass2 Fstop1 Fstop2]*(2/fs),[0 .2 0 0],[1 10000],'differentiator'); %design differentiater

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Debug to plot Filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% samples=25E6;% samples/fs = 10 sec
% t = (-0.5:1/samples:0.5-1/samples)*fs; % Normalized freq range 
% figure(85)
% y_conv_fft1 = 20*log10(fftshift(abs(fft(b,samples))));
% y_conv_fft2 = 20*log10(fftshift(abs(fft(b1,samples))));
% plot(t,y_conv_fft1)
% hold on
% plot(t,y)
% figure(86)
% plot(t,y_conv_fft2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=normalize(y);%normalize the signal to put in unit circle range 
realsignal=real(d); %real part of normalized siganl.
imagsignal=imag(d); %imaginary part of normalized signal. 
% Demod Formula: 
% Take Real * Conv(Imaginary w/ Filter) - Imaginary * Conv(Real w/ Filter)
% Then Divide by Magnitude(Signal)

y_FM_demodulated=(realsignal.*conv(imagsignal,b,'same')-imagsignal.*conv(realsignal,b,'same'))./(realsignal.^2+imagsignal.^2);%demodulate!

end
