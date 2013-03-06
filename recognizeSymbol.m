% function nearest = recognizeSymbol(testimage, trainimages)
%   Return the nearest neighbor of the feature image 'testimage' in the
%   training set 'trainimages'.

function nearest = recognizeSymbol(testimage, trainimages)
        
    function length = distance(x1, y1, x2, y2)
        length = (x2 - x1) ^ 2 + (y2 - y1) ^ 2;
    end


    function result = score(i, mi)
        mi = mi.fimg;
        result = 0;
        dim = size(i);
        layers = dim(3);
        dim = dim(1);
        for layer=1:layers
            for x=1:dim
                for y=1:dim
                    result = result + (i(x, y, layer) - mi(x, y, layer)) ^ 2;
                end
               
            end
        end
    end

    best = trainimages(1);
    bestScore = score(testimage, trainimages(1));
    bestIndex = 1;
    imgCount = size(trainimages);
    imgCount = imgCount(2);
    for i=2:imgCount
        currentScore = score(testimage, trainimages(i));
        if currentScore < bestScore
            best = trainimages(i);
            bestIndex = i;
            bestScore = currentScore;
        end
    end
    bestIndex;
    nearest = best;
end

