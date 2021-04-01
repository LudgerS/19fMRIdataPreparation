function [ image ] = removeIsolatedVoxels(image, cMin)
% Written by Ludger Starke; Max Delbrück Center for Molecular Medicine in
% the Helmholtz Association, Berlin
%
% License: GNU GPLv3 

image = abs(image);

if numel(size(image)) == 2

    refStruct = bwconncomp(image, 8);
    
elseif numel(size(image)) == 3

    
    refStruct = bwconncomp(image, 18);
    
else
    
    error('wrong dimesnion')

end

%%
lengths = cellfun('length',refStruct.PixelIdxList);

for ii = 1:refStruct.NumObjects

    if lengths(ii) < cMin
    
        image(refStruct.PixelIdxList{ii}) = 0;
    
    end
    
end



end

