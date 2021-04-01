function out = simpleOverlay(image1, image2)
% Written by Ludger Starke; Max Delbrück Center for Molecular Medicine in
% the Helmholtz Association, Berlin; 20-02-14
%
% License: GNU GPLv3 

dim = size(image1);

image1 = abs(image1);
image1 = image1/max(image1(:));

image2 = abs(image2);
image2 = image2/max(image2(:));

out = zeros([dim,3]);

for ii = 1:3
    out(:,:,ii) = image1/2;
end

out(:,:,1) = out(:,:,1) + image2/2;

end