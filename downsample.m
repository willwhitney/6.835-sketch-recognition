% function dimg = downsample(fimg)
%   Downsample an image 'fimg' by a factor of 2, where each pixel in the 
%   downsampled image is the maximum of the corresponding 2x2 region in the 
%   original.
function dimg = downsample(fimg)
    h = size(fimg, 2);
    h2 = floor(h/2);    
    dimg = zeros(h2, h2, 4);    
    for i = 1:4
        for x1 = 1:h
            for y1 = 1:h
                x2 = max(1, floor(x1/2));
                y2 = max(1, floor(y1/2));
                if (dimg(x2,y2,i) < fimg(x1,y1,i))
                    dimg(x2,y2,i) = fimg(x1,y1,i);
                end
            end
        end
    end
end

