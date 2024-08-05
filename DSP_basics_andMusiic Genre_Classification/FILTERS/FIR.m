file_path = "L:\MATLAB\DSP DATASETS\Data\genres_original\rock\rock.00099.wav";

[x, Fs] = audioread(file_path);

% Define filter parameters
filter_order = 70;  % Adjust as needed
passband_frequency_range = [50, 2000];  % Adjust as needed

% Design FIR filter using a Bartlett window
bartlett_window = blackman(filter_order+1);
fir_filter = fir1(filter_order, passband_frequency_range / (Fs/2), 'bandpass', bartlett_window);

% Frequency response of the filter
[H, Freq] = freqz(fir_filter, 1, 1024, Fs);

% Apply the filter to the audio signal
filtered_audio = filter(fir_filter, 1, x);
t=(0:(length(x)-1))/Fs;
% Plot original and filtered signals in the time domain

figure;
subplot(2, 1, 1);
plot(bartlett_window);
title('Bartlett Window');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(Freq, abs(H));
title('Frequency Response of the Filter');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

figure;
subplot(2, 1, 1);
plot(t,filtered_audio);
title('Filtered Audio');
xlabel('TIME(s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t,x);
title('ORIGINAL SIGNAL');
xlabel('TIME(s)');
ylabel('Amplitude');

fft_x=fft(x);
frequencies = (Fs/2) * linspace(-1, 1, length(x));
subplot(2,1,2);
plot(frequencies, abs(fftshift(fft_x)))
title('Frequency response original signal');
xlabel('frequency(hz)');
ylabel('Amplitude');

fft_x=fft(filtered_audio);
%frequencies = (Fs/2) * linspace(-1, 1, length(x));
subplot(2,1,2);
plot(frequencies, abs(fftshift(fft_x)))
title('Frequency response original signal');
xlabel('frequency(hz)');
ylabel('Amplitude');



