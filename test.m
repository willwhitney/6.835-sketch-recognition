% returns a list with the optimal [h, tangentWindow, sigma]

function vars = test(symbols)
    posHs = [16 24 32];
    posTanWindows = [5 10 15];
    posSigmas = [0.5 1.0 1.5];
    options = length(posHs);
    
    bestAccuracy = -1;
    bestVals = [];
    for hIndex=1:options
        for tIndex=1:options
            for sIndex=1:options
                [accuracy, errors] = evalAllWithArgs(symbols, posHs(hIndex), ...
                    posTanWindows(tIndex), posSigmas(sIndex));
                if bestAccuracy < 0
                    bestAccuracy = accuracy;
                    bestVals = [posHs(hIndex), posTanWindows(tIndex), posSigmas(sIndex)]
                elseif accuracy > bestAccuracy
                    bestAccuracy = accuracy;
                    bestVals = [posHs(hIndex), posTanWindows(tIndex), posSigmas(sIndex)]
                end
            end
        end
    end
    
    bestAccuracy
    vars = bestVals

        

    function [accuracy, errors] = evalAllWithArgs(symbols, h, tangentWindow, sigma)
        cutoff = round(length(symbols)*0.6);
        train = symbols(1:cutoff);
        test = symbols(cutoff+1:length(symbols));

        for i = 1:length(train)
%             i
            trainimages(i) = struct('fimg', createFeatureImageWithArgs(train(i), h, tangentWindow, sigma), ...
                                    'label', train(i).label);
        end
%         trainimages
        correct = 0;
        close all
        figure;

        errors = [];
        for i = 1:length(test)
            testimage = createFeatureImageWithArgs(test(i), h, tangentWindow, sigma);
            prediction = recognizeSymbol(testimage, trainimages);
            if (prediction.label == test(i).label)
                correct = correct + 1;
            else
                errors = [errors i+length(train)];
                if (length(errors) <= 16)
                    subplot(4,4,length(errors));
                    displaySymbol(test(i));
                    title(sprintf('%d as %d (%d)', test(i).label, ...
                        prediction.label, i+length(train)));
                end
            end
        end    
        accuracy = correct/length(test);
    end

    function fimg = createFeatureImageWithArgs(symbol, h, tangentWindow, sigma)
%         h = 24;
        fimg = zeros(h, h, 4);
%         tangentWindow = 5;
        referenceAngles = [0; pi/4; pi/2; 3*pi/4];
        numPoints = size(symbol.x);
        numPoints = numPoints(1);
%         sigma = 1;

        temp = symbol.y;
        symbol.y = symbol.x;
        symbol.x = temp;


        function tangents = buildTangents(x, y, w)
            tangents = zeros(size(x));
            for i=1:size(x)
                lower = max(i - w, 1);
                upper = min(i + w, numPoints);
                tangents(i) = (y(upper) - y(lower)) / (x(upper) - x(lower));
            end
        end

        function quality = angleMatchQuality(angle, refAngle)
            angle = mod(angle, pi);
            refAngle = mod(refAngle, pi);

            quality = max(-abs(angle - refAngle) * 4 / pi + 1, 0);
            if abs(angle - refAngle) == pi
                quality = 1;
            end
        end

        tangents = buildTangents(symbol.x, symbol.y, tangentWindow);

        angles = atan(tangents);

        meanX = mean(symbol.x);
        meanY = mean(symbol.y);
        centeredX = symbol.x - meanX;
        centeredY = symbol.y - meanY;

        currentDevX = std(centeredX);
        currentDevY = std(centeredY);

        scaledX = (centeredX / currentDevX) * (h / 5);
        scaledY = (centeredY / currentDevY) * (h / 5);

        shiftedX = scaledX + (h / 2);
        shiftedY = scaledY + (h / 2);

    %     for i=1:numPoints
    %         fimg(round(shiftedX(i)), round(shiftedY(i)), 1) = 1;
    %     end

        for i=1:size(referenceAngles)
            for j=1:numPoints-1
                if symbol.s(j) ~= symbol.s(j+1)
                    continue
                end
                intensity = angleMatchQuality(angles(j), referenceAngles(i));
                [exes, yies] = makeLine(shiftedX(j), shiftedY(j), shiftedX(j+1), shiftedY(j+1));
                for lineIndex=1:size(exes)
                    exes(lineIndex) = ceil(exes(lineIndex));
                    yies(lineIndex) = ceil(yies(lineIndex));
                    exes(lineIndex) = max(1, exes(lineIndex));
                    exes(lineIndex) = min(exes(lineIndex), h);
                    yies(lineIndex) = max(1, yies(lineIndex));
                    yies(lineIndex) = min(yies(lineIndex), h);
                    fimg(exes(lineIndex), yies(lineIndex), i) = min(intensity +...
                       fimg(exes(lineIndex), yies(lineIndex), i), 1);
                end
            end
        end

        smoother = fspecial('gaussian', [3 3], sigma);
        fimg = imfilter(fimg, smoother);

    %     clf
    %     displayImage(fimg, symbol)

        fimg = downsample(fimg);
    end

end