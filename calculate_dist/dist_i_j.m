function [ dist ] = dist_i_j( cordinates, blocked_cordinates, i, j, piece_length)

    pointA = cordinates(i, :);
    pointB = cordinates(j, :);
    % ��ʼ�趨���ֵ
    dist = realmax();
    
    % �ж��Ƿ�ύ����Ӱ����
    for k = 1:size(blocked_cordinates, 1)
        % x����
        tmp_x1 = blocked_cordinates(k, 1) - piece_length / 2;
        tmp_x2 = blocked_cordinates(k, 1) + piece_length / 2;
        
        % y����
        tmp_y1 = blocked_cordinates(k, 2) - piece_length / 2;
        tmp_y2 = blocked_cordinates(k, 2) + piece_length / 2;
        
        % �����ж�
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
    
    % ����ֱ��·�����ڣ���ȡֱ��·������
    dist = sqrt((pointA - pointB) * (pointA - pointB)');

end
