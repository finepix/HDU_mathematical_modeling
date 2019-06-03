function [ dist_matrix ] = build_dist_matrix( cordinates, blocked_areas_index, piece_length, dist_matrix)
%UNTITLED3 �����ڽӾ������ں�����ֻ��·���滮

    % ��ȡ��Ӱ��������
    blocked_cordinates = cordinates(blocked_areas_index, :);
    
    for i = 1:size(cordinates, 1)
        % ������Ӱ���֣�����
        if ismember(i, blocked_areas_index)
            continue;
        end
        
        for j = 1:size(cordinates, 1)
             % ������Ӱ���֣�����
            if ismember(j, blocked_areas_index) || i == j
                continue;
            end
            dist_matrix(i, j) = dist_i_j(cordinates, blocked_cordinates, i, j, piece_length);
        end
    end
    
    % �������޷��������Ϊ���޴�
    dist_matrix(dist_matrix == 0) = realmax();
    
end

