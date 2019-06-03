function [ dist ] = dist_i_j( cordinates, blocked_cordinates, i, j, piece_length)

    pointA = cordinates(i, :);
    pointB = cordinates(j, :);
    % 初始设定最大值
    dist = realmax();
    
    % 判断是否会交于阴影部分
    for k = 1:size(blocked_cordinates, 1)
        % x方向
        tmp_x1 = blocked_cordinates(k, 1) - piece_length / 2;
        tmp_x2 = blocked_cordinates(k, 1) + piece_length / 2;
        
        % y方向
        tmp_y1 = blocked_cordinates(k, 2) - piece_length / 2;
        tmp_y2 = blocked_cordinates(k, 2) + piece_length / 2;
        
        % 依次判断
        if isCrossed(pointA(1), pointA(2), pointB(1), pointB(2), tmp_x1, tmp_y1, tmp_x1, tmp_y2);
            return;
        end
        if isCrossed(pointA(1), pointA(2), pointB(1), pointB(2), tmp_x1, tmp_y2, tmp_x2, tmp_y2);
            return;
        end
        if isCrossed(pointA(1), pointA(2), pointB(1), pointB(2), tmp_x1, tmp_y1, tmp_x2, tmp_y1);
            return;
        end
        if isCrossed(pointA(1), pointA(2), pointB(1), pointB(2), tmp_x2, tmp_y1, tmp_x2, tmp_y2);
            return;
        end
    end
    
    % 若有直线路径存在，则取直线路径长度
    dist = sqrt((pointA - pointB) * (pointA - pointB)');

end
