function [ dist_matrix ] = build_dist_matrix( cordinates, blocked_areas_index, piece_length, dist_matrix)
%UNTITLED3 构建邻接矩阵，用于后续船只的路径规划

    % 获取阴影区域坐标
    blocked_cordinates = cordinates(blocked_areas_index, :);
    
    for i = 1:size(cordinates, 1)
        % 若在阴影部分，跳过
        if ismember(i, blocked_areas_index)
            continue;
        end
        
        for j = 1:size(cordinates, 1)
             % 若在阴影部分，跳过
            if ismember(j, blocked_areas_index) || i == j
                continue;
            end
            dist_matrix(i, j) = dist_i_j(cordinates, blocked_cordinates, i, j, piece_length);
        end
    end
    
    % 将其中无法达点设置为无限大
    dist_matrix(dist_matrix == 0) = realmax();
    
end

