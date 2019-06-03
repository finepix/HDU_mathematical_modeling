function [] = plot_solution(W, H, block_size, cordinates, attacked_targets, entrances, blocked_areas_index, all_paths, PLANS_RADIUS, solution_points, solution_plans, best_val)
%UNTITLED17 此处显示有关此函数的摘要
%   此处显示详细说明
    
    addpath('utils');
    
    blocked_points = cordinates(blocked_areas_index, :);
    target_points = cordinates(attacked_targets, :);
    entrance_points = cordinates(entrances, :);
    
    len_path = length(attacked_targets) * length(entrances);    
    COLORS = linspecer(len_path);
    %% 先画画板
    figure();
    title(['detect probability： ', num2str(best_val)]);
    set(gca,'XLim',[0, W]);
    set(gca,'YLim',[-H, 0]);
    interval = W / block_size;
    set(gca,'XTick',[0:interval:W]);
    set(gca,'YTick',[-H:interval:0]);
    grid on;
    
    %% 标点
    % 所有点的数字
    for i=1:block_size*block_size
%         scatter(cordinates(:, 1), cordinates(:, 2), 5, 'filled ');
%         hold on;
        text(cordinates(i,1), cordinates(i,2) - 2, num2str(i));
        hold on;
    end
    % 画target
    scatter(target_points(:, 1), target_points(:, 2), 100, 'filled ')
    hold on;
    % 画entrances
    scatter(entrance_points(:, 1), entrance_points(:, 2), 100, 'rd',  'filled ')
    hold on;
    % 画blocked区域
    for i = 1:size(blocked_points, 1)
        x = blocked_points(i, 1) - interval/2;
        y = blocked_points(i, 2) - interval/2;
        rectangle('position',[x, y, interval, interval], 'EdgeColor','b','FaceColor',[0 .5 .5]);
        hold on;
    end
    
    %%  画线段
    % 取出线段
    for i = 1:length(all_paths)
        path = all_paths{i};
        for j = 1:length(path)-1
            line = [path(j), path(j + 1)];
            pointA = cordinates(line(1), :);
            pointB = cordinates(line(2), :);
            
%             plot(pointA, pointB, '.', 'color', COLORS(i, :), 'MarkerSize', 18);
            plot([pointA(1); pointB(1)], [pointA(2); pointB(2)], 'color', COLORS(i, :), 'LineWidth', 2);
            hold on;
            
        end
    end
    
    %% 画最优解法
    theta = 0:0.01:2*pi;
    for i = 1:size(solution_points, 1)
        for j = 1:size(solution_points, 2)
            circle_center = cordinates(solution_points(i, j), :);
            circle_r = PLANS_RADIUS(solution_plans(i, j));
            x = circle_center(1);
            y = circle_center(2);
            
            C1 = x + circle_r * cos(theta);  
            C2 = y + circle_r * sin(theta);  
            % 圆心
            scatter(x, y, 50, 'k^',  'filled ')
            % 圆
            plot(C1,C2,'k.-','linewidth',1);  
        end
    end
    

end

