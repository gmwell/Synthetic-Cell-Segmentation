function yeastImageUI()
    % Create the main figure
    fig = uifigure('Name', 'Synthetic Image Generator', 'Position', [100, 100, 800, 600]);

    % Default parameters
    defaultHeight = 512;
    defaultWidth = 512;
    defaultNumCells = 20;
    defaultMinRadius = 10;
    defaultMaxRadius = 30;

    % Create UI components for parameters
    uilabel(fig, 'Position', [20, 550, 150, 20], 'Text', 'Image Height (px):');
    heightInput = uieditfield(fig, 'numeric', 'Position', [170, 550, 100, 20], 'Value', defaultHeight);

    uilabel(fig, 'Position', [20, 520, 150, 20], 'Text', 'Image Width (px):');
    widthInput = uieditfield(fig, 'numeric', 'Position', [170, 520, 100, 20], 'Value', defaultWidth);

    uilabel(fig, 'Position', [20, 490, 150, 20], 'Text', 'Number of Cells:');
    numCellsInput = uieditfield(fig, 'numeric', 'Position', [170, 490, 100, 20], 'Value', defaultNumCells);

    uilabel(fig, 'Position', [20, 460, 150, 20], 'Text', 'Min Cell Radius (px):');
    minRadiusInput = uieditfield(fig, 'numeric', 'Position', [170, 460, 100, 20], 'Value', defaultMinRadius);

    uilabel(fig, 'Position', [20, 430, 150, 20], 'Text', 'Max Cell Radius (px):');
    maxRadiusInput = uieditfield(fig, 'numeric', 'Position', [170, 430, 100, 20], 'Value', defaultMaxRadius);

    % Create axes for displaying images
    ax1 = uiaxes(fig, 'Position', [300, 300, 400, 250]);
    ax1.Title.String = 'Fluorescence Image (uint16)';
    ax1.XTick = [];
    ax1.YTick = [];

    ax2 = uiaxes(fig, 'Position', [300, 20, 400, 250]);
    ax2.Title.String = 'Labeled Image (uint8)';
    ax2.XTick = [];
    ax2.YTick = [];

    % Generate button
    generateBtn = uibutton(fig, 'Text', 'Generate Image', ...
        'Position', [20, 380, 100, 30], ...
        'ButtonPushedFcn', @(btn, event) generateImages());

    % Callback function to generate images
    function generateImages()
        % Get parameters from the UI inputs
        height = heightInput.Value;
        width = widthInput.Value;
        numCells = numCellsInput.Value;
        minRadius = minRadiusInput.Value;
        maxRadius = maxRadiusInput.Value;

        % Validate parameters
        if height <= 0 || width <= 0 || numCells <= 0 || minRadius <= 0 || maxRadius <= 0 || minRadius > maxRadius
            uialert(fig, 'Invalid input parameters.', 'Error');
            return;
        end

        % Generate synthetic images
        [fluorescenceImage, labeledImage, numLabeledCells] = generateSyntheticImages(height, width, numCells, minRadius, maxRadius);

        % Display images
        imshow(fluorescenceImage, [], 'Parent', ax1);
        colormap(ax1, 'gray');
        colorbar(ax1);

        imshow(label2rgb(labeledImage, 'jet', 'k', 'shuffle'), 'Parent', ax2);
        
        % Update colorbar with labels
        cmap = [0 0 0; jet(numLabeledCells)]; % Black for background, jet colormap for cells
        colormap(ax2, cmap);
        colorbar(ax2, 'Ticks', linspace(0, 1, numLabeledCells + 1), ...
            'TickLabels', 0:numLabeledCells);
    end
end

function [fluorescenceImage, labeledImage, numLabeledCells] = generateSyntheticImages(height, width, numCells, minRadius, maxRadius)
    % Initialize a blank fluorescence image
    fluorescenceImage = zeros(height, width, 'uint16');

    % Generate random centers and radii for yeast cells
    centers = randi([minRadius, min(height, width) - maxRadius], numCells, 2);
    radii = randi([minRadius, maxRadius], numCells, 1);

    
    % Draw cells with random intensities
    for i = 1:numCells
        [X, Y] = meshgrid(1:width, 1:height);
        mask = (X - centers(i, 2)).^2 + (Y - centers(i, 1)).^2 <= radii(i)^2;
        intensity = randi([1000, 65535]); % Random fluorescence intensity
        fluorescenceImage(mask) = fluorescenceImage(mask) + intensity;
    end

    % Generate labeled image
    binaryImage = fluorescenceImage > 0;
    labeledImage = bwlabel(binaryImage); % Label connected components
    numLabeledCells = max(labeledImage(:)); % Number of unique labels (excluding background)
    labeledImage = uint8(labeledImage); % Convert to uint8 (max label = 255)
end
