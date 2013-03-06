function displaySymbol(symbol)
    hold on
    n = length(symbol.x);
    strokeStart = 1;
    for i=2:n
        if (symbol.s(i) > symbol.s(i-1))
            hplot = plot(symbol.x(strokeStart:i-1), -symbol.y(strokeStart:i-1));
            set(hplot,'LineWidth',2);
            strokeStart = i;
        end
    end
    if (strokeStart < n)
        hplot = plot(symbol.x(strokeStart:n), -symbol.y(strokeStart:n));
        set(hplot,'LineWidth',2);
    end
    hold off
end

