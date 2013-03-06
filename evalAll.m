% function [accuracy errors] = evalAll(symbols)
%   Evaluate the recognizer on a set of 'symbols', using the first 60% as 
%   training and the remaining as test. Returns the accuracy rate and a 
%   list of errors (as indices).

function [accuracy, errors] = evalAll(symbols)
    cutoff = round(length(symbols)*0.6);
    train = symbols(1:cutoff);
    test = symbols(cutoff+1:length(symbols));
    
    for i = 1:length(train)
        trainimages(i) = struct('fimg', createFeatureImage(train(i)), ...
                                'label', train(i).label);
    end

    correct = 0;
    close all
    figure;
    
    errors = [];
    for i = 1:length(test)
        testimage = createFeatureImage(test(i));
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