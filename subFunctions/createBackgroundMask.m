function [ mask ] = createBackgroundMask(dim, side)
% 'dim' gives the size of a 2D image as a vector
% 'side' is the side length of a logical true square in each corner
%
% Written by Ludger Starke; Max Delbrück Center for Molecular Medicine in
% the Helmholtz Association, Berlin
%
% License: GNU GPLv3 


mask = false(dim);
mask(1:side,1:side) = true;
mask(end-side:end,1:side) = true;
mask(1:side,end-side:end) = true;
mask(end-side:end,end-side:end) = true;

end

