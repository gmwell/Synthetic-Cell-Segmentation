% Parameters for the synthetic image
height = 512; 
width = 512;
num_cells = 20; 
min_radius = 10; 
max_radius = 30;

% Initialize the fluorescence image
fluorescence_image = zeros(height, width, 'uint16');

% Set random seed for reproducibility
rng(42);

% Generate random centers and radii for yeast cells
centers = randi([min_radius, min(height, width) - max_radius], num_cells, 2);
radii = randi([min_radius, max_radius], num_cells, 1);

% Draw cells with random intensities
for i = 1:num_cells
    [X, Y] = meshgrid(1:width, 1:height);
    mask = (X - centers(i, 2)).^2 + (Y - centers(i, 1)).^2 <= radii(i)^2;
    intensity = randi([1000, 65535]); % Random fluorescence intensity
    fluorescence_image(mask) = fluorescence_image(mask) + intensity;
end

% Generate labeled image
binary_image = fluorescence_image > 0;
labeled_image = bwlabel(binary_image); % Label connected components
labeled_image = uint8(labeled_image); % Convert to uint8 (max label = 255)

% Display the results
figure;

% Display fluorescence image with pixel intensity colorbar
subplot(1, 2, 1);
imshow(fluorescence_image, []);
colormap(gca, 'gray');
cb1 = colorbar; % Add pixel intensity colorbar
cb1.Label.String = 'Pixel Intensity (uint16)';
title('Fluorescence Image');
axis image off;

% Display labeled image with number of cell intensities colorbar
subplot(1, 2, 2);
imshow(label2rgb(labeled_image, 'jet', 'k', 'shuffle')); % Colored labels
colormap(gca, 'jet');
cb2 = colorbar; % Add colorbar for number of cells
cb2.Ticks = 0:max(labeled_image(:)); % Ticks for each label
cb2.TickLabels = arrayfun(@num2str, 0:max(labeled_image(:)), 'UniformOutput', false);
cb2.Label.String = 'Cell Label Intensity';
title('Labeled Image');
axis image off;

% Save results if needed
% imwrite(fluorescence_image, 'fluorescence_image.tif');
% imwrite(labeled_image, 'labeled_image.png');
