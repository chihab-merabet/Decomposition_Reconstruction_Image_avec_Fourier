%Challenge
%Décomposition & Reconstruction Image avec Fourier
%Réaliser par Merabet Chihabeddine
%IGE 45 Groupe 03
%-------------------------------------------------
clear all;
clc;
Vitesse = 20;
image = imread('setif.jpg');
scale = 0.5;
%Le code:
image = imresize(mean(double(image),3), scale);
image = image - mean(image(:));
N = size(image);
min_image = min(image(:));
max_image = max(image(:));
Range = [(1.25*min_image - 0.25*max_image), (1.25*max_image - 0.25*min_image)];

figure(1);

FT_image = fftn(image);
FT_new = zeros(size(FT_image));
ABS_FT_image = abs(FT_image);
FT_cur = zeros(size(FT_new));
new_image = zeros(size(FT_new));

n = 1; nombre_waves = 1;
while n < numel(image)
    FT_cur = 0*FT_cur;
    if n > 20;  nombre_waves = 10 ; end
    if n > 200; nombre_waves = 100; end
    if n > 2000; nombre_waves = 1000; end
    
    for p = 1:nombre_waves*2
        [a,b] = find(ABS_FT_image == max(ABS_FT_image(:)), 1, 'first');
        ABS_FT_image(a,b) = 0;
        FT_cur(a,b) = FT_image(a,b);
    end
    image_cur = ifftn(FT_cur);

    canvas = cat(2, real(image - new_image - image_cur), zeros(size(image)), new_image);
    canvas_view = canvas;
    canvas_view(:,1:N(2)) = canvas_view(:,1:N(2)) + image_cur;
    subplot(1,1,1); imagesc(real(canvas_view), Range); axis equal tight; colormap gray;
    title('Challenge - Décomposition & Reconstruction Image avec Fourier', 'FontSize',18); 
    pause((1/Vitesse)*exp(-n/2));

    for L = [(min(max(1, round((1 + sin(linspace(-pi/2, pi/2, 40/min(20, n))))/2*N(2))), N(2)+1))   (N(2)+1)]
        canvas_view = canvas;
        canvas_view(:,L:(L+(N(2)-1))) = canvas_view(:,L:(L+(N(2)-1))) + image_cur;
        subplot(1,1,1); imagesc(real(canvas_view), Range); axis equal tight; colormap gray;
        title('Challenge - Décomposition & Reconstruction Image avec Fourier', 'FontSize',18); 
        pause((1/Vitesse)*exp(-(n+4)));
        drawnow
    end
    pause((1/Vitesse)*exp(-n/2));
    for L = N(2) + [(min(max(1, round((1 + sin(linspace(-pi/2, pi/2, 40/min(20, n))))/2*N(2))), N(2)+1))   (N(2)+1)]
        canvas_view = canvas;
        canvas_view(:,L:(L+(N(2)-1))) = canvas_view(:,L:(L+(N(2)-1))) + image_cur;
        subplot(1,1,1); imagesc(real(canvas_view), Range); axis equal tight; colormap gray;
        title('Challenge - Décomposition & Reconstruction Image avec Fourier', 'FontSize',18); 
        pause((1/Vitesse)*exp(-(n+4)));
        drawnow
    end
    new_image = new_image + image_cur;
    n = n + nombre_waves;
end