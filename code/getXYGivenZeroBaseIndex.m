function[x, y] = getXYGivenZeroBaseIndex(KeyPoints, index)
    base = 3*index;
    x = KeyPoints(:, base + 1);
    y = KeyPoints(:, base + 2);
end