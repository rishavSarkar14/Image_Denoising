function fh1 = untitled
    fh1 = @convolution;
end

function y = convolution(x, h)
y = conv(x,h,'same');
disp(y);
end