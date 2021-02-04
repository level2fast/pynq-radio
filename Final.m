fmdata=loadFile('FM.dat');

size(fmdata); % Check size of file

figure(1)
freqz(fmdata(1:5000),1,[-4E6:.01E6:4E6],2.5E6);
set(gcf,'color','white');
title('Magnitude and Phase Shift Plot FFT of Full IQ Data')

figure(2)
spectrogram(fmdata,100000,3000,[-1.25E6:.02E6:1.25E6],2.5E6,'yaxis');
title('Specctrogram Plot of Radio Stations within IQ Data')

firstsample=1; % start @ first sample
filterlength=.002*2.5E6; % filter length is 2 milliseconds for each sample
fs=2.5E6; % sampling frequency
centerfreq=88.3E6; %#1: Works for Jazz Stations 88.3FM

figure(3)
plot_FFT_IQ(fmdata,firstsample,filterlength,fs,centerfreq,'Magnitude and Phase Shift Plot FFT of IQ Data @ Center Freq'); % FFT of IQ data @ Center Freq
title('Magnitude and Phase Shift Plot FFT of IQ Data @ Center Freq')
desiredfreq=88.3E6;  %#1 : Works for Jazz 83.3FM (Clear Signal)
%desiredfreq=87.7E6; %#2 : Works for Spanish Station 87.7FM (Noisy)
%desiredfreq=89.5E6; %#3 : Works for Classical 89.5FM (Noisy)

deltafreq=desiredfreq-centerfreq; % Frequency to shift by to get to other radio staions
signallength=[1:1:length(fmdata)]; % length of data
bandwidth=2.5E6; % Bandwidth of signal captured 
theta=deltafreq*signallength/bandwidth; % e^-jwt: theta = wt 
y_shifted=fmdata.*transpose(exp(-j*2*pi*theta)); % transpose to have same NxM Matrix Dimension

%%%%%%%%%%%% Low Pass Filter Before Decimation to Remove other Radio Stations %%%%%%%%%%%%
fs= 2.5E6; % Sampling Freq of Filter
Fpass1=0; % Passband Start
Fpass2=.883E6; % Passband end @ 88.3FM
Fstop1=.8832E6;% Stopband begin @ 88.32FM
Fstop2=2.5E6; % Stopband end @ highest freq
samples=5000;% samples 
NumTaps=20; % Filter size = 21 (numtaps+1) 
t = (-0.5:1/samples:0.5-1/samples)*fs; % Normalized freq range 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End of LPF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y_lpf = firpm(NumTaps, [Fpass1 Fpass2 Fstop1 Fstop2]*(1/fs), [1 1 0 0],[1 10000]); % LPF
y_lpf_fft = 20*log10(fftshift(abs(fft(y_lpf,5000)))); % FFT of LPF 
y_conv=filter(y_lpf,1,y_shifted); % Convolve LPF w/ Signal at Desired Freq to filter unwanted stations
y_shifted_fft = 20*log10(fftshift(abs(fft(y_shifted,5000)/5000))); % FFT of Desired Radio Station that is shifted 

figure(4)
subplot(2,1,1) % Time series of filtered audio signal from IQ Data
plot(0:249, real(y_conv(1:250))) % Real Plot of Signal 
title('Time Series of LPF Convolved w/ IQ Data')
xlabel('Amplitude')
ylabel('Time')
 
subplot(2,1,2) % Filter Overlay w/ Signal 
plot(t,y_lpf_fft)
hold on
plot(t,y_shifted_fft)
title('LPF Overlay on Desired Radio Station Pre-Decimate between -1.25MHz & 1.25MHz')
xlabel('Frequency (f)')
ylabel('Magnitude')


figure(5)
plot_FFT_IQ(y_shifted,firstsample,filterlength,fs,desiredfreq,'Shifted signal to desired Radio Station'); 

figure(6)
decimatevalue=8; % 2.5MHz/8 = 312.5kHz
d = decimate(y_conv,decimatevalue,'fir'); % decimation of filtered signal  
%.002*2.5E6/8 = 625Hz
plot_FFT_IQ(d,1,.002*2.5E6/decimatevalue,2.5/decimatevalue,centerfreq,'Decimated FM Radio signal by 8'); 

figure(7)
%.05*2.5E6/8 = 15.625KHz
[y_FM_demodulated] = FM_IQ_Demod(d); % Demodulate the decimated signal 
plot_FFT_IQ(y_FM_demodulated,1,.05*2.5E6/decimatevalue,2.5/decimatevalue,0,'Demodulation of Signal @ Stereo Range');

figure(8)
df = decimate(y_FM_demodulated,10,'fir');
decimatevalue2=10;
plot_FFT_IQ(df,1,.05*2.5E6/decimatevalue/decimatevalue2,2.5/decimatevalue/decimatevalue2,0,'Demodulated signal @ Sound Card Freq 31.25MHz');
sound(df,(2.5E6)/decimatevalue/decimatevalue2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Debug Code to Try for Future: Advanced Filtering w/ Wavelets %%%%%%%%%%%%%
%cleandf=wdenoise(df,8) % Wavelets to clean, failed 

%%%%%%%%%%%%% Debug Code to Try for Future: Filtering w/ Cheby2 & Wavelets %%%%%%%%%%%%%
% %sound(df,(2.5E6)/decimatevalue/decimatevalue2);
% %sound(cleandf,(2.5*3.3E6)/decimatevalue/decimatevalue2);
%  order = 7;
% % %%[n,Ws] = cheb2ord(2000/fs,2020/fs,1,100);              
% % %%Filter Order
%  [z,p,k] = cheby2(order,150,0.4,'low');                        
%  [soslp,glp] = zp2sos(z,p,k);
%  %%[b,a] = butter(order,1000/(sample_rate/2),'low');
%  filtered_sound = filtfilt(soslp, glp, df);
% % %%filtered_sound = filter(b,a,sample_data);
%  sound(filtered_sound,(2.5E6)/decimatevalue/decimatevalue2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%