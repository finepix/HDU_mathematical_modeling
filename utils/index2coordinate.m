function [ x, y ] = index2coordinate(index, W, H, block_size)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
%   origin_point = (0, 0);
    if W ~= H
        % 若两者不相等的话（为矩形）
        ME = MException('H not equal W,', 'check the value or swich another solution');
        throw(ME);
    end

    % 计算每一个小方块的大小
    piece_length = W / block_size;
    
    tmp_y = ceil(index / block_size);
    tmp_x = mod(index, block_size);
    
    % 判断，若index为每行的最后一个
    tmp_x(tmp_x == 0) = block_size;
    
    x = tmp_x * piece_length - piece_length / 2;
    y = tmp_y * piece_length - piece_length / 2;
    y = - y;

end

