function [ x, y ] = index2coordinate(index, W, H, block_size)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%   origin_point = (0, 0);
    if W ~= H
        % �����߲���ȵĻ���Ϊ���Σ�
        ME = MException('H not equal W,', 'check the value or swich another solution');
        throw(ME);
    end

    % ����ÿһ��С����Ĵ�С
    piece_length = W / block_size;
    
    tmp_y = ceil(index / block_size);
    tmp_x = mod(index, block_size);
    
    % �жϣ���indexΪÿ�е����һ��
    tmp_x(tmp_x == 0) = block_size;
    
    x = tmp_x * piece_length - piece_length / 2;
    y = tmp_y * piece_length - piece_length / 2;
    y = - y;

end

