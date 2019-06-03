function [length] = calculate_circle_line(center, r, A, B, point_target, seted_r)
%UNTITLED 计算圆和线段相交的线段长度
%     center = [300, -300];
%     r = 220;
%     A = [100 100];
%     B = [400 400];
%     
    %% step1: 参数初始化
    syms x y
    length = 0;
    % 圆的方程
    % circle_equation = sym( (x - center(1))^2 + (y - center(2))^2 - r^2 );
    % 直线方程
    [a, b, c] = quadratic_equation(A, B);

    %% step2：判断点到直线的距离，若大于r，跳过，否则到step3；
    dist_line = dist_center2line(center, a, b, c);
    % 判断是否需要跳过该节点
    if dist_line >= r 
        return;
    end
    
    %% step3：判断两点是否都在圆内，若是，那么就不用建立方程求解
    % 1、计算点是否都在圆内：（以下a、b、c三种情况）
    dist_A = distance_two_points(center, A);
    dist_B = distance_two_points(center, B);
    
    %       a、若都在圆内，则两者的距离；
    if dist_A < r && dist_B < r
%         length = distance_two_points(A, B);
        length = cut_target_circle(A, B, point_target, seted_r, x, y);
        return;
    end
    
    %       b、若都不在圆内，后续直接计算；
    if dist_A >= r && dist_B >= r
        [C, D] = get_crossover_point(center, r, a, b, c, x, y);
        
        if isempty(C) || isempty(D)         % 判断是否为空，即一个交点或者无交点
            return;
        end
        % 若两个交点都在线段外面， 那么直接不管
        if ~is_inside_line(C, A, B) && ~is_inside_line(D, A, B) 
            return;
        end
        
        if isreal(C) && isreal(D)           % 判断是否为实数
%             length = distance_two_points(C, D);
            length = cut_target_circle(C, D, point_target, seted_r, x, y);
            return;
        end
    end
    
    %       c、若只有一个点在圆内
    if (dist_A < r && dist_B >= r) || (dist_A >= r && dist_B < r)
        
        % 1、得到交点
        [C, D] = get_crossover_point(center, r, a, b, c, x, y);
        
        %2、判断是否为空，即一个交点或者无交点
        if isempty(C) || isempty(D) 
            return;
        end
        
        % 3、判断是否为实数
        if ~isreal(C) || ~isreal(D)   
            return;
        end
        
        % 4、判断哪一个交点是在线段内的
        % 若C在线段内部，后续只需判断AB哪一个在圆内
        if is_inside_line(C, A, B)
            if dist_A < r
%                 length = distance_two_points(A, C);
                length = cut_target_circle(A, C, point_target, seted_r, x, y);
                return;
            end
%             length = distance_two_points(B, C);
            length = cut_target_circle(B, C, point_target, seted_r, x, y);
        end
        % 若D在线外
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
% 求解直线与直线交点
    
    % 初始化CD
    C = [];
    D = [];
    
    % a、基本判断必须的，若大于半径，直接无解
    dist_line = dist_center2line(center, a, b, c);
    % 判断是否需要跳过该节点
    if dist_line >= r 
        return;
    end
    
    % b、求解方程组
    s = solve((x - center(1))^2 + (y - center(2))^2 == r^2, a*x + b*y + c, x, y);
    X = double(s.x);
    Y = double(s.y);
    
    % c、若只有一个交点，那么返回的CD得经过处理
    if length(X) == 1
        return;
    end
    
    % d、得到顶点
    C = [X(1) Y(1)];
    D = [X(2) Y(2)];
end

function [flag] = is_inside_line(P, A, B)
% 判断点是否在给定线段上，或者在线段外
    % 初始化为不在线段内部
    flag = 0;
    
    % 构建两个向量
    vec1 = P - A;
    vec2 = P - B;
    
    % 乘积判断正负以代表夹角信息
    v = vec1 * vec2';
    
    if v < 0
        flag = 1;
    end

end

function [len] = cut_target_circle(A, B, target_point, seted_r, x, y)
% 将最后的几百米距离减掉AB为最终求得的有效的线段
    
    % AB线段方程组
    [a, b, c] = quadratic_equation(A, B);
    
    % 默认是A到B的长度
    len = distance_two_points(A, B);
    
    % 计算已得线段到目标的距离
    dist_A = distance_two_points(A, target_point);
    dist_B = distance_two_points(B, target_point);

    % a、两点在圆内
    if dist_A <= seted_r && dist_B <= seted_r
        len = 0;
        return;
    end

    % b、两点都不在圆内
    if dist_A >= seted_r && dist_B >= seted_r
        return;
    end

    % b、一点在圆内
    [C, D] = get_crossover_point(target_point, seted_r, a, b, c, x, y);
    if dist_A < seted_r && dist_B >= seted_r    % A 在圆内
        % C于AB线段内
        if is_inside_line(C, A, B)
            len = distance_two_points(C, B);
            return;
        end
        % D于AB线段内
        if is_inside_line(D, A, B)
            len = distance_two_points(D, B);
            return;
        end
    end
    if dist_A >= seted_r && dist_B < seted_r    % B 在圆内
        % C于AB线段内
        if is_inside_line(C, A, B)
            len = distance_two_points(C, A);
            return;
        end
        % D于AB线段内
        if is_inside_line(D, A, B)
            len = distance_two_points(D, A);
            return;
        end
    end

end




