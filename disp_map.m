function out_map = disp_map(image_l, image_r, M, N)
% Get the image size, initialize out_map
[X, Y] = size(image_r); 
out_map = ones(X-M+1, Y-N+1);

% Half size of the small patch: 2m+1=M, 2n+1=N.
m = floor(M/2); n = floor(N/2); 

% Since search is limit to 15 pixel (to the left), it's more efficient to carry out
% individual sum squared distance calculation.
for i = 1+m : X-m
    for j = 1+n : Y-n
        T = image_l(i-m : i+m, j-n : j+n);
        x_r = j; ssd = inf;
     
        % start finding the matching pixel in the right image.
        % Since T^2 is constant, don't need to calculate.
        for k = max(1+n, j-14) : j
            Pr = image_r(i-m : i+m, k-n : k+n);
            I_squared = conv2(Pr, rot90(Pr, 2), 'valid');
            I_conv_T = conv2(Pr, rot90(T, 2), 'valid');
            cur_ssd = I_squared - 2*I_conv_T;
            % update the matching pixel
            if cur_ssd < ssd
                ssd = cur_ssd; x_r = k;   
            end
        end
        out_map(i-m, j-n) = x_r - j;
    end
end
end