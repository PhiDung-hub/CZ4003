%% 1. Edge Detection
%% Part A: Read in image
P = imread('images/maccropped.jpg'); I = rgb2gray(P);
imshow(I, 'InitialMagnification', 200), title("Original running image");
%% Part B: Sobel filtering
sobel_v = [ -1 0 1; -2 0 2; -1 0 1; ];
sobel_h = [ -1 -2 -1; 0 0 0; 1 2 1; ];
res_v = conv2(I, sobel_v); res_h = conv2(I, sobel_h);

fig = figure("Name", "Sobel filter");
fig.Position = [100, 100, 1500, 600];
tlo = tiledlayout(fig, 1, 2, 'TileSpacing', 'compact');
imshow(uint8(res_v), 'Parent', nexttile(tlo)), title("Vertical Sobel", 'FontSize', 18);
imshow(uint8(res_h), 'Parent', nexttile(tlo)), title("Horizontal Sobel", 'FontSize', 18);
fig = clf('reset');

%% part C: Get total Gradient
fig.Position = [50 50 1500 400];
tlo = tiledlayout(fig, 1, 3, 'TileSpacing', 'compact');

E = res_v.^2 + res_h.^2; 
imshow(uint8(E), 'Parent', nexttile(tlo)), title("Squared gradient", 'FontSize', 18);
E = sqrt(E); 
imshow(uint8(E), 'Parent', nexttile(tlo)), title("True gradient", 'FontSize', 18);
E = (E - min(E(:))) / (max(E(:)) - min(E(:))) * 255;
imshow(uint8(E), 'Parent', nexttile(tlo)), title("Normalized gradient", 'FontSize', 18);
%% Part D: Simple thresholding
t = [30, 90, 150];
fig = figure("Name", "Simple Thresholding", "Resize", "off");
fig.Position = [50 50 1500 400];
tlo = tiledlayout(fig, 1, 3, 'TileSpacing', 'compact');
for i = 1:3
    Et = E>t(i);
    imshow(Et, 'Parent', nexttile(tlo));
    title(sprintf("Threshold = %d", t(i)), 'FontSize', 18)
end
%% Part E: Explore MatLAB's Canny edge detection.
tl = 0.04; th = 0.1; sigma = 1.0;
% (i): Varying Sigma
sigmas = [1.0, 3.0, 5.0];
fig = figure("Name", "Varying sigma", "Resize", "off");
fig.Position = [50 50 1500 400];
tlo = tiledlayout(fig, 1, 3, 'TileSpacing', 'compact');
for i = 1:3
    E = edge(I, 'canny', [tl th], sigmas(i));
    imshow(E, 'Parent', nexttile(tlo));
    title(sprintf("tl=0.04, th=0.1, Sigma=%.1f", sigmas(i)), 'FontSize', 18)
end
% (ii): Varying th
tls = [0.07, 0.04, 0.01];
fig = figure("Name", "Varying low threshold", "Resize", "off");
fig.Position = [50 50 1500 400];
tlo = tiledlayout(fig, 1, 3, 'TileSpacing', 'compact');
for i = 1:3
    E = edge(I, 'canny', [tls(i) th], sigma);
    imshow(E, 'Parent', nexttile(tlo));
    title(sprintf("tl=%.2f, th=0.1, Sigma=5.0", tls(i)), 'FontSize', 18)
end
%% 2. Line Detection
%% Part A: Read in -> Canny EDGE.
P = imread('images/maccropped.jpg'); I = rgb2gray(P);
E = edge(I, 'canny', [.04 .1], 1.0);

clf; imshow(E), title("Canny Edge: tl=0.04, th=0.1, sigma=1.0")
%% Part B: Radon transform (Hough binary equivalent)
[R, xp] = radon(E, 0:179);
imagesc(uint8(R)), colormap('default'), title("Radon transformed image with default color map");
%% Part C: Pixel with maximum value.
[radius, theta] = find( ismember( R, max(R(:)) ) )
%% Part D: Polar to Cartesian
theta = 103; % since theta is 0-indexed
radius = xp(157); % x is 1-indexed.
[A, B] = pol2cart(theta*pi/180, radius);
B = -B; % since y-axis is reversed.
%% Part E: Solve for line equation
xl = 0; xr = 357; % image size is 290 x 358.
yl = (C - A * xl) / B;
yr = (C - A * xr) / B;

%% part F: Show the image with line
imshow(I, 'InitialMagnification', 150), 
line([xl xr], [yl yr], 'Color','r'),
title("Image with line detected");
%% Part 3: Stereo vision
%% Part A: Define the disparity map 
% Source code in `disp_map.m`
%% Part B: View Left and Right Image
l = imread('images/corridorl.jpg'); l = rgb2gray(l);
r = imread('images/corridorr.jpg'); r = rgb2gray(r);

fig = figure("Name", "Leftview vs Rightview corridor");
fig.Position = [100, 100, 1500, 600];
tlo = tiledlayout(fig, 1, 2, 'TileSpacing', 'compact');
imshow(l, 'Parent', nexttile(tlo)), title("Left Corridor Image", 'FontSize', 18);
imshow(r, 'Parent', nexttile(tlo)), title("Right Corridor Image", 'FontSize', 18);
%% part C: Calculating the disparity map
D = disp_map(l, r, 11, 11); disp = imread('images/corridor_disp.jpg');

tlo = tiledlayout(fig, 1, 2, 'TileSpacing', 'compact');
imshow(-D, [-15 15], 'Parent', nexttile(tlo)), title("Calculated corridor disparity map", 'FontSize', 18);
imshow(disp, 'Parent', nexttile(tlo)), title("Corridor reference result", 'FontSize', 18);
%% Part D: Re-run on triclops.jpg
l = imread('images/triclopsi2l.jpg'); l = rgb2gray(l);
r = imread('images/triclopsi2r.jpg'); r = rgb2gray(r);

fig = figure("Name", "Leftview vs Rightview triclops");
fig.Position = [100, 100, 1500, 600];
tlo = tiledlayout(fig, 1, 2, 'TileSpacing', 'compact');
imshow(l, 'Parent', nexttile(tlo)), title("Left Triclops Image", 'FontSize', 18);
imshow(r, 'Parent', nexttile(tlo)), title("Right Triclops Image", 'FontSize', 18);
% Calculating the disparity map
D = disp_map(l, r, 11, 11); disp = imread('images/triclopsid.jpg');

tlo = tiledlayout(fig, 1, 2, 'TileSpacing', 'compact');
imshow(-D, [-15 15], 'Parent', nexttile(tlo)), title("Calculated triclops disparity map", 'FontSize', 18);
imshow(disp, 'Parent', nexttile(tlo)), title("Triclops reference result", 'FontSize', 18);