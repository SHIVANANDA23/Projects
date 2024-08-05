% Define the folder containing audio files
folder_path = 'L:\MATLAB\DSP DATASETS\Data\genres_original\blues'; % Update with your folder path

% Get a list of all audio files in the folder
audio_files = dir(fullfile(folder_path, '*.wav'));

% Initialize variables for storing dominant frequencies
dominant_frequencies = zeros(numel(audio_files), 1);

% Process each audio file
for i = 1:numel(audio_files)
    % Load audio file
    file_path = fullfile(folder_path, audio_files(i).name);
    [y, Fs] = audioread(file_path);

    % Perform FFT
    N = length(y); % Length of the signal
    Y = fft(y); % Compute the FFT
    frequencies = (0:N-1) * (Fs / N); % Frequency axis

    % Calculate single-sided spectrum
    Y_single_sided = Y(1:N/2+1);
    frequencies_single_sided = frequencies(1:N/2+1);

    % Find the frequency with the highest magnitude
    [~, idx] = max(abs(Y_single_sided));
    dominant_frequency = frequencies_single_sided(idx);
    
    % Store dominant frequency for each file
    dominant_frequencies(i) = dominant_frequency;
end

% Compute statistics
min_frequency = min(dominant_frequencies);
max_frequency = max(dominant_frequencies);
avg_frequency = mean(dominant_frequencies);

% Display results
fprintf('Minimum dominant frequency: %.2f Hz\n', min_frequency);
fprintf('Maximum dominant frequency: %.2f Hz\n', max_frequency);
fprintf('Average dominant frequency: %.2f Hz\n', avg_frequency);
