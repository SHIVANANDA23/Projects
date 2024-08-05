% Specify the folder containing audio files of a particular genre
folder_path = 'L:\MATLAB\DSP DATASETS\Data\genres_original\jazz';

% List audio files in the folder
audio_files = dir(fullfile(folder_path, '*.wav'));

mean_frequencies = zeros(length(audio_files), 1);

for i = 1:length(audio_files)
    sprintf("%s i:%d",audio_files(i).name,i)
    file_path = fullfile(folder_path, audio_files(i).name);
    
    % Load audio file
    [y, Fs] = audioread(file_path);
    
    % Extract features using Short-Time Fourier Transform (STFT)
    window_length = 1024; % Adjust window length as needed
    overlap = 512; % Adjust overlap as needed
    [frequency, ~, ~] = spectrogram(y, window_length, overlap, [], Fs);
    
    % Calculate mean frequency for the current audio file
    mean_freq = mean(abs(frequency(:)));
    
    mean_frequencies(i) = mean_freq;
end

% Calculate the mean frequency across all audio files of the genre
mean_genre_frequency = mean(mean_frequencies);
%max=max(mean_frequencies);
sprintf("Mean:%.6f",mean_genre_frequency)