% Displays a set of feature images 'fimg' along with the original 'symbol'. 

function displayImage(fimg, symbol)
    subplot(231);
    displaySymbol(symbol);
    subplot(232);
    colormap(gray);
    image(fimg(:,:,1)*255);
    title('0');
    subplot(233);
    image(fimg(:,:,2)*255);    
    title('45');
    subplot(235);
    image(fimg(:,:,3)*255);
    title('90');
    subplot(236);
    image(fimg(:,:,4)*255);
    title('135');
end

