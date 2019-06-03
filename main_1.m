%% 第一题（由于图中给定的路径需要自己手动输入，鉴于后续题目还是会用到路径规划，这里直接做了）
%% 以下作用：
%		1、构建基本图邻接矩阵；
%		2、求得路径；
%		3、计算每一个block_size*block_size（例如，8*8）的地图上探测器可能安装的顶点；
%		4、在该点上模拟TOTAL_PLANS（3）种探测器方案；
%		5、求得每一个模拟点的每一种方案，对于各个路径的探测率影响。
% PS：这样提前算出所有的影响，后续的遗传算法就不用费力去计算，仅仅只需要关注：适应度函数、交叉、变异策略就行。

%% 结构构建
addpath('calculate_dist');
addpath('genetic_algorithm');
clear;clc;
% 方案参数
TOTAL_PLANS = 3;
MAX_COST = 200000;
% 需设置的参数
PLANS_COST_TABLE = [50000, 40000, 30000];
PLANS_RADIUS = [220 200 180];
PLANS_PH = [0.006 0.005 0.004];

% 地图参数
W = 1600;
H = 1600;
% seted_r = v * t
seted_r = 20 * 10;

%% 地图参数设置
%% 第一题
% 入口
entrances = [32 33 58 62];
% 被攻击目标
attacked_targets = [12 29];
% 封闭区域
blocked_areas_index = [13 14 18 39 40 52];
% 块大小
block_size = 8;
total_size = block_size * block_size;

%% 
% 获取每一个序列对应的坐标点， 原始点为序号1左上角（0, 0）
index = 1 : block_size * block_size;
[x, y] = index2coordinate(index, W, H, block_size);

cordinates = [x; y]';

clear index x y
%% 求得威胁船只需要经过的路径
% 每一个小方格的边长
piece_length = W / block_size;

% step1: 计算邻接矩阵
dist_matrix = zeros(block_size^2, block_size^2);
dist_matrix = build_dist_matrix(cordinates, blocked_areas_index, piece_length, dist_matrix);

dist_matrix = max(dist_matrix, dist_matrix');
dist_matrix = sparse(dist_matrix);

% step2： 求解路径
all_paths = cell(length(entrances), length(attacked_targets));

for i = 1:length(entrances)
    % 原点
    source = entrances(i);
    
    for j = 1:length(attacked_targets)
        % 目的点
        target = attacked_targets(j);
        
        [distance , path, ~]=graphshortestpath(dist_matrix, source, target, 'Directed', false); % Directed是标志图为有向或无向的属性，该图是无向图，对应的属性值为false，或0。
        % TODO:删除
        fprintf('origin: %d, target: %d, distance:%.2f, path:', source, target, distance);
        disp(path)
        all_paths{i, j} = path;
    end
end

all_paths = reshape(all_paths, length(entrances) * length(attacked_targets), 1);

% step3： 建立已有路径的线段方程
% 计算cell长度
line_length = 0;
for i = 1:length(all_paths)
    path = all_paths{i};
    line_length = line_length + length(path) - 1;
end
% 取出线段
lines = cell(1, line_length);
index = 1;
for i = 1:length(all_paths)
    path = all_paths{i};
    for j = 1:length(path)-1
        line = [path(j), path(j + 1)];
        lines{index} = line;
        index = index + 1;
    end
end

clear i j source target path line_length line

%% 建立 3 * 64 * 8的路径

plans_types = cell(TOTAL_PLANS, 1);

len_entrances = length(entrances);
len_targets = length(attacked_targets);

for i = 1:TOTAL_PLANS
    contributes = zeros(total_size, len_entrances*len_targets);
    % 方案半径
    radius = PLANS_RADIUS(i);
    for j = 1:total_size
        for k = 1:len_entrances*len_targets
            
            % 取出每一条路径
            path = all_paths{k};
            % 目标点
            target_point_idx = path(length(path));
            target_point = cordinates(target_point_idx, :);
            
            % 遍历每一条子路径
            for v = 1:length(path)-1
                
                line = [path(v), path(v + 1)];
                pointA = cordinates(line(1), :);
                pointB = cordinates(line(2), :);
%                 % 测试
%                 fprintf('line: %d %d, point: %d, length=\n', line(1), line(2), 29);      
%                 len = calculate_circle_line(cordinates(29, :), 200, pointA, pointB, target_point, seted_r)
                
                len = calculate_circle_line(cordinates(j, :), radius, pointA, pointB, target_point, seted_r);
                % TODO：删除
                fprintf('line: %d %d, point: %d, length=%.2f\n', line(1), line(2), j, len);      
                
                contributes(j, k) = contributes(j, k) + len;
            end
        end
    end
    contributes = calculate_Pfail(contributes, PLANS_PH(i));
    
    % 将contributes加入总的cell中
    plans_types{i} = contributes;
end

%% 清理资源以及保存中间结果，用于后续的遗传算法调用
clear line lines pointA pointB len index i j k v len len_entrances len_targets lens line path contributes distance target_point target_point_idx  
save tmp.mat

%% 测试
% tic;
% all_lengths = {};
% lens = zeros(total_size, 1);
% for i = 1:length(lines)
%     line = lines{i};
%     pointA = cordinates(line(1), :);
%     pointB = cordinates(line(2), :);
%     for j = 1:total_size
%         
%         % 如果该节点为阴影节点，跳过
%         % if ismember(j, blocked_areas_index)
%         %     disp(12);
%         % end
%         
% %         len = calculate_circle_line(cordinates(j, :), 200, pointA, pointB, point_target, seted_r);
% %         lens(j) = lens(j) + len;
% %         fprintf('line: %d %d, point: %d, length=%d.\n', line(1), line(2), j, len);
%     end
% end
% all_lengths{1} = lens;
% toc;
