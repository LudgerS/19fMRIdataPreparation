function [] = fluorineOverlay(anatomy, fluorine, cMap19F, resizeF, fileName)
% Written by Ludger Starke; Max Delbrück Center for Molecular Medicine in
% the Helmholtz Association, Berlin
%
% License: GNU GPLv3 


anatomy = abs(anatomy);
anatomy = 0.8*anatomy/max(anatomy(:));

fluorine = abs(fluorine);
fluorine = fluorine/max(fluorine(:));

resized19F = imresize(abs(fluorine), [size(anatomy, 1), size(anatomy, 2)], 'method', 'nearest');

cMap1H = gray(512);
[image1H,~] = gray2ind(anatomy, size(cMap1H, 1));
image1H = ind2rgb(image1H, cMap1H);

[image19F,~] = gray2ind(resized19F, size(cMap19F, 1));
image19F = ind2rgb(image19F, cMap19F);


%%

mask = resized19F > 0;
mask = repmat(mask,[1,1,3]);

overlay = image1H;
overlay(mask) = image19F(mask);


%%
imwrite(imresize(overlay, resizeF, 'method', 'nearest'), [fileName, '.png'], 'PNG', 'writeMode', 'overwrite')


