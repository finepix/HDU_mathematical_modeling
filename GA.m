%% 遗传算法求解
clear;clc;close all;
% 加载中间结果
load tmp.mat

%% 原始基础参数设置
% W = 1600;
% TOTAL_PLANS = 3;
% PLANS_COST_TABLE = [50000, 40000, 30000];
% MAX_COST = 200000;
% VALUE_MAX = 35000000;

len_targets = length(attacked_targets);
len_entrances = length(entrances);
len_paths = len_targets * len_entrances;

addpath('genetic_algorithm');
addpath('genetic_algorithm\genetic')

%% 筛选一遍，将设点为0的点删除
lens = plans_types{1} - 1;
lens = sum(lens, 2);
tmp_lens_index = find(lens < 0);

%% 遗传算法参数设定

% 待选点的个数
total_used_points = tmp_lens_index;
len_total_used_points = length(tmp_lens_index); 

% 求解探测器的个数范围
M_min = MAX_COST / max(PLANS_COST_TABLE);
M_max = MAX_COST / min(PLANS_COST_TABLE);

% 
best_solution_points = [];
best_solution_plans = [];
global_max_val = 0;

M = 4;                      % 最多选择5个不同的点出来
%% 探索探测器范围空间
% 参数初始化
N = 500;                   % 种群个数
MAX_GENERATIONS = 150;      % 最大迭代次数
pc = 0.5;                   % 交叉概率
pm = 0.1;                   % 变异概率

gen_process = zeros(MAX_GENERATIONS, floor(M_max) - floor(M_min) + 1);

for M = M_min:M_max
    
    % 初始化种群
    populations = [];
    % 选点初始化
    populations.points = zeros(N, M);
    % 探测器方案初始化，1 2 3 (TOTAL_PLANS)种方案，这里直接使用实数进行运算
    populations.plans = zeros(N, M);
    for i = 1:N
        % 产生
        tmp_idx = randperm(len_total_used_points);
        % 添加
        populations.points(i, :) = tmp_idx(1:M);

        while 1
            tmp_plan_idx = unidrnd(TOTAL_PLANS, 1, M);
            [~, is_reasonable] = calculate_cost(tmp_plan_idx, PLANS_COST_TABLE, MAX_COST);

            % TODO：测试
            % fprintf('index:%d, cost:%d, reasonable:%d \n', i, cost, is_reasonable);

            if is_reasonable
                populations.plans(i, :) = tmp_plan_idx;
                break;
            end
        end



    end

    %% 遗传算法主流程
    solution_points = [];
    solution_plans = [];
    best_val = 0;
    for i = 1:MAX_GENERATIONS
        % 计算适应度值
        P = populations;
        fitv = fitness(populations, plans_types, len_paths, PLANS_RADIUS);
        % 第二题开始
%         fitv = fitness_1(populations, plans_types, len_paths, PLANS_RADIUS);
    %     fitV = ranking(fitv);
        % step1:强制筛选最优解保存到模型中
        % 保留最优解
        top_idx = find(fitv == max(fitv));        
        top_populations = [];
        top_populations.points = populations.points(top_idx, :);
        top_populations.plans = populations.plans(top_idx, :);
       
        % 保存最优解
        solution_points = top_populations.points(1, :);
        solution_plans = top_populations.plans(1, :);
        best_val = max(fitv);
        
        % 用于绘图
        gen_process(i, (M - M_min + 1)) = best_val;
        
        % 记录全局最优解
        if global_max_val < max(fitv)
            
            best_solution_points = solution_points;
            best_solution_plans = solution_plans;
            global_max_val = max(fitv);
        end
        % 打印最优解
        fprintf('generation:%d, best val:%.3f\n', i, max(fitv));
        fprintf('选点：')
        disp(top_populations.points(1, :));
        fprintf('方案：')
        disp(solution_plans);

        rest_idx = find(fitv ~= max(fitv));
        tmp_p = populations;
        populations.points = tmp_p.points(rest_idx, :);
        populations.plans = tmp_p.plans(rest_idx, :);
        fitv = fitv(rest_idx);
        % 剩下的参与选择，变异，交叉
%         if length(top_idx) >= 0.8 * N
%             populations = P;
%         end

        % 测试
    %     fitv = fitness(populations);
    % %     fitV = ranking(fitv);
    %     fprintf('####before########best val:%d \n', max(fitv));

        % step2: 选择
        tmp_populations = [populations.points  populations.plans];
        tmp_populations = select('sus',tmp_populations,fitv,1);%select
        populations.points = tmp_populations(:, 1:M);
        populations.plans = tmp_populations(:, M+1:2*M);

    %     % 测试
    %     costs = cul_costs(populations.plans, PLANS_COST_TABLE, MAX_COST);
    %     disp(['选择后：max cost: ', num2str(max(costs))])
    %     
        % step3：交叉
        populations = cross(populations, pc, PLANS_COST_TABLE, MAX_COST);

    %     % 测试
    %     costs = cul_costs(populations.plans, PLANS_COST_TABLE, MAX_COST);
    %     disp(['交叉后：max cost: ', num2str(max(costs))])

        % step4：变异
        populations = mutate_own(populations, pm, PLANS_COST_TABLE, MAX_COST, total_used_points);

    %     % 测试
    %     costs = cul_costs(populations.plans, PLANS_COST_TABLE, MAX_COST);
    %     disp(['变异后：max cost: ', num2str(max(costs))])

        % 测试
    %     fitv = fitness(populations);
    % %     fitV = ranking(fitv);
    %     fprintf('####after########best val:%d \n', max(fitv));

        % step5：组合
%         if size(populations.points, 1) + size(top_populations.points, 1) ~= N
%             continue;
%         end
        tmp_p = populations;
        populations = [];
        populations.points = [top_populations.points; tmp_p.points];
        populations.plans = [top_populations.plans; tmp_p.plans];

    end

    %% 结果展示
    plot_solution(W, H, block_size, cordinates, attacked_targets, entrances, blocked_areas_index, all_paths, PLANS_RADIUS, solution_points, solution_plans, best_val);

end
%% 结果最终展示
plot_solution(W, H, block_size, cordinates, attacked_targets, entrances, blocked_areas_index, all_paths, PLANS_RADIUS, best_solution_points, best_solution_plans, global_max_val);
% 打印最终结果
fprintf('探测器选点：');
disp(best_solution_points);
fprintf('探测器类型');
disp(best_solution_plans);
fprintf('最大探测率');
disp(global_max_val);

% 遗传算法的收敛进程展示，三个图
x = 1:MAX_GENERATIONS;
for i = 1:size(gen_process, 2)
    figure;
    plot(x, gen_process(:, i))
    title(['Genetic algorithm process, num of dectators:', num2str(i + M_min - 1)]);
end

