function d = CalculateUnderflow(minimum, maximum, value)

difference = maximum - minimum;
i = 0;
while true
    d = value - i * difference - minimum;
    if d < difference
       break; 
    end
    i = i + 1;
end
d = abs(d);
end
