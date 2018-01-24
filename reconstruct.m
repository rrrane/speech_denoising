function y = reconstruct(X , N , k)
m = size(X , 1);
n = size(X , 2);

y = zeros(floor(m * n  / 2) + N , 1);

for i = 1 : n
    front = (i - 1) * k + 1;
    rear = front + N - 1;
    y(front : rear) = y(front : rear) + X(: , i);
end

end