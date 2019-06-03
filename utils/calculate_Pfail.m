function [ Pfail ] = calculate_Pfail( contributes, PLAN_PH )
%UNTITLED16 计算总的失败率
%   此处显示详细说明
    Pfail = 1 - calculate_SDh(contributes, PLAN_PH);

end

function [SDh] = calculate_SDh(contributes, PLAN_PH)
    
    SDh = 1 - exp(-contributes * PLAN_PH);
end