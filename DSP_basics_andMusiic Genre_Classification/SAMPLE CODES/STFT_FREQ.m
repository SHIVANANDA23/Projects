% Define the folder containing audio files
folder_path = 'L:\MATLAB\DSP DATASETS\Data\genres_original\rock'; % Update with your folder path

% Get a list of all audio files in the folder
audio_files = dir(fullfile(folder_path, '*.wav'));

% Initialize variables for storing dominant frequencies
dominant_frequencies = zeros(numel(audio_files), 1);

% Parameters for STFT
window_length = 1024;
hop_size = 512;

% Process each audio file
for i = 1:numel(audio_files)
    % Load audio file
    file_path = fullfile(folder_path, audio_files(i).name);
    [y, Fs] = audioread(file_path);

    % Calculate STFT
    spectrogram_data = spectrogram(y, window_length, window_length - hop_size);

    % Get frequencies and magnitudes
    frequencies = linspace(0, Fs/2, size(spectrogram_data, 1));
    magnitudes = abs(spectrogram_data);

    % Find the frequency with the highest magnitude for each time frame
    [~, max_idx] = max(magnitudes, [], 1);
    dominant_frequency_idx = frequencies(max_idx);

    % Get the median frequency across all time frames as the dominant frequency
    dominant_frequency = median(dominant_frequency_idx);
    
    % Store dominant frequency for each file
    dominant_frequencies(i) = dominant_frequency;
end

% Compute statistics
min_frequency = min(dominant_frequencies);
max_frequency = max(dominant_frequencies);
avg_frequency = mean(dominant_frequencies);

% Save results to a file
output_file = 'dominant_frequencies_results.txt';
fid = fopen(output_file, 'a');
fprintf(fid, '%s\n', folder_path);
fprintf(fid, 'Minimum dominant frequency: %.2f Hz\n', min_frequency);
fprintf(fid, 'Maximum dominant frequency: %.2f Hz\n', max_frequency);
fprintf(fid, 'Average dominant frequency: %.2f Hz\n', avg_frequency);
fclose(fid);

% Display results
fprintf('Results saved to: %s\n', output_file);
