function [accuracy, errors] = test(symbols)
    cutoff = round(length(symbols)*0.6);
    train = symbols(1:5);
    test = symbols(3);
    
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
%         subplot(4,4, i);
%         displaySymbol(test(i));
        if (prediction.label == test(i).label)
            correct = correct + 1;
        else
            errors = [errors i+length(train)];
            if (length(errors) <= 16)
                subplot(4,4,length(errors)); % + length(test));
                displaySymbol(test(i));
                title(sprintf('%d as %d (%d)', test(i).label, ...
                    prediction.label, i+length(train)));
            end
        end
    end    
    accuracy = correct/length(test);
end