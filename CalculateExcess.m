function d = CalculateExcess(minimum, maximum, value)

difference = maximum - minimum;
i = 1;
while true
    d = value - i * difference - minimum;    
    if d < difference
       break; 
    end
    i = i + 1;
end
d = abs(d);
end

