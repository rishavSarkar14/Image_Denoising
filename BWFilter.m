% File BWFilter.m
%**************************************************************************
% This script is a n-order Butterworth low-pass filter implementation.
%
% Author: Everton Leandro Alves
% Date: 06/29/2008
%
% This simulation builds a filter using the expression for the transfer 
% function of a LP Butterworth filter:
%              
%                   G0
%  H(s) = ------------------------    
%          (s-s1)(s-s2)...(s-sn)/wc
%
% where 'n' is the filter order, 'G0' the DC gain, 'wc' the cutoff angular 
% frequency, and 'si' are the n poles in the 's' negative half plane. The 
% sk pole is calculated by the expression:
%
%          i(2k+n-1)PI/(2n)
% sk = wc*e                 , for k=1,2...n
%
% An example of application for illustration purpose is shown. The filter
% is used to let pass a low frequency component of a signal and attenuates
% a high frequency component of the signal.
%
%**************************************************************************

clear all
clc

% Filter Parameters:
fc=4e6;         % cutoff frequency
n=2;            % filter order. Change it to see other order filter.
G0=1;           % DC gain

% MATLAB simulation parameters:
deltaF=1e3;                 % frequency step
fs=500e6;                   % sampling frequency

N=fs/deltaF;                % number of samples, power of 2 for the fast FT  
N=2^ceil(log2(N));

fs=N*deltaF;                % new sampling frequency
deltaT=1/fs;                % time step

fc=deltaF*round(fc/deltaF); % new cutoff frequency
wc=2*pi*fc;                 % cutoff pulsation

% Filter building:
w_axis=-2*pi*fs/2:deltaF*2*pi:2*pi*fs/2;    % angular frequency axis
k=1:n;                                      
p_k=wc*exp(i*pi*(n-1+2.*k)/(2*n));          % n poles in the 's' neg. half plane

Filter_f=1;
for c1=1:n
    Filter_f=Filter_f./((i*w_axis-p_k(c1))/wc);
end

% Filter curves visualization:

% |H(jw)| linear plot (not very useful). Note the amplitude 0,707 at fc.
figure(1)
subplot(3,1,1)                          
plot(w_axis/(2*pi),abs(Filter_f));
title('Filter Frequency Response')
xlabel('Frequency (Hz)');
ylabel('|H(jw)|');
grid

% 20log|H(jw)| plot, for f>0. Note the -3dB attenuation at fc, and the
% n x (-20)dB/dec slope for f>fc.
subplot(3,1,2)                          
semilogx(w_axis(N/2+1:N)/(2*pi),20*log10(abs(Filter_f(N/2+1:N))));
xlabel('Frequency (logHz)');
ylabel('|H(jw)|_d_B');
grid

% arg{H(jw)} plot, for f>0. Note the n x (-45)deg at fc and the n x (-90)deg
% for f>>fc.
subplot(3,1,3)                         
semilogx(w_axis(N/2+1:N)/(2*pi),(180/pi*phase(Filter_f(N/2+1:N))));
xlabel('Frequency (logHz)');
ylabel('Phase (deg)');
grid

% Poles scatter plot. The n poles are angular equally spaced, in the 
% negative s half plane, on the circle with radius=wc. Change the order n
% to 20 for example to see it better.
figure(2)
scatter(real(p_k),imag(p_k))
title('Locus of the n poles');
xlabel('Re (s)');
ylabel('Im (s)');
grid
axis([-wc wc -wc wc])

% Filter application. A simple filtering application to a signal composed
% by two sine waves added, one with frequency <fc and another one with 
% frequency >fc. For simulation reasons, both sine waves frequencies are 
% multiples of deltaF.
t=(0:N-1)*deltaT;           % time axis
fl=fc/1.5;                  % lower sin frequency
fu=fc*3;                    % upper sin frequency

fl=deltaF*round(fl/deltaF); % adjust of the frequencies for simulation
fu=deltaF*round(fu/deltaF);

IN_signal_t=2*sin(2*pi*fl*t) + 2*sin(2*pi*fu*t);    % input signal forming

% Filtering process:
IN_signal_f=fft(IN_signal_t/N);
Filter_f2=[Filter_f(N/2+1:N+1) Filter_f(2:N/2)];    % for MATLAB FFT

OUT_signal_f=IN_signal_f.*Filter_f2;            % filtering in frequency domain
OUT_signal_t=ifft(OUT_signal_f*N,'symmetric');  % output signal in time domain

% See the simulation results for low-order and high-order Butterworth
% filters (try n=1 and n=5 for example). For high-order filters, it is 
% possible to see the phase changing of the low frequency sine wave, with 
% respect to the phase response of the filter.
figure(3)
subplot(2,1,1)
plot(t(1:round(10/fl/deltaT)),IN_signal_t(1:round(10/fl/deltaT)))
title('Input Signal, first 10 periods')
xlabel('Time (s)');
ylabel('Amplitude');
grid

subplot(2,1,2)
plot(t(1:round(10/fl/deltaT)),OUT_signal_t(1:round(10/fl/deltaT)))
title('Output Filtered Signal, first 10 periods')
xlabel('Time (s)');
ylabel('Amplitude');
grid

