function [val,idx] = find_near(array,num)

[val,idx] = min(abs(array-num));



end

