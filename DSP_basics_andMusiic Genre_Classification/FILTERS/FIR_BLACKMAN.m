file_path = "L:\MATLAB\DSP DATASETS\Data\genres_original\rock\rock.00099.wav";

[x, Fs] = audioread(file_path);

% Define filter parameters
filter_order = 70;  % Adjust as needed
passband_frequency_range = [50, 2000];  % Adjust as needed

% Design FIR filter using a Blackman window
blackman_window = blackman(filter_order+1);
fir_filter = fir1(filter_order, passband_frequency_range / (Fs/2), 'bandpass', blackman_window);

% Frequency response of the filter
[H, Freq] = freqz(fir_filter, 1, 1024, Fs);

% Apply the filter to the audio signal
filtered_audio = filter(fir_filter, 1, x);
t=(0:(length(x)-1))/Fs;

% Plot original and filtered signals in the time domain
figure;
subplot(2, 1, 1);
plot(blackman_window);
title('Blackman Window');
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
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t,x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot frequency response of the original and filtered signals
fft_x = fft(x);
frequencies = (Fs/2) * linspace(-1, 1, length(x));
figure;
subplot(2, 1, 1);
plot(frequencies, abs(fftshift(fft_x)))
title('Frequency Response of Original Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

fft_filtered = fft(filtered_audio);
subplot(2, 1, 2);
plot(frequencies, abs(fftshift(fft_filtered)))
title('Frequency Response of Filtered Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
