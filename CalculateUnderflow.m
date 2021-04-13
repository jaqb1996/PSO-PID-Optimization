function d = CalculateUnderflow(minimum, maximum, value)

difference = maximum - minimum;
i = 0;
while true
    d = (minimum - i * difference) - value;
    if d < difference
       break; 
    end
    i = i + 1;
end
end
