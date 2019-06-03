function [length] = calculate_circle_line(center, r, A, B, point_target, seted_r)
%UNTITLED ����Բ���߶��ཻ���߶γ���
%     center = [300, -300];
%     r = 220;
%     A = [100 100];
%     B = [400 400];
%     
    %% step1: ������ʼ��
    syms x y
    length = 0;
    % Բ�ķ���
    % circle_equation = sym( (x - center(1))^2 + (y - center(2))^2 - r^2 );
    % ֱ�߷���
    [a, b, c] = quadratic_equation(A, B);

    %% step2���жϵ㵽ֱ�ߵľ��룬������r������������step3��
    dist_line = dist_center2line(center, a, b, c);
    % �ж��Ƿ���Ҫ�����ýڵ�
    if dist_line >= r 
        return;
    end
    
    %% step3���ж������Ƿ���Բ�ڣ����ǣ���ô�Ͳ��ý����������
    % 1��������Ƿ���Բ�ڣ�������a��b��c���������
    dist_A = distance_two_points(center, A);
    dist_B = distance_two_points(center, B);
    
    %       a��������Բ�ڣ������ߵľ��룻
    if dist_A < r && dist_B < r
%         length = distance_two_points(A, B);
        length = cut_target_circle(A, B, point_target, seted_r, x, y);
        return;
    end
    
    %       b����������Բ�ڣ�����ֱ�Ӽ��㣻
    if dist_A >= r && dist_B >= r
        [C, D] = get_crossover_point(center, r, a, b, c, x, y);
        
        if isempty(C) || isempty(D)         % �ж��Ƿ�Ϊ�գ���һ����������޽���
            return;
        end
        % ���������㶼���߶����棬 ��ôֱ�Ӳ���
        if ~is_inside_line(C, A, B) && ~is_inside_line(D, A, B) 
            return;
        end
        
        if isreal(C) && isreal(D)           % �ж��Ƿ�Ϊʵ��
%             length = distance_two_points(C, D);
            length = cut_target_circle(C, D, point_target, seted_r, x, y);
            return;
        end
    end
    
    %       c����ֻ��һ������Բ��
    if (dist_A < r && dist_B >= r) || (dist_A >= r && dist_B < r)
        
        % 1���õ�����
        [C, D] = get_crossover_point(center, r, a, b, c, x, y);
        
        %2���ж��Ƿ�Ϊ�գ���һ����������޽���
        if isempty(C) || isempty(D) 
            return;
        end
        
        % 3���ж��Ƿ�Ϊʵ��
        if ~isreal(C) || ~isreal(D)   
            return;
        end
        
        % 4���ж���һ�����������߶��ڵ�
        % ��C���߶��ڲ�������ֻ���ж�AB��һ����Բ��
        if is_inside_line(C, A, B)
            if dist_A < r
%                 length = distance_two_points(A, C);
                length = cut_target_circle(A, C, point_target, seted_r, x, y);
                return;
            end
%             length = distance_two_points(B, C);
            length = cut_target_circle(B, C, point_target, seted_r, x, y);
        end
        % ��D������
        if is_inside_line(D, A, B)
            if dist_A < r
%                 length = distance_two_points(A, D);
                length = cut_target_circle(A, D, point_target, seted_r, x, y);
                return ;
            end
%             length = distance_two_points(B, D);
            length = cut_target_circle(B, D, point_target, seted_r, x, y);
        end
        
    end
    
end



function [C, D] = get_crossover_point(center, r, a, b, c, x, y)
% ���ֱ����ֱ�߽���
    
    % ��ʼ��CD
    C = [];
    D = [];
    
    % a�������жϱ���ģ������ڰ뾶��ֱ���޽�
    dist_line = dist_center2line(center, a, b, c);
    % �ж��Ƿ���Ҫ�����ýڵ�
    if dist_line >= r 
        return;
    end
    
    % b����ⷽ����
    s = solve((x - center(1))^2 + (y - center(2))^2 == r^2, a*x + b*y + c, x, y);
    X = double(s.x);
    Y = double(s.y);
    
    % c����ֻ��һ�����㣬��ô���ص�CD�þ�������
    if length(X) == 1
        return;
    end
    
    % d���õ�����
    C = [X(1) Y(1)];
    D = [X(2) Y(2)];
end

function [flag] = is_inside_line(P, A, B)
% �жϵ��Ƿ��ڸ����߶��ϣ��������߶���
    % ��ʼ��Ϊ�����߶��ڲ�
    flag = 0;
    
    % ������������
    vec1 = P - A;
    vec2 = P - B;
    
    % �˻��ж������Դ���н���Ϣ
    v = vec1 * vec2';
    
    if v < 0
        flag = 1;
    end

end

function [len] = cut_target_circle(A, B, target_point, seted_r, x, y)
% �����ļ����׾������ABΪ������õ���Ч���߶�
    
    % AB�߶η�����
    [a, b, c] = quadratic_equation(A, B);
    
    % Ĭ����A��B�ĳ���
    len = distance_two_points(A, B);
    
    % �����ѵ��߶ε�Ŀ��ľ���
    dist_A = distance_two_points(A, target_point);
    dist_B = distance_two_points(B, target_point);

    % a��������Բ��
    if dist_A <= seted_r && dist_B <= seted_r
        len = 0;
        return;
    end

    % b�����㶼����Բ��
    if dist_A >= seted_r && dist_B >= seted_r
        return;
    end

    % b��һ����Բ��
    [C, D] = get_crossover_point(target_point, seted_r, a, b, c, x, y);
    if dist_A < seted_r && dist_B >= seted_r    % A ��Բ��
        % C��AB�߶���
        if is_inside_line(C, A, B)
            len = distance_two_points(C, B);
            return;
        end
        % D��AB�߶���
        if is_inside_line(D, A, B)
            len = distance_two_points(D, B);
            return;
        end
    end
    if dist_A >= seted_r && dist_B < seted_r    % B ��Բ��
        % C��AB�߶���
        if is_inside_line(C, A, B)
            len = distance_two_points(C, A);
            return;
        end
        % D��AB�߶���
        if is_inside_line(D, A, B)
            len = distance_two_points(D, A);
            return;
        end
    end

end




